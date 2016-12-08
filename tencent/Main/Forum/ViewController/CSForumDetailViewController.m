//
//  CSForumDetailViewController.m
//  tencent
//
//  Created by admin on 16/5/23.
//  Copyright © 2016年 cyh. All rights reserved.
//

#import "CSForumDetailViewController.h"
#import "CSConfig.h"
#import "CSFrameConfig.h"
#import "CSPostDetailHeadCell.h"
#import "CSPostCommentCell.h"
#import "UITableView+SDAutoTableViewCellHeight.h"
#import "CSPostDetailModel.h"
#import "CSInputBoxView.h"
#import "CSReplyTextView.h"
#import "SMBaseTableView.h"
#import "CSHttpRequestManager.h"
#import "CSUrl.h"
#import "ConstFile.h"
#import "CSPostDetailModel.h"
#import "CSImagePath.h"
#import "CSSpecialCommentModel.h"
#import "CSGlobalMacro.h"
#import "SMBaseNetworkApi.h"
#import "SMGlobalApi.h"
#import "MBProgressHUD+SMHUD.h"
#import "MJRefresh.h"
#import "CSColorConfig.h"
#import "NSDictionary+convenience.h"
#import "MBProgressHUD+SMHUD.h"
#import "XHMessageTextView+XHMessageValidation.h"
@interface CSForumDetailViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) SMBaseTableView *detailTable;
@property (nonatomic, strong) CSPostDetailModel *postDetailModel;
@property (nonatomic, strong) CSInputBoxView *inputBoxView;//评论输入视图
@end

@implementation CSForumDetailViewController

static NSString *postCommnentIdentifierCell = @"postCommnentIdentifierCell";
static NSString *postDetailIdentifierCell = @"postDetailIdentifierCell";

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"帖子详情";
    [self addDetailTable];
    [self addInputBox];
    [self setupRefresh];
    // Do any additional setup after loading the view.
}

- (void)setupRefresh{
    WS(weakSelf);
    [self.detailTable refreshHeaderRefresh:^{
        [weakSelf loadData:YES];
    } withFooterRefreshingBlock:^{
        [weakSelf loadData:NO];
    }];
    [self.detailTable beginRefreshing];
}

- (void)loadData:(BOOL)reload{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setValue:@(CONST_RP) forKey:@"rp"];
    [params setValue:@(self.detailTable.page) forKey:@"page"];
    [params setValue:self.forumId forKey:@"targetId"];
    [params setValue:kCommentForumType forKey:@"targetType"];
    
    [[CSHttpRequestManager shareManager] postDataFromNetWork:GET_PORUM_DETAIL parameters:params success:^(CSHttpRequestManager *manager, id model) {
        NSDictionary *detailDic = model[@"forumList"];
        NSArray *comments = detailDic[@"commentList"];
        NSMutableArray *commentArray = [NSMutableArray array];
        if (self.detailTable.refreshState == SMBaseTableViewRefreshStateHeader) {
            self.postDetailModel = [[CSPostDetailModel alloc]initWithDictionary:detailDic error:nil];
            NSArray *images = detailDic[@"imgList"];
            self.postDetailModel.postImages = [NSMutableArray array];
            for (NSString *imageString in images) {
                NSString *string = [CSImagePath getImageUrl:imageString];
                [self.postDetailModel.postImages addObject:string];
            }
            self.postDetailModel.commentArr = [NSMutableArray array];
            for (NSDictionary *commentDic in comments) {
                CSSpecialCommentModel *comment = [[CSSpecialCommentModel alloc]initWithDictionary:commentDic error:nil];
                CSUserModel *user = [[CSUserModel alloc]initWithDictionary:commentDic[@"user"] error:nil];
                comment.userModel = user;
                
                [commentArray addObject:comment];
            }
            self.postDetailModel.commentArr = commentArray;
        }else{
            for (NSDictionary *commentDic in comments) {
                CSSpecialCommentModel *comment = [[CSSpecialCommentModel alloc]initWithDictionary:commentDic error:nil];
                CSUserModel *user = [[CSUserModel alloc]initWithDictionary:commentDic[@"user"] error:nil];
                comment.userModel = user;
                [commentArray addObject:comment];
            }
            [self.postDetailModel.commentArr addObjectsFromArray:commentArray];
        }
        [self.detailTable endReload];
    } failture:^(CSHttpRequestManager *manager, id nodel) {
        [self.detailTable endRefreshing];
    }];
}
#pragma mark controlInit
-(void)addDetailTable{
    _detailTable = [[SMBaseTableView alloc]initWithFrame:CGRectMake(0, 0, kCSScreenWidth, kCSScreenHeight - 64 - 60) style:UITableViewStylePlain];
    _detailTable.backgroundColor = kBGColor;
    _detailTable.delegate = self;
    _detailTable.dataSource = self;
    _detailTable.ofSection = 1;
    _detailTable.separatorStyle = UITableViewCellSeparatorStyleNone;
    _detailTable.rowHeight = 80;
    [self.view addSubview:_detailTable];
    [self.detailTable registerClass:[CSPostCommentCell class] forCellReuseIdentifier:postCommnentIdentifierCell];
    [self.detailTable registerClass:[CSPostDetailHeadCell class] forCellReuseIdentifier:postDetailIdentifierCell];
}

#pragma mark UITableViewDelegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return section == 0 ? 1 : self.postDetailModel.commentArr.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        CSPostDetailHeadCell *cell = [tableView dequeueReusableCellWithIdentifier:postDetailIdentifierCell];
        cell.postDetailModel = self.postDetailModel;
        return cell;
    }else if (indexPath.section == 1){
        
        CSPostCommentCell *cell = [tableView dequeueReusableCellWithIdentifier:postCommnentIdentifierCell];
        cell.commentModel = self.postDetailModel.commentArr[indexPath.row];
        return cell;
    }
    return 0;
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        return [self.detailTable cellHeightForIndexPath:indexPath model:self.postDetailModel keyPath:@"postDetailModel" cellClass:[CSPostDetailHeadCell class] contentViewWidth:kCSScreenWidth];
    }else if (indexPath.section == 1){
        CSSpecialCommentModel* commentModel = self.postDetailModel.commentArr[indexPath.row];
    return [self.detailTable cellHeightForIndexPath:indexPath model:commentModel keyPath:@"commentModel" cellClass:[CSPostCommentCell class] contentViewWidth:kCSScreenWidth];
    }
    return 0;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 1) {
        CSSpecialCommentModel* commentModel = self.postDetailModel.commentArr[indexPath.row];
        SMClickGlobaPraise *commentPraise = [[SMClickGlobaPraise alloc]init];
        commentPraise.targetId = commentModel.commentId;
        commentPraise.targetType = SMGlobalApiCommentPraise;
        [commentPraise startWithPraiseId:commentModel.praiseId completionBlockWithSuccess:^(id responseJSONObject, NSInteger responseCode) {
            if (responseCode == 0) {
                commentModel.praiseId = responseJSONObject[@"praiseId"];
                if ([commentModel.praiseId integerValue] > 0) {
                    [MBProgressHUD showToView:self.view text:@"点赞成功" afterDelay:1.0 hideBlock:^(MBProgressHUD * _Nonnull hud) {
                        
                    }];
                    NSInteger praiseCount = [commentModel.praiseCount integerValue] + 1;
                    commentModel.praiseCount = [NSNumber numberWithInteger:praiseCount];
                }else{
                    [MBProgressHUD showToView:self.view text:@"取消点赞成功" afterDelay:1.0 hideBlock:^(MBProgressHUD * _Nonnull hud) {
                        
                    }];
                    NSInteger praiseCount = [commentModel.praiseCount integerValue] - 1;
                    commentModel.praiseCount = [NSNumber numberWithInteger:praiseCount];
                }
            }
            NSIndexPath *indexPath2 = [NSIndexPath indexPathForRow:indexPath.row inSection:indexPath.section];
            [self.detailTable reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath2, nil] withRowAnimation:UITableViewRowAnimationAutomatic];
            

        } withFailure:^(NSError *error) {
            [MBProgressHUD hideToView:self.view];
        }];
    }
}

- (void)addInputBox{
    WS(weakSelf);
    self.inputBoxView = [[CSInputBoxView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height - 50, self.view.frame.size.width, 50)];
    self.inputBoxView.placeholder = @"  请输入评论...";
    [self.inputBoxView.replyTextView.textView setMaxLenth:250 withErrorMesg:@"输入的评论长度不能超过250"];
    [self.view addSubview:self.inputBoxView];
    [self.inputBoxView setDidEndInputBlock:^(BOOL success, NSString *content) {
        if (success) {
            [weakSelf commitCommentWithContent:content];
        }else{
            DLog(@"error");
        }
    }];
}

//提交评论
-(void)commitCommentWithContent:(NSString *)content{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setValue:kCommentForumType forKey:@"targetType"];
    [params setValue:content forKey:@"content"];
    [params setValue:self.postDetailModel.forumId forKey:@"targetId"];
    [[CSHttpRequestManager shareManager] postDataFromNetWork:SAVE_GLOBAL_COMMENT parameters:params success:^(CSHttpRequestManager *manager, id model) {
        self.inputBoxView.replyTextView.textView.text = @"";
        NSDictionary *commentDic = (NSDictionary *)model;
        NSInteger code = [commentDic integerForKey:@"code"];
        if (code == 0) {
            [MBProgressHUD showToView:self.view text:@"评论成功" afterDelay:2.0 hideBlock:^(MBProgressHUD * _Nonnull hud) {
                
            }];
            CSSpecialCommentModel *commentModel = [[CSSpecialCommentModel alloc] initWithDictionary:commentDic error:nil];
            CSUserModel *user = [[CSUserModel alloc]initWithDictionary:commentDic[@"user"] error:nil];
            commentModel.userModel = user;
            [self.postDetailModel.commentArr insertObject:commentModel atIndex:0];
            [self.detailTable reloadData];
            
        }else{
            [MBProgressHUD showToView:self.view text:@"评论失败" afterDelay:2.0 hideBlock:^(MBProgressHUD * _Nonnull hud) {
                
            }];
        }
        
    } failture:^(CSHttpRequestManager *manager, id nodel) {
        
    }];
}

- (void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    self.inputBoxView.frame = CGRectMake(0, self.view.frame.size.height - 50, self.view.frame.size.width, 50);
    self.detailTable.frame = CGRectMake(0, 0, kCSScreenWidth, kCSScreenHeight - 70);
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
