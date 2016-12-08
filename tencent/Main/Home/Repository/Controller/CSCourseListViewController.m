//
//  CSCourseListViewController.m
//  tencent
//
//  Created by bill on 16/4/27.
//  Copyright © 2016年 cyh. All rights reserved.
//

#import "CSCourseListViewController.h"
#import "CSCourseListTableViewCell.h"
#import "MJRefresh.h"
#import "SMBaseTableView.h"
#import "CSUrl.h"
#import "CSUserDefaults.h"
#import "CSProjectDefault.h"
#import "MBProgressHUD+CYH.h"
#import "CSHttpRequestManager.h"
#import "CSConfig.h"
#import "CSNormalCourseDetailViewController.h"
#import "CSSearchCourseViewController.h"
#define kCSCourseListTableViewCell @"CSCourseListTableViewCell"

@interface CSCourseListViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) SMBaseTableView *courseTable;

@property (nonatomic, strong) NSMutableArray *dataSourceAry;

@property (nonatomic, strong) NSNumber *currentCategoryId;

@property (nonatomic, strong) NSString *courseType;
@end

@implementation CSCourseListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
     self.dataSourceAry = [NSMutableArray array];
    [self.view addSubview:self.courseTable];
    if (self.courseListType == CSCourseListRepositoryType) {
        [self.searchBtn setHidden:NO];
    }
    [self setupRefresh];
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

#pragma mark controlInit
- (void)setupRefresh{
    WS(weakSelf);
    [self.courseTable refreshHeaderRefresh:^{
        [weakSelf loadInformation];
    } withFooterRefreshingBlock:^{
        [weakSelf loadInformation];
    }];
    [self.courseTable beginRefreshing];
    
}
#pragma mark Logic
- (void)loadInformation{
    
    NSDictionary *params = @{@"catalogId":self.currentCategoryId,
                            
                             @"page":@(self.courseTable.page),
                             @"type":self.courseType};
    
    __weak CSCourseListViewController *weakSelf = self;
    [MBProgressHUD showMessage:@"加载中..." toView:self.view];
    [[CSHttpRequestManager shareManager] postDataFromNetWork:GET_COURSE_LIST parameters:params success:^(CSHttpRequestManager *manager, id model) {
        [MBProgressHUD hideHUDForView:weakSelf.view];
        
        NSArray *courseArr = model[@"courseList"];
        NSMutableArray *arrayDada = [NSMutableArray array];
        for (NSDictionary *courseDic in courseArr) {
            CSSpecialListModel *course = [[CSSpecialListModel alloc]initWithDictionary:courseDic error:nil];
            [arrayDada addObject:course];
        }
        if (self.courseTable.refreshState == SMBaseTableViewRefreshStateHeader) {
            self.dataSourceAry = arrayDada;
        }else{
            [self.dataSourceAry addObjectsFromArray:arrayDada];
        }
        [self.courseTable endReload];
    } failture:^(CSHttpRequestManager *manager, id nodel) {
       [self.courseTable endRefreshing];
    }];


}

#pragma mark delegate method
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    return [self.dataSourceAry count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    CSCourseListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([CSCourseListTableViewCell class])];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [cell setCourseCell:self.dataSourceAry[indexPath.row]];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    CSCourseListModel *model = self.dataSourceAry[indexPath.row];
    CSNormalCourseDetailViewController *detailVC = [[CSNormalCourseDetailViewController alloc] initWithCourseId:model.courseId
                                                                                                    CoureseName:model.name];
    [self.navigationController pushViewController:detailVC animated:YES];
}

#pragma mark init
- (id)initWithCategory:(NSNumber *)categoryId CategoryName:(NSString *)categoryName CourseType:(NSString *)courseType{

    self = [super init];
    if ( self ) {
        self.currentCategoryId = categoryId;
        self.title = categoryName;
        self.courseType = courseType;
    }
    
    return self;
}

- (UITableView *)courseTable{

    if ( !_courseTable ) {
        CGRect frame = self.view.frame;
        frame.size.height -= 64;
        _courseTable = [[SMBaseTableView alloc] initWithFrame:frame];
        _courseTable.delegate = self;
        _courseTable.dataSource = self;
        _courseTable.rowHeight = 80;
        [_courseTable registerNib:[UINib nibWithNibName:NSStringFromClass([CSCourseListTableViewCell class]) bundle:nil]
           forCellReuseIdentifier:NSStringFromClass([CSCourseListTableViewCell class])];
        _courseTable.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    }
    return _courseTable;
}

-(void)searchAction:(UIButton *)sender{
    CSSearchCourseViewController *searchVC = [[CSSearchCourseViewController alloc]init];
    searchVC.rootVC = self;
    searchVC.searchType = CSSearchRepositoryType;
    self.topNav = [[CSBaseNavigationController alloc]initWithRootViewController:searchVC];
    [self.tabBarController addChildViewController:self.topNav];
    [self.tabBarController.view addSubview:self.topNav.view];
}

@end
