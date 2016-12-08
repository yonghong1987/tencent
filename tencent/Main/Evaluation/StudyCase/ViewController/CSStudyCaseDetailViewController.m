//
//  CSStudyCaseDetailViewController.m
//  tencent
//
//  Created by admin on 16/5/18.
//  Copyright © 2016年 cyh. All rights reserved.
//

#import "CSStudyCaseDetailViewController.h"
#import "CSExtensionReadViewController.h"
#import "CSTrueExamView.h"
#import "NSDictionary+convenience.h"
#import "MJRefresh.h"
@interface CSStudyCaseDetailViewController ()<UITableViewDelegate,UITableViewDataSource,CSGetMultiseStringDelegate>
/*
 **案列table
 */
@property (nonatomic, strong) SMBaseTableView *caseTable;
@property (nonatomic, strong) CSTableHeadWebView *tableHeadView;
/**
 *  判断webview是否加载完成
 */
@property (nonatomic, assign) BOOL isComplete;

@property (nonatomic, strong) CSCaseCommentView *inputBoxView;//评论输入视图
@property (nonatomic, strong) UIView *backView;//背景View
@property (nonatomic, strong) CSStudyCaseDetailModel *caseDetailModel;
//提交选择题时的答案字符串
@property (nonatomic, copy) NSString *chooseAnswerString;
//提交非选择题的答案字符串
@property (nonatomic, copy) NSString *questionString;

@property (nonatomic, strong) CSToolButtonView *praiseView;//点赞
@property (nonatomic, strong) CSToolButtonView *replyView;//点击sectionHead回复
@property (nonatomic, strong) CSToolButtonView *cellReplyView;//点击cell回复
@property (nonatomic, strong) UIImageView *gapIV;
//是否能作答
@property (nonatomic, strong) NSNumber *canAnswer;

@property (nonatomic, assign) NSInteger currentPage;
@end

@implementation CSStudyCaseDetailViewController
static NSString *commitCellIdentifier = @"commitCell";

static NSString *answerCellIdentifier = @"answerCell";
static NSString *askAndAnswerCellIdentifier = @"askAndAnswerCell";

static NSString *radioCellIdentifier = @"radioCell";
static NSString *radioAnswerCellIdentifier = @"radioAnswerCell";
static NSString *multiselectCellIdentifier = @"multiselectCell";
static NSString *multiselectAnswerCellIdentifier = @"multiselectAnswerCell";
static NSString *judgeCellIdentifier = @"judgeCell";
static NSString *judgeAnswerCellIdentifier = @"judgeAnswerCell";
static NSString *fillBlankCellIdentifier = @"fillBlankCell";
static NSString *commentIdentifier = @"commentCell";
static NSString *replyCommentIdentifier = @"replyCommentCell";
- (void)viewDidLoad {
    [super viewDidLoad];
    self.isComplete = false;
    self.title = @"学案例";
    self.currentPage = 1;
    [self loadData:YES];
    // Do any additional setup after loading the view.
}

#pragma mark controlInit
-(void)addTableCaseDetailModel:(CSStudyCaseDetailModel *)caseDetailModel{
    #warning todo   需调整
    self.caseTable = [[SMBaseTableView alloc] initWithFrame:CGRectMake(0, 20, kCSScreenWidth, kCSScreenHeight - 64 - 50 - 20) style:UITableViewStyleGrouped];
    self.caseTable.delegate = self;
    self.caseTable.dataSource = self;
    self.caseTable.sectionFooterHeight = 0;
    self.caseTable.backgroundColor = kBGColor;
    self.caseTable.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.caseTable];
    [self addTableHeadViewCaseDetailModel:caseDetailModel];
    
    [self.caseTable registerClass:[CSSubjectiveAnswerCell class] forCellReuseIdentifier:answerCellIdentifier];
    [self.caseTable registerClass:[CSAskAndAnswerCell class] forCellReuseIdentifier:askAndAnswerCellIdentifier];
    [self.caseTable registerClass:[CSRadioCell class] forCellReuseIdentifier:radioCellIdentifier];
    [self.caseTable registerClass:[CSRadioAnswerCell class] forCellReuseIdentifier:radioAnswerCellIdentifier];
    [self.caseTable registerClass:[CSMultiselectCell class] forCellReuseIdentifier:multiselectCellIdentifier];
    [self.caseTable registerClass:[CSMultiselectAnswerCell class] forCellReuseIdentifier:multiselectAnswerCellIdentifier];
    [self.caseTable registerClass:[CSJudgeCell class] forCellReuseIdentifier:judgeCellIdentifier];
    [self.caseTable registerClass:[CSFillBlankCell class] forCellReuseIdentifier:fillBlankCellIdentifier];
    [self.caseTable registerClass:[CSJudgeAnswerCell class] forCellReuseIdentifier:judgeAnswerCellIdentifier];
    
    self.caseTable.mj_footer = [MJRefreshAutoFooter footerWithRefreshingTarget:self refreshingAction:@selector(refresh)];
    self.caseTable.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(headRefresh)];
}

-(void)addTableHeadViewCaseDetailModel:(CSStudyCaseDetailModel *)caseDetailModel{
    self.tableHeadView  = [[CSTableHeadWebView alloc]initWithFrame:CGRectMake(0, 0, kCSScreenWidth, 1)];
    self.tableHeadView.htmlString = caseDetailModel.caseQuestionTitle;
    self.tableHeadView.topicTitle = [CSDisplayWitchTitleModel passTitleWithCaseDetailModel:caseDetailModel];
    WS(weakSelf);
    self.tableHeadView.passWebViewHeightBlock = ^ (CGFloat height){
        //加载完成
        weakSelf.isComplete = YES;
        //改变题目高度
        CGRect frame = weakSelf.tableHeadView.frame;
        frame.size.height = height;
        weakSelf.tableHeadView.frame = frame;
        //刷新试题
        weakSelf.caseTable.tableHeaderView = weakSelf.tableHeadView;
        [weakSelf.caseTable reloadData];
    };
}

- (void)addInputBox{
    WS(weakSelf);
    self.inputBoxView = [[CSCaseCommentView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height - 50, self.view.frame.size.width, 50)];
    self.inputBoxView.placeholder = @"  请输入评论...";
    self.inputBoxView.countString = [NSString stringWithFormat:@"%ld评论",[self.caseDetailModel.commentCount integerValue]];
    [self.view addSubview:self.inputBoxView];
    self.inputBoxView.didCommentVC = ^(){
        CSSpecialCommentViewController *commentVC = [[CSSpecialCommentViewController alloc]init];
        commentVC.targetid = weakSelf.caseId;
        commentVC.commentType = kCommentCaseType;
        [weakSelf.navigationController pushViewController:commentVC animated:YES];
    };
    [self.inputBoxView setDidEndInputBlock:^(BOOL success, NSString *content) {
        if (success) {
            [weakSelf commitCommentWithContent:content parentid:nil targetid:weakSelf.caseId targetType:kCommentCaseType beCommeentUserid:nil indexPath:[NSIndexPath indexPathForRow:-1 inSection:-1] specialCommentModel:nil];
        }else{
            DLog(@"error");
        }
    }];
}

-(void)headRefresh{
[self loadData:YES];
}

-(void)refresh{
    [self loadData:NO];
}

- (void)loadData:(BOOL)reload{
    if (reload) {
        [self.caseTable removeFromSuperview];
        self.currentPage = 1;
    }
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setValue:self.caseId forKey:@"caseId"];
    [params setValue:@(self.currentPage) forKey:@"page"];
    [params setValue:@(CONST_RP) forKey:@"rp"];
   [[CSHttpRequestManager shareManager] postDataFromNetWork:GET_CASE_DETAIL parameters:params success:^(CSHttpRequestManager *manager, id model) {
       
       if (reload) {
           self.currentPage ++;
           self.caseDetailModel = [[CSStudyCaseDetailModel alloc]initWithDictionary:model[@"caseEntity"] error:nil];
           NSInteger alreadyOverTime = [self.caseDetailModel.alreadyOverTime integerValue];
           NSInteger alreadySubmit = [self.caseDetailModel.alreadySubmit integerValue];
           if (alreadySubmit == 0) {
               self.canAnswer = @(1);
           }else{
               self.canAnswer = @(0);
           }
           if (alreadyOverTime == 0 && alreadySubmit == 0) {
               
           }else if (alreadySubmit == 1 || alreadyOverTime == 1){
               [self creatExtentionRead];
               
           }
           NSArray *chopOptions = model[@"chopOptionList"];
           NSMutableArray *options = [NSMutableArray array];
           for (NSDictionary *optionDic in chopOptions) {
               CSOptionModel *optionModel = [[CSOptionModel alloc]initWithDictionary:optionDic error:nil];
               [options addObject:optionModel];
           }
           self.caseDetailModel.optionArray = options;
       }else{
           self.currentPage ++;
       }
      
       
       NSMutableArray *comments = [NSMutableArray array];
       NSArray *array = model[@"commmentList"];
       for (NSDictionary *commentDic in array) {
           CSSpecialCommentModel *commentModel = [[CSSpecialCommentModel alloc] initWithDictionary:commentDic error:nil];
           CSUserModel *user = [[CSUserModel alloc]initWithDictionary:commentDic[@"user"] error:nil];
           commentModel.userModel = user;
           commentModel.replyComments = [NSMutableArray array];
          NSArray *replyCommentArr = [commentDic arrayForKey:@"replyList"];
           if (replyCommentArr.count > 0) {
               for (NSDictionary *replyDic in replyCommentArr) {
                   CSReplyCommentModel *replyComment = [[CSReplyCommentModel alloc] initWithDictionary:replyDic error:nil];
                   CSUserModel *user = [[CSUserModel alloc]initWithDictionary:commentDic[@"user"] error:nil];
                   replyComment.userModel = user;
                   [commentModel.replyComments addObject:replyComment];
               }
           }
           [comments addObject:commentModel];
       }
       //往评论数组中加2个空对象
       NSMutableArray *nullArray = [NSMutableArray array];
       if (reload) {
               CSSpecialCommentModel *commentModel0 = [CSSpecialCommentModel new];
               CSSpecialCommentModel *commentModel1 = [CSSpecialCommentModel new];
               [nullArray addObject:commentModel0];
               [nullArray addObject:commentModel1];
           [nullArray addObjectsFromArray:comments];
           self.caseDetailModel.commments = nullArray;
           CSTrueExamView *trueExamView = [[CSTrueExamView alloc]initWithFrame:CGRectMake(0, 0, kCSScreenWidth, 20)];
           [self.view addSubview:trueExamView];
           [self addTableCaseDetailModel:self.caseDetailModel];
           [self.caseTable reloadData];
           [self addInputBox];
       }else{
           [self.caseDetailModel.commments addObjectsFromArray:comments];
           [self.caseTable reloadData];
           [self.caseTable endRefreshing];
       }
   } failture:^(CSHttpRequestManager *manager, id nodel) {
      [self.caseTable endRefreshing];
   }];
}

//创建延伸阅读按钮
-(void)creatExtentionRead{
    WS(weakSelf);
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem itemWithBtnTitle:@"延伸阅读" actionBolock:^(UIBarButtonItem *button) {
        CSExtensionReadViewController *extensionRead = [[CSExtensionReadViewController alloc]init];
        extensionRead.caseId = self.caseId;
        extensionRead.extensionReadType = CSExtensionReadCaseType;
        [weakSelf.navigationController pushViewController:extensionRead animated:YES];
    }];

}
#pragma mark UITableViewDelegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if (self.isComplete == true) {
        return self.caseDetailModel.commments.count;
    }
    return 0;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (self.isComplete == true) {
        CSSpecialCommentModel *specialCommentModel = self.caseDetailModel.commments[section];
        if (section == 0) {
            if ([self.caseDetailModel.caseQuestionType isEqualToString:kTopicQuestionType]) {
                return 1;
            }else{
                return self.caseDetailModel.optionArray.count;
            }
        }else if (section == 1){
            return 1;
        }else{
            CSSpecialCommentModel *specialCommentModel = self.caseDetailModel.commments[section];
            return specialCommentModel.replyComments.count;
        }
        return specialCommentModel.replyComments.count;

    }
    return 2;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        //是否显示答案
        //如果已经作答
        if ([self.caseDetailModel.alreadySubmit integerValue] > 0) {
            UITableViewCell *cell = [CSCaseDetailCellDataModel updateCellForRowWithCaseDetailModel:self.caseDetailModel tableView:tableView indexPath:indexPath];
            return cell;
            //如果还没有作答
        }else{
            NSInteger alreadyOverTime = [self.caseDetailModel.alreadyOverTime integerValue];
            //如果已过期
            if (alreadyOverTime == 1) {
                UITableViewCell *cell = [CSCaseDetailCellDataModel updateCellForRowWithCaseDetailModel:self.caseDetailModel tableView:tableView indexPath:indexPath];
                return cell;
            }else{
                CSCaseDetailCellDataModel *detailCellDataModel = [CSCaseDetailCellDataModel new];
                detailCellDataModel.canAnswer = self.canAnswer;
                UITableViewCell *cell = [detailCellDataModel updateCellForRowNoAnswerWithCaseDetailModel:self.caseDetailModel tableView:tableView indexPath:indexPath];
                if ([self.caseDetailModel.caseQuestionType isEqualToString:kTopicNoItemType] || [self.caseDetailModel.caseQuestionType isEqualToString:kTopicMultiSelectType]){
                    if ([cell isMemberOfClass:[CSMultiselectCell class]]) {
                        CSMultiselectCell *multiseCell = (CSMultiselectCell *)cell;
                        multiseCell.delega = self;
                        return multiseCell;
                    }
                }else{
                    return cell;
                }

            }
        }
    }
     if (indexPath.section == 1) {
        //显示提交按钮或者专家观点
        //已经提交，显示专家观点
        if ([self.caseDetailModel.alreadySubmit boolValue] == true) {
            CSSubjectiveAnswerCell *cell = [tableView dequeueReusableCellWithIdentifier:answerCellIdentifier];
            cell.section = indexPath.section;
            cell.answerPromptLabel.text = @"答案解析:";
            cell.caseDetailModel = self.caseDetailModel;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        }else{
            //未提交，如果已过期，则显示自己的答案   显示提交按钮
            NSInteger alreadyOverTime = [self.caseDetailModel.alreadyOverTime integerValue];
            if (alreadyOverTime == 1) {
                CSSubjectiveAnswerCell *cell = [tableView dequeueReusableCellWithIdentifier:answerCellIdentifier];
                cell.section = indexPath.section;
                cell.answerPromptLabel.text = @"答案解析:";
                cell.caseDetailModel = self.caseDetailModel;
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                return cell;
            }else{
                //如果未过期
                UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:commitCellIdentifier];
                if (!cell) {
                    cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:commitCellIdentifier];
                }
                CSCommitCaseAnswerView *answerView = [[CSCommitCaseAnswerView alloc]initWithFrame:CGRectMake(0, 0, kCSScreenWidth, 56)];
                answerView.canAnswer = self.canAnswer;
                answerView.commitAction = ^(){
                    [self commitCaseAnswerCaseQuestionType:self.caseDetailModel.caseQuestionType caseDetailModel:self.caseDetailModel];
                };
                [cell.contentView addSubview:answerView];
                return cell;
            }
        }
    }
    
    //评论
    CSReplyCommentCell *cell = [tableView dequeueReusableCellWithIdentifier:replyCommentIdentifier];
    if (!cell) {
        cell = [[CSReplyCommentCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:replyCommentIdentifier];
    }
    CSSpecialCommentModel *commentModel = self.caseDetailModel.commments[indexPath.section];
    CSReplyCommentModel* replyCommentModel = commentModel.replyComments[indexPath.row];
    cell.commentType = CSCommentStudyCaseType;
    cell.replyCommentModel = replyCommentModel;
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    CSReplyCommentCell *cell = (CSReplyCommentCell *)[self tableView:self.caseTable cellForRowAtIndexPath:indexPath];
    NSInteger alreadyOverTime = [self.caseDetailModel.alreadyOverTime integerValue];
    if (indexPath.section == 0) {
            //是否显示答案
            //如果已经作答了,显示答案
            if ([self.caseDetailModel.alreadySubmit integerValue] > 0) {
                return [CSCaseDetailCellDataModel getCellHeightWithCaseDetailModel:self.caseDetailModel tableView:tableView indexPath:indexPath];
            }else{
                 //未提交，如果已过期，则显示自己的答案
                if (alreadyOverTime == 1){
                return [CSCaseDetailCellDataModel getCellHeightWithCaseDetailModel:self.caseDetailModel tableView:tableView indexPath:indexPath];
                }else{
                    //问答题
                    return [CSCaseDetailCellDataModel getNoAnswerCellHeightWithCaseDetailModel:self.caseDetailModel tableView:tableView indexPath:indexPath];
                }
                
            }
    }
    if (indexPath.section == 1){
        //是否已经提交答案
        if ([self.caseDetailModel.alreadySubmit boolValue] == true) {
            CGFloat height = 100;
            CGSize size = CGSizeMake(kCSScreenWidth - 20 , 2000);
            CGSize labelSize = [self.caseDetailModel.viewPoint sizeWithFont:[UIFont systemFontOfSize:14] constrainedToSize:size lineBreakMode:NSLineBreakByWordWrapping];
            height += labelSize.height;
            return height;
        }else{
            
            if (alreadyOverTime == 1) {
                CGFloat height = 100;
                CGSize size = CGSizeMake(kCSScreenWidth - 20 , 2000);
                CGSize labelSize = [self.caseDetailModel.viewPoint sizeWithFont:[UIFont systemFontOfSize:14] constrainedToSize:size lineBreakMode:NSLineBreakByWordWrapping];
                height += labelSize.height;
                return height;

            }else{
            return 56;
            }
        }
    }
    return 0;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    //找到点击的cell在可视区域的位置
    if (indexPath.section == 0) {
        //未提交
        if ([self.caseDetailModel.alreadySubmit integerValue] == 0) {
            //如果是单选
            if ([self.caseDetailModel.caseQuestionType isEqualToString:kTopicSingleType]) {
                self.chooseAnswerString = [CSCaseDetailCellDataModel getSingleStringWithTableView:self.caseTable indexPath:indexPath];
                CSOptionModel *option = self.caseDetailModel.optionArray[indexPath.row];
                option.isSelected = true;
                
                //如果是多选或者不定项选择
            }else if ([self.caseDetailModel.caseQuestionType isEqualToString:kTopicNoItemType] || [self.caseDetailModel.caseQuestionType isEqualToString:kTopicMultiSelectType]){
                CSMultiselectCell *cell = [tableView cellForRowAtIndexPath:indexPath];
                [cell didSelectCell];
                [self getChopIdString];
                //如果是判断题
            }else if ([self.caseDetailModel.caseQuestionType isEqualToString:kTopicJudgeType]){
                self.questionString = [CSCaseDetailCellDataModel getJudgeStringWithTableView:self.caseTable indexPath:indexPath];
            }
        }
    }else if (indexPath.section == 1){
    
    }else{
        //转换坐标
        self.backView = [[UIView alloc] initWithFrame:self.view.bounds];
        [self.view insertSubview:self.backView aboveSubview:self.caseTable];
        UITapGestureRecognizer *tapGes = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideBackView)];
        [self.backView addGestureRecognizer:tapGes];
        CGRect rectInTableView = [tableView rectForRowAtIndexPath:indexPath];
        CGRect rect = [tableView convertRect:rectInTableView toView:[tableView superview]];
        self.cellReplyView = [[CSToolButtonView alloc] initWithFrame:CGRectMake(rect.size.width / 2 - 55 , (2 * rect.origin.y + rect.size.height) / 2 - 25, 110, 50)];
    }
    self.cellReplyView.backgroundColor = CSColorFromRGB(51.0, 51.0, 51.0);
    self.cellReplyView.titleLabel.text = @"回复";
    self.cellReplyView.iconIV.image = [UIImage imageNamed:@"icon_zan_white2"];
    [self.backView addSubview:self.cellReplyView];
    WS(weakSelf);
    [self.cellReplyView setDidSelectedBlock:^(CSToolButtonView *buttonView) {
        [weakSelf.cellReplyView removeFromSuperview];
        [weakSelf.backView removeFromSuperview];
        CSReplyTextView *replyTextView = [[CSReplyTextView alloc] init];
        [replyTextView setDidSelectedSureBlock:^(NSString *content) {
            CSSpecialCommentModel *specialCommentModel = weakSelf.caseDetailModel.commments[indexPath.section];
            [weakSelf commitCommentWithContent:content parentid:specialCommentModel.commentId targetid:weakSelf.caseId targetType:kCommentCaseType beCommeentUserid:specialCommentModel.commentUserId indexPath:[NSIndexPath indexPathForRow:0 inSection:indexPath.section] specialCommentModel:specialCommentModel];
        }];
        [replyTextView show];
    }];
}
/**
 *  将评论者评论放置在此
 */
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    CSCommentCell *cell = [tableView dequeueReusableCellWithIdentifier:commentIdentifier];
    if (!cell) {
        cell = [[CSCommentCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:commentIdentifier];
    }
    if (section == 0 || section == 1) {
        return 0;
    }
    cell.commentType = CSCommentStudyCaseType;
    cell.section = section;
    CSSpecialCommentModel *commentModel = self.caseDetailModel.commments[section];
    cell.commentModel = commentModel;
    NSIndexPath *indexPath2 = [NSIndexPath indexPathForRow:-1 inSection:section];
    cell.indexPath = indexPath2;
    
    UIView *tempView = [[UIView alloc] init];
    [cell setBackgroundView:tempView];
    //去掉分割线
    tableView.separatorStyle = UITableViewCellSelectionStyleNone;

    [cell setDidSelectedReplyBlock:^(NSIndexPath *indexPath) {
        WS(weakSelf);
        //找到点击的section在可视区域的位置
        CGRect rectInTableView = [tableView rectForSection:section];
        CGRect rect = [tableView convertRect:rectInTableView toView:[tableView superview]];
        
        self.backView = [[UIView alloc] initWithFrame:self.view.bounds];
        [self.view insertSubview:self.backView aboveSubview:self.caseTable];
        UITapGestureRecognizer *tapGes = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideBackView)];
        [self.backView addGestureRecognizer:tapGes];
        //40
        self.praiseView = [[CSToolButtonView alloc] init];
        
        if ([commentModel.praiseId integerValue] > 0) {
            self.praiseView.titleLabel.text = @"取消赞";
        }else{
            self.praiseView.titleLabel.text = @"赞一个";
        }
        self.praiseView.iconIV.image = [UIImage imageNamed:@"icon_zan_white2"];
        self.praiseView.backgroundColor = CSColorFromRGB(51.0, 51.0, 51.0);
        [self.backView addSubview:self.praiseView];
        
        self.replyView = [[CSToolButtonView alloc] init];
        self.replyView.backgroundColor = CSColorFromRGB(51.0, 51.0, 51.0);
        self.replyView.titleLabel.text = @"回复";
        self.replyView.iconIV.image = [UIImage imageNamed:@"icon_zan_white2"];
        [self.backView addSubview:self.replyView];
        
        self.gapIV = [[UIImageView alloc] init];
        self.gapIV.backgroundColor = [UIColor whiteColor];
        [self.backView addSubview:self.gapIV];
        
        if (commentModel.replyComments.count > 0) {
            self.praiseView.frame = CGRectMake(60,  rect.origin.y + 25, cell.contentView.frame.size.width/2 - 60, 50);
            self.replyView.frame = CGRectMake(self.praiseView.frame.origin.x + self.praiseView.frame.size.width,  rect.origin.y + 25, cell.contentView.frame.size.width/2 - 60, 50);
            self.gapIV.frame = CGRectMake(self.praiseView.frame.origin.x + self.praiseView.frame.size.width,  rect.origin.y + 30, 2, 40);
        }else{
            self.praiseView.frame = CGRectMake(60, (2 * rect.origin.y + rect.size.height) / 2 - 25, cell.contentView.frame.size.width/2 - 60, 50);
            self.replyView.frame = CGRectMake(self.praiseView.frame.origin.x + self.praiseView.frame.size.width, (2 * rect.origin.y + rect.size.height) / 2 - 25, cell.contentView.frame.size.width/2 - 60, 50);
            self.gapIV.frame = CGRectMake(self.praiseView.frame.origin.x + self.praiseView.frame.size.width, (2 * rect.origin.y + rect.size.height) / 2 - 20, 2, 40);
        }
        //评论
        [self.replyView setDidSelectedBlock:^(CSToolButtonView *buttonView) {
            [weakSelf hideBackView];
            //点击评论时   显示输入框
            CSReplyTextView *replyTextView = [[CSReplyTextView alloc] init];
            [replyTextView setDidSelectedSureBlock:^(NSString *content) {
                CSSpecialCommentModel* specialCommentModel = weakSelf.caseDetailModel.commments[section];
                [weakSelf commitCommentWithContent:content parentid:specialCommentModel.commentId targetid:weakSelf.caseId targetType:kCommentCaseType beCommeentUserid:specialCommentModel.commentId indexPath:[NSIndexPath indexPathForRow:0 inSection:section] specialCommentModel:commentModel];
            }];
            [replyTextView show];
        }];
        //点赞
        [self.praiseView setDidSelectedBlock:^(CSToolButtonView *buttonView) {
            [weakSelf hideBackView];
            [weakSelf clickPraiseCommentModel:commentModel whichSection:section];
        }];
    }];
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    CSCommentCell *cell = (CSCommentCell *)[self tableView:self.caseTable viewForHeaderInSection:section];
    if (section == 0 || section == 1) {
        return 0;
    }
    return [cell getCellHeight];
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0;
}
-(CGFloat)tableView:(UITableView *)tableView estimatedHeightForFooterInSection:(NSInteger)section{
    return 0;
}
#pragma mark CSGetMultiseStringDelegate
- (void)getChopIdString{
    NSString *optionString = @"";
    for (CSOptionModel *option in self.caseDetailModel.optionArray) {
        if (option.isSelected == true) {
            optionString = [optionString stringByAppendingString:[NSString stringWithFormat:@"%ld,",[option.chopId integerValue]]];
        }
    }
    if (optionString.length == 0) {
        return;
    }else{
        optionString = [optionString substringWithRange:NSMakeRange(0, optionString.length - 1)];
    }
    self.chooseAnswerString = optionString;
}

//提交案列答案
-(void)commitCaseAnswerCaseQuestionType:(NSString *)caseQuestionType caseDetailModel:(CSStudyCaseDetailModel *)caseDetailModel{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    if ([caseQuestionType isEqualToString:kTopicSingleType] || [caseQuestionType isEqualToString:kTopicNoItemType] || [caseQuestionType isEqualToString:kTopicMultiSelectType]) {
        [params setValue:self.chooseAnswerString forKey:@"answerIds"];
    }else if ([caseQuestionType isEqualToString:kTopicJudgeType]){
    [params setValue:self.questionString forKey:@"answerContent"];
    }else if ([caseQuestionType isEqualToString:kTopicQuestionType]){
        CSAskAndAnswerCell *cell = (CSAskAndAnswerCell *)[self.caseTable cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
        self.questionString = cell.textView.text;
        [params setValue:self.questionString forKey:@"answerContent"];
    }
    [params setValue:caseDetailModel.caseQuestionType forKey:@"caseQuestionType"];
    [params setValue:caseDetailModel.caseId forKey:@"caseId"];
    [[CSHttpRequestManager shareManager] postDataFromNetWork:SAVE_CASE_ANSWER parameters:params success:^(CSHttpRequestManager *manager, id model) {
        [self loadData:YES];
    } failture:^(CSHttpRequestManager *manager, id nodel) {
        
    }];
}


#pragma mark commitComment
- (void)commitCommentWithContent:(NSString *)content parentid:(NSNumber *)parentid targetid:(NSNumber *)targetid targetType:(NSString *)targetType beCommeentUserid:(NSNumber *)beCommentUserid indexPath:(NSIndexPath *)indexPath specialCommentModel:(CSSpecialCommentModel *)specialCommentModel{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters setValue:content forKey:@"content"];
    [parameters setValue:targetType forKey:@"targetType"];
    [parameters setValue:parentid forKey:@"parentId"];
    [parameters setValue:beCommentUserid forKey:@"becommentUserId"];
    [parameters setValue:targetid forKey:@"targetId"];
    [MBProgressHUD showMessage:@"提交中..." toView:self.view];
    [[CSHttpRequestManager shareManager] postDataFromNetWork:SAVE_GLOBAL_COMMENT parameters:parameters success:^(CSHttpRequestManager *manager, id model) {
        [MBProgressHUD hideHUDForView:self.view];
        
         NSInteger code = [model integerForKey:@"code"];
        if (code == 0) {
            NSString *string = model[@"codeDesc"];
            [MBProgressHUD  showToView:self.view text:string afterDelay:2.0 hideBlock:^(MBProgressHUD * _Nonnull hud) {
                
            }];
            NSDictionary *commentDic = (NSDictionary *)model;
            CSSpecialCommentModel *commentModel = [[CSSpecialCommentModel alloc] initWithDictionary:commentDic error:nil];
            //提交评论成功后    手动插入
            if (indexPath.section == -1) {
                CSUserModel *user = [[CSUserModel alloc]initWithDictionary:commentDic[@"user"] error:nil];
                commentModel.userModel = user;
                [self.caseDetailModel.commments insertObject:commentModel atIndex:2];
                [self.inputBoxView.countBtn setTitle:[NSString stringWithFormat:@"%ld评论",[self.caseDetailModel.commentCount integerValue] + 1] forState:UIControlStateNormal];
            }else{
                CSReplyCommentModel *replyCommentModel = [[CSReplyCommentModel alloc] initWithDictionary:commentDic error:nil];
                CSUserModel *user = [[CSUserModel alloc]initWithDictionary:commentDic[@"user"] error:nil];
                replyCommentModel.userModel = user;
                [specialCommentModel.replyComments insertObject:replyCommentModel atIndex:0];
            }
            [self.caseTable reloadData];
        }else{
            [MBProgressHUD showToView:self.view text:@"评论失败" afterDelay:2.0 hideBlock:^(MBProgressHUD * _Nonnull hud) {
                
            }];
        }
    
    } failture:^(CSHttpRequestManager *manager, id nodel) {
        [MBProgressHUD hideHUDForView:self.view];
    }];
}

/**
 *  隐藏一些可见视图
 */
-(void)hideBackView{
    [self.backView removeFromSuperview];
    [self.praiseView removeFromSuperview];
    [self.gapIV removeFromSuperview];
    [self.replyView removeFromSuperview];
}

/**
 *  点赞或者取消点赞
 */
- (void)clickPraiseCommentModel:(CSSpecialCommentModel *)comment whichSection:(NSInteger)whichSection{
    SMClickGlobaPraise *commentPraise = [[SMClickGlobaPraise alloc]init];
    commentPraise.targetId = comment.commentId;
    commentPraise.targetType = SMGlobalApiCommentPraise;
    [commentPraise startWithPraiseId:comment.praiseId completionBlockWithSuccess:^(id responseJSONObject, NSInteger responseCode) {
        if (responseCode == 0) {
            comment.praiseId = responseJSONObject[@"praiseId"];
            if ([comment.praiseId integerValue] > 0) {
                [MBProgressHUD showToView:self.view text:@"点赞成功" afterDelay:1.0 hideBlock:^(MBProgressHUD * _Nonnull HUD) {
                    
                }];
                NSInteger praiseCount = [comment.praiseCount integerValue] + 1;
                comment.praiseCount = [NSNumber numberWithInteger:praiseCount];
            }else{
                [MBProgressHUD showToView:self.view text:@"取消点赞成功" afterDelay:1.0 hideBlock:^(MBProgressHUD * _Nonnull HUD) {
                    
                }];
                NSInteger praiseCount = [comment.praiseCount integerValue] - 1;
                comment.praiseCount = [NSNumber numberWithInteger:praiseCount];
            }
            [self.caseTable reloadData];
        }
    } withFailure:^(NSError *error) {
        [MBProgressHUD hideToView:self.view];
    }];
}




-(void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    self.inputBoxView.frame = CGRectMake(0, self.view.frame.size.height - 50, self.view.frame.size.width, 50);
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
