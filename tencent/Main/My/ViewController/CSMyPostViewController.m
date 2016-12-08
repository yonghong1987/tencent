//
//  CSMyPostViewController.m
//  tencent
//
//  Created by cyh on 16/7/26.
//  Copyright © 2016年 cyh. All rights reserved.
//

#import "CSMyPostViewController.h"
#import "SMBaseTableView.h"
#import "CSHttpRequestManager.h"
#import "CSFrameConfig.h"
#import "CSColorConfig.h"
#import "CSPostListCell.h"
#import "CSConfig.h"
#import "CSUrl.h"
#import "UITableView+SDAutoTableViewCellHeight.h"
#import "CSForumDetailViewController.h"
@interface CSMyPostViewController ()
<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) SMBaseTableView *postTable;
@property (nonatomic, strong) NSMutableArray *posts;
@end

@implementation CSMyPostViewController

static NSString *postIdentifierCell = @"postIdentifierCell";

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"我的帖子";
    self.posts = [NSMutableArray array];
    [self initUI];
     [self setupRefresh];
    // Do any additional setup after loading the view.
}

-(void)initUI{
    self.postTable = [[SMBaseTableView alloc]initWithFrame:CGRectMake(0, 0, kCSScreenWidth, kCSScreenHeight - KNavigationHegiht) style:UITableViewStylePlain];
    self.postTable.delegate = self;
    self.postTable.dataSource = self;
    self.postTable.backgroundColor = kBGColor;
    self.postTable.rowHeight = 80.0;
    [self.view addSubview:self.postTable];
    [self.postTable registerClass:[CSPostListCell class] forCellReuseIdentifier:postIdentifierCell];
    
}

- (void)setupRefresh{
    WS(weakSelf);
    [self.postTable refreshHeaderRefresh:^{
        [weakSelf loadData];
    } withFooterRefreshingBlock:^{
        [weakSelf loadData];
    }];
    [self.postTable beginRefreshing];
}
-(void)loadData{
    
    NSDictionary *parames = @{@"rp":@(RP),@"page":@(self.postTable.page)};
    [[CSHttpRequestManager shareManager] postDataFromNetWork:MY_POST_LIST parameters:parames success:^(CSHttpRequestManager *manager, id model) {
        NSArray *array = model[@"forumList"];
        NSMutableArray *arrayData = [NSMutableArray array];
        for (NSDictionary *postDic in array) {
            CSPostListModel *postListModel = [[CSPostListModel alloc] initWithDictionary:postDic error:nil];
            [arrayData addObject:postListModel];
        }
        if (self.postTable.refreshState == SMBaseTableViewRefreshStateHeader) {
            self.posts = arrayData;
        }else{
            [self.posts addObjectsFromArray:arrayData];
        }
        [self.postTable endReload];
    } failture:^(CSHttpRequestManager *manager, id nodel) {
        [self.postTable endRefreshing];
    }];

}

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
    return [self.postTable cellHeightForIndexPath:indexPath model:postListModel keyPath:@"postListModel" cellClass:[CSPostListCell class] contentViewWidth:kCSScreenWidth];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    CSForumDetailViewController *detailVC =[[CSForumDetailViewController alloc]init];
    CSPostListModel* postListModel = self.posts[indexPath.row];
    detailVC.forumId = postListModel.forumId;
    detailVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:detailVC animated:YES];
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
