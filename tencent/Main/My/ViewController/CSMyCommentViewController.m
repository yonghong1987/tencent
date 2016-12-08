//
//  CSMyCommentViewController.m
//  tencent
//
//  Created by cyh on 16/8/25.
//  Copyright © 2016年 cyh. All rights reserved.
//

#import "CSMyCommentViewController.h"
#import "SMBaseTableView.h"
#import "CSFrameConfig.h"
#import "CSColorConfig.h"
#import "CSHttpRequestManager.h"
#import "CSConfig.h"
#import "UITableView+SDAutoTableViewCellHeight.h"
#import "CSMyCommentCell.h"
#import "CSUrl.h"
#import "CSSpecialCommentModel.h"
#import "CSCommentSourceModel.h"
#import "CSSpecialCommentViewController.h"
#import "CSNormalCourseDetailViewController.h"
#import "CSForumDetailViewController.h"
#import "CSStudyCaseDetailViewController.h"
#import "CSSpecialDetailViewController.h"
#import "CSMapCourseDetailViewController.h"
@interface CSMyCommentViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) SMBaseTableView *commentTable;
@property (nonatomic, strong) NSMutableArray *comments;

@end

@implementation CSMyCommentViewController
static NSString *commentCellIdentifier = @"commentCellIdextifier";
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"我的评论";
    self.comments = [NSMutableArray array];
    [self initUI];
    [self setupRefresh];
    // Do any additional setup after loading the view.
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    UITabBarItem * commentItem=[self.tabBarController.tabBar.items objectAtIndex:3];
    commentItem.badgeValue=nil;

}
-(void)initUI{
    self.commentTable = [[SMBaseTableView alloc]initWithFrame:CGRectMake(0, 0, kCSScreenWidth, kCSScreenHeight - KNavigationHegiht) style:UITableViewStylePlain];
    self.commentTable.delegate = self;
    self.commentTable.dataSource = self;
    self.commentTable.backgroundColor = kBGColor;
    self.commentTable.tableFooterView = [[UIView alloc]initWithFrame:CGRectZero];
    self.commentTable.rowHeight = 80.0;
    [self.view addSubview:self.commentTable];
    [self.commentTable registerClass:[CSMyCommentCell class] forCellReuseIdentifier:commentCellIdentifier];
    
}

- (void)setupRefresh{
    WS(weakSelf);
    [self.commentTable refreshHeaderRefresh:^{
        [weakSelf loadData];
    } withFooterRefreshingBlock:^{
        [weakSelf loadData];
    }];
    [self.commentTable beginRefreshing];
}
-(void)loadData{
    NSDictionary *parames = @{@"rp":@(RP),@"page":@(self.commentTable.page)};
    [[CSHttpRequestManager shareManager] postDataFromNetWork:MY_COMMENT parameters:parames success:^(CSHttpRequestManager *manager, id model) {
        NSArray *commentArr = model[@"commentList"];
        NSMutableArray *arrayDada = [NSMutableArray array];
        for (NSDictionary *commentDic in commentArr) {
            CSSpecialCommentModel *comemnt = [[CSSpecialCommentModel alloc]initWithDictionary:commentDic error:nil];
            CSUserModel *user = [[CSUserModel alloc]initWithDictionary:commentDic[@"user"] error:nil];
            comemnt.userModel = user;
            CSCommentSourceModel *sourceModel = [[CSCommentSourceModel alloc]initWithDictionary:commentDic[@"commentSource"] error:nil];
            comemnt.sourceModel = sourceModel;
            [arrayDada addObject:comemnt];
        }
        if (self.commentTable.refreshState == SMBaseTableViewRefreshStateHeader) {
            self.comments = arrayDada;
        }else{
            [self.comments addObjectsFromArray:arrayDada];
        }
        [self.commentTable endReload];
    } failture:^(CSHttpRequestManager *manager, id nodel) {
        [self.commentTable endRefreshing];
    }];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.comments.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    CSMyCommentCell *cell = [tableView dequeueReusableCellWithIdentifier:commentCellIdentifier];
    CSSpecialCommentModel *commentModel = self.comments[indexPath.row];
    cell.commentModel = commentModel;
    CSCommentSourceModel *sourceModel = commentModel.sourceModel;
    WS(weakSelf);
    cell.clickSelectionAction = ^(){
        if (sourceModel.commentSourceType == CSCommentSourceCourceType) {
            CSNormalCourseDetailViewController *normalVC = [[CSNormalCourseDetailViewController alloc]initWithCourseId:sourceModel.sourceId CoureseName:sourceModel.content];
            [weakSelf.navigationController pushViewController:normalVC animated:YES];
        }else if (sourceModel.commentSourceType == CSCommentSourceForumType){
         CSForumDetailViewController *detailVC =[[CSForumDetailViewController alloc]init];
            detailVC.forumId  = sourceModel.sourceId;
          [weakSelf.navigationController pushViewController:detailVC animated:YES];
        }else if (sourceModel.commentSourceType == CSCommentSourceCaseType){
            CSStudyCaseDetailViewController *detailVC =[[CSStudyCaseDetailViewController alloc]init];
            detailVC.caseId  = sourceModel.sourceId;
            [weakSelf.navigationController pushViewController:detailVC animated:YES];
        }else if (sourceModel.commentSourceType == CSCommentSourceSpecialType){
            CSSpecialDetailViewController *detailVC =[[CSSpecialDetailViewController alloc]init];
            detailVC.specialid  = sourceModel.sourceId;
            [weakSelf.navigationController pushViewController:detailVC animated:YES];
        }else if (sourceModel.commentSourceType == CSCommentSourceMapType){
            CSMapCourseDetailViewController *detailVC =[[CSMapCourseDetailViewController alloc]init];
            detailVC.tollgateId  = sourceModel.tollgateId;
            detailVC.courseId = sourceModel.sourceId;
            detailVC.examReultType = 110;
            [weakSelf.navigationController pushViewController:detailVC animated:YES];
        }

    };
    return cell;
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    CSSpecialCommentModel *commentModel = self.comments[indexPath.row];
    return [self.commentTable cellHeightForIndexPath:indexPath model:commentModel keyPath:@"commentModel" cellClass:[CSMyCommentCell class] contentViewWidth:kCSScreenWidth];
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    CSSpecialCommentModel *commentModel = self.comments[indexPath.row];
    CSSpecialCommentViewController *commentVC = [[CSSpecialCommentViewController alloc]init];
    commentVC.commentType = commentModel.targetType;
    commentVC.targetid = commentModel.targetId;
    [self.navigationController pushViewController:commentVC animated:YES];
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
