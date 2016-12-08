//
//  CSSpecialCommentViewController.m
//  tencent
//
//  Created by admin on 16/5/6.
//  Copyright © 2016年 cyh. All rights reserved.
//

#import "CSSpecialCommentViewController.h"
#import "CSHttpRequestManager.h"
#import "CSUrl.h"
#import "CSUserDefaults.h"
#import "CSConfig.h"
#import "MBProgressHUD+CYH.h"
#import "CSFrameConfig.h"
#import "CSSpecialCommentModel.h"
#import "CSCommentCell.h"
#import "UITableView+SDAutoTableViewCellHeight.h"
#import "NSDictionary+convenience.h"
#import "CSReplyCommentModel.h"
#import "CSConfig.h"
#import "CSReplyCommentCell.h"
#import "CSColorConfig.h"
#import "MJRefresh.h"
#import "CSInputBoxView.h"
#import "CSReplyTextView.h"
#import "CSDisplayPraiseView.h"
#import "CSToolButtonView.h"
#import "MBProgressHUD+SMHUD.h"
#import "SMGlobalApi.h"
#import "CSUserModel.h"

@interface CSSpecialCommentViewController ()
@property (nonatomic, assign) int currentPage;
@property (nonatomic, strong) NSMutableArray *commentArr;//评论数组
@property (nonatomic, strong) CSInputBoxView *inputBoxView;//评论输入视图
@property (nonatomic, strong) UIView *backView;//背景View
@property (nonatomic, strong) CSToolButtonView *praiseView;//点赞
@property (nonatomic, strong) CSToolButtonView *replyView;//点击sectionHead回复
@property (nonatomic, strong) CSToolButtonView *cellReplyView;//点击cell回复
@property (nonatomic, strong) UIImageView *gapIV;

@end

@implementation CSSpecialCommentViewController

static NSString *commentIdentifier = @"commentCell";
static NSString *replyCommentIdentifier = @"replyCommentCell";

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"评论区";
    self.commentArr = [NSMutableArray array];
    [self addTableView];
    [self addInputBox];
    [self loadData:YES];
    [self setupRefresh];
    // Do any additional setup after loading the view.
}

#pragma mark controlInit
-(void)addTableView{
    self.commentTable = [[UITableView alloc]initWithFrame:CGRectMake(10, 0, kCSScreenWidth - 20, kCSScreenHeight - 64 - 50) style:UITableViewStyleGrouped];
    self.commentTable.delegate = self;
    self.commentTable.dataSource = self;
    self.commentTable.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.commentTable.showsVerticalScrollIndicator = NO;
    self.commentTable.showsHorizontalScrollIndicator = NO;
    self.commentTable.sectionFooterHeight = 0;
    self.commentTable.backgroundColor = kBGColor;
    self.commentTable.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    [self.view addSubview:self.commentTable];
    [self.commentTable registerClass:[CSCommentCell class] forCellReuseIdentifier:commentIdentifier];
    [self.commentTable registerClass:[CSReplyCommentCell class] forCellReuseIdentifier:replyCommentIdentifier];
}

- (void)addInputBox{
    WS(weakSelf);
    self.inputBoxView = [[CSInputBoxView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height - 50, self.view.frame.size.width, 50)];
    self.inputBoxView.placeholder = @"  请输入评论...";
    [self.view addSubview:self.inputBoxView];
    [self.inputBoxView setDidEndInputBlock:^(BOOL success, NSString *content) {
        if (success) {
            [weakSelf commitCommentWithContent:content parentid:nil targetid:weakSelf.targetid targetType:weakSelf.commentType beCommeentUserid:nil indexPath:[NSIndexPath indexPathForRow:-1 inSection:-1] specialCommentModel:nil];
            
        }else{
            DLog(@"error");
        }
    }];
}

#pragma mark loadData
- (void)loadData:(BOOL)reload{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters setValue:@(RP) forKey:@"rp"];
    [parameters setValue:self.targetid forKey:@"targetId"];
    [parameters setValue:self.commentType forKey:@"targetType"];
    if (reload == YES) {
        self.currentPage = 0;
    }
    self.currentPage++;
    [parameters setValue:@(self.currentPage) forKey:@"page"];
    [MBProgressHUD showMessage:@"加载中..." toView:self.view];
    [[CSHttpRequestManager shareManager] postDataFromNetWork:GET_COMMENT_LIST parameters:parameters success:^(CSHttpRequestManager *manager, id model) {
        [MBProgressHUD hideHUDForView:self.view];
        [self endRefresh];
        NSArray *array = [(NSDictionary *)model objectForKey:@"commentList"];
        if (reload == YES) {
            if (array.count > 0) {
                [self.commentArr removeAllObjects];
            }
        }
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
            [self.commentArr addObject:commentModel];
        }
        [self.commentTable reloadData];
    } failture:^(CSHttpRequestManager *manager, id nodel) {
        [MBProgressHUD hideHUDForView:self.view];
        [self endRefresh];
    }];
}


#pragma mark UITableViewDelegate  UITableViewDataSource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.commentArr.count;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    CSSpecialCommentModel* specialCommentModel = self.commentArr[section];
    return specialCommentModel.replyComments.count;
}

/**
 *  将评论的回复放置在此
 */
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
   
    
    CSReplyCommentCell *cell = [tableView dequeueReusableCellWithIdentifier:replyCommentIdentifier];
    
    if (!cell) {
        cell = [[CSReplyCommentCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:replyCommentIdentifier];
    }
    CSSpecialCommentModel *commentModel = self.commentArr[indexPath.section];
    CSReplyCommentModel* replyCommentModel = commentModel.replyComments[indexPath.row];
    cell.commentType = CSCommentSpecialType;
    cell.replyCommentModel = replyCommentModel;
    return cell;
}

/**
 *  将评论者评论放置在此
 */
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    CSCommentCell *cell = [tableView dequeueReusableCellWithIdentifier:commentIdentifier];
//    CSCommentCell *cell = (CSCommentCell *)[tableView dequeueReusableHeaderFooterViewWithIdentifier:commentIdentifier];
    if (!cell) {
        cell = [[CSCommentCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:commentIdentifier];
    }
    cell.section = section;
    cell.commentType = CSCommentSpecialType;
    CSSpecialCommentModel *commentModel = self.commentArr[section];
    cell.commentModel = commentModel;
    NSIndexPath *indexPath2 = [NSIndexPath indexPathForRow:-1 inSection:section];
    cell.indexPath = indexPath2;
    
    UIView *tempView = [[UIView alloc] init];
    [cell setBackgroundView:tempView];
    cell.backgroundColor = [UIColor whiteColor];
//    cell.backgroundColor = [[UIColor redColor]colorWithAlphaComponent:0.2];
    //去掉分割线
    tableView.separatorStyle = UITableViewCellSelectionStyleNone;
    
    [cell setDidSelectedReplyBlock:^(NSIndexPath *indexPath) {
        WS(weakSelf);
        //找到点击的section在可视区域的位置
        CGRect rectInTableView = [tableView rectForSection:section];
        CGRect rect = [tableView convertRect:rectInTableView toView:[tableView superview]];
       
        self.backView = [[UIView alloc] initWithFrame:self.view.bounds];
        [self.view insertSubview:self.backView aboveSubview:self.commentTable];
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
        self.replyView.iconIV.image = [UIImage imageNamed:@"icon_comment_white"];
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
                            CSSpecialCommentModel* specialCommentModel = weakSelf.commentArr[section];
                            [weakSelf commitCommentWithContent:content parentid:specialCommentModel.commentId targetid:weakSelf.targetid targetType:weakSelf.commentType beCommeentUserid:specialCommentModel.commentId indexPath:[NSIndexPath indexPathForRow:0 inSection:section] specialCommentModel:commentModel];
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
    CSCommentCell *cell = (CSCommentCell *)[self tableView:self.commentTable viewForHeaderInSection:section];
    return [cell getCellHeight];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    CSReplyCommentCell *cell = (CSReplyCommentCell *)[self tableView:self.commentTable cellForRowAtIndexPath:indexPath];
    return [cell getCellHeight];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    //转换坐标
    self.backView = [[UIView alloc] initWithFrame:self.view.bounds];
    [self.view insertSubview:self.backView aboveSubview:self.commentTable];
    UITapGestureRecognizer *tapGes = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideBackView)];
    [self.backView addGestureRecognizer:tapGes];
    //找到点击的cell在可视区域的位置
    CGRect rectInTableView = [tableView rectForRowAtIndexPath:indexPath];
    CGRect rect = [tableView convertRect:rectInTableView toView:[tableView superview]];
    self.cellReplyView = [[CSToolButtonView alloc] initWithFrame:CGRectMake(rect.size.width / 2 - 55 , (2 * rect.origin.y + rect.size.height) / 2 - 25, 110, 50)];
    self.cellReplyView.backgroundColor = CSColorFromRGB(51.0, 51.0, 51.0);
    self.cellReplyView.titleLabel.text = @"回复";
    self.cellReplyView.iconIV.image = [UIImage imageNamed:@"icon_comment_white"];
    [self.backView addSubview:self.cellReplyView];
    WS(weakSelf);
    [self.cellReplyView setDidSelectedBlock:^(CSToolButtonView *buttonView) {
        [weakSelf.cellReplyView removeFromSuperview];
        [weakSelf.backView removeFromSuperview];
        CSReplyTextView *replyTextView = [[CSReplyTextView alloc] init];
        [replyTextView setDidSelectedSureBlock:^(NSString *content) {
            CSSpecialCommentModel *specialCommentModel = weakSelf.commentArr[indexPath.section];
            [weakSelf commitCommentWithContent:content parentid:specialCommentModel.commentId targetid:weakSelf.targetid targetType:weakSelf.commentType beCommeentUserid:specialCommentModel.commentUserId indexPath:[NSIndexPath indexPathForRow:0 inSection:indexPath.section] specialCommentModel:specialCommentModel];
        }];
        [replyTextView show];
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
                [self.commentArr insertObject:commentModel atIndex:self.commentArr.count];
            }else{
                CSReplyCommentModel *replyCommentModel = [[CSReplyCommentModel alloc] initWithDictionary:commentDic error:nil];
                CSUserModel *user = [[CSUserModel alloc]initWithDictionary:commentDic[@"user"] error:nil];
                replyCommentModel.userModel = user;
                [specialCommentModel.replyComments insertObject:replyCommentModel atIndex:specialCommentModel.replyComments.count];
                
            }
            [self.commentTable reloadData];
        }else{
            [MBProgressHUD showToView:self.view text:@"评论失败" afterDelay:2.0 hideBlock:^(MBProgressHUD * _Nonnull hud) {
                
            }];
        }
       
    } failture:^(CSHttpRequestManager *manager, id nodel) {
        [MBProgressHUD hideHUDForView:self.view];
    }];
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
                [MBProgressHUD showToView:self.view text:@"点赞成功！" afterDelay:1.0 hideBlock:^(MBProgressHUD * _Nonnull hud) {
                    
                }];
                NSInteger praiseCount = [comment.praiseCount integerValue] + 1;
                comment.praiseCount = [NSNumber numberWithInteger:praiseCount];
            }else{
                [MBProgressHUD showToView:self.view text:@"取消点赞成功！" afterDelay:1.0 hideBlock:^(MBProgressHUD * _Nonnull hud) {
                    
                }];
                NSInteger praiseCount = [comment.praiseCount integerValue] - 1;
                comment.praiseCount = [NSNumber numberWithInteger:praiseCount];
            }
//            NSIndexSet *indexSet = [[NSIndexSet alloc]initWithIndex:whichSection];
//            [self.commentTable reloadSections:indexSet withRowAnimation:UITableViewRowAnimationAutomatic];
            [self.commentTable reloadData];
        }
    } withFailure:^(NSError *error) {
       [MBProgressHUD hideToView:self.view];
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

#pragma mark setRefresh
- (void)setupRefresh{
    self.commentTable.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self loadData:YES];
    }];
    self.commentTable.mj_footer = [MJRefreshAutoFooter footerWithRefreshingBlock:^{
        [self loadData:NO];
    }];
    self.commentTable.mj_footer.hidden = NO;
}

- (void)endRefresh{
    [self.commentTable.mj_footer endRefreshing];
    [self.commentTable.mj_header endRefreshing];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    self.inputBoxView.frame = CGRectMake(0, self.view.frame.size.height - 50, self.view.frame.size.width, 50);
    self.commentTable.frame = CGRectMake(10, 0, kCSScreenWidth - 20, kCSScreenHeight - 50);
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
