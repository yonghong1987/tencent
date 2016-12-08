//
//  CSForumListViewController.m
//  tencent
//
//  Created by sunon002 on 16/4/26.
//  Copyright © 2016年 cyh. All rights reserved.
//

#import "CSForumListViewController.h"
#import "CSFrameConfig.h"
#import "CSUrl.h"
#import "CSProjectDefault.h"
#import "CSConfig.h"
#import "CSPostListCell.h"
#import "CSOptionModel.h"
#import "NSDictionary+convenience.h"
#import "UITableView+SDAutoTableViewCellHeight.h"
#import "CSForumDetailViewController.h"
#import "SMBaseTableView.h"
#import "ConstFile.h"
#import "CSHttpRequestManager.h"
#import "CSColorConfig.h"
@interface CSForumListViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) SMBaseTableView *forumTable;
/*
 **帖子数组
 */
@property (nonatomic, strong) NSMutableArray *posts;
@end

@implementation CSForumListViewController

static NSString *postIdentifierCell = @"postIdentifierCell";

- (void)viewDidLoad {
    [super viewDidLoad];
    self.posts = [NSMutableArray array];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.view.frame = CGRectMake(0, 0, self.preferredContentSize.width, self.preferredContentSize.height);
    [self initTable];
    [self setupRefresh];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshHotPost:) name:kNotificationSavePostSuccess object:nil];
    //项目切换时   会触发请求   此时需要重新请求服务器  并刷新数据
    // Do any additional setup after loading the view.
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if( self.changeProject ){
        self.changeProject = NO;
        self.forumTable.page = 1; 
        [self loadData:YES];
    }
}

-(void)refreshHotPost:(NSNotification *)noti{
    NSString *string = noti.userInfo[@"saveSuccess"];
    if ([string isEqualToString:@"success"]) {
        self.forumTable.page = 1;
        [self loadData:YES];
    }
}
- (void)setupRefresh{
    WS(weakSelf);
    [self.forumTable refreshHeaderRefresh:^{
        [weakSelf loadData:YES];
    } withFooterRefreshingBlock:^{
        [weakSelf loadData:NO];
    }];
    [self.forumTable beginRefreshing];
}
#pragma mark controlInit
- (void)initTable{
    self.forumTable = [[SMBaseTableView alloc]initWithFrame:CGRectMake(0, 0, kCSScreenWidth, kCSScreenHeight - KNavigationHegiht - 44 - 49) style:UITableViewStylePlain];
    self.forumTable.delegate = self;
    self.forumTable.dataSource = self;
    self.forumTable.backgroundColor = kBGColor;
    self.forumTable.rowHeight = 80.0;
    [self.view addSubview:self.forumTable ];
    [self.forumTable registerClass:[CSPostListCell class] forCellReuseIdentifier:postIdentifierCell];
}

- (void)changedProjectMenuItem{
    self.posts = [NSMutableArray array];
    self.forumTable.page = 1;
    [self loadData:YES];
}
#pragma mark loadData
- (void)loadData:(BOOL)reload{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    NSNumber *projectId = [[CSProjectDefault shareProjectDefault] getProjectId];
    [params setValue:@(CONST_RP) forKey:@"rp"];
    [params setValue:@(self.forumTable.page) forKey:@"page"];
    [params setValue:projectId forKey:@"projectId"];
    [params setValue:self.forumType forKey:@"type"];
    [[CSHttpRequestManager shareManager] postDataFromNetWork:GET_FORUM_LIST parameters:params success:^(CSHttpRequestManager *manager, id model) {
            NSArray *array = model[@"forumList"];
            NSMutableArray *arrayData = [NSMutableArray array];
            for (NSDictionary *postDic in array) {
                CSPostListModel *postListModel = [[CSPostListModel alloc] initWithDictionary:postDic error:nil];
                [arrayData addObject:postListModel];
            }
        if (self.forumTable.page == 1) {
            [self.posts removeAllObjects];
        }
            if (self.forumTable.refreshState == SMBaseTableViewRefreshStateHeader) {
                self.posts = arrayData;
            }else{
                [self.posts addObjectsFromArray:arrayData];
            }
            [self.forumTable endReload];
    } failture:^(CSHttpRequestManager *manager, id nodel) {
        [self.forumTable endRefreshing];
    }];
}

#pragma mark UITableViewDelegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.posts.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    CSPostListCell *cell = [tableView dequeueReusableCellWithIdentifier:postIdentifierCell];
    CSPostListModel* postListModel = self.posts[indexPath.row];
    cell.postListModel = postListModel;
    cell.postImageDisplayType = CSPostListCellType;
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
     CSPostListModel* postListModel = self.posts[indexPath.row];
    return [self.forumTable cellHeightForIndexPath:indexPath model:postListModel keyPath:@"postListModel" cellClass:[CSPostListCell class] contentViewWidth:kCSScreenWidth];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    self.changeProject = NO;
    CSForumDetailViewController *detailVC =[[CSForumDetailViewController alloc]init];
    CSPostListModel* postListModel = self.posts[indexPath.row];
    detailVC.forumId = postListModel.forumId;
//    detailVC.postListModel = postListModel;
    detailVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:detailVC animated:YES];
}

-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
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
