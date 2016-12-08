//
//  CSHotCourseListViewController.m
//  tencent
//
//  Created by bill on 16/4/28.
//  Copyright © 2016年 cyh. All rights reserved.
//

#import "CSHotCourseListViewController.h"


#import "CSCourseListTableViewCell.h"
#import "CSHotCourseListModel.h"

#import "CSNormalCourseDetailViewController.h"
#import "CSUtilFunction.h"

#import "MBProgressHUD+CYH.h"
#import "CSHttpRequestManager.h"
#import "CSUserModel.h"
#import "CSUserDefaults.h"
#import "CSProjectDefault.h"
#import "CSUrl.h"
#import "MJRefresh.h"
#import "CSConfig.h"
#import "SMBaseTableView.h"
#import "CSFrameConfig.h"
#import "CSColorConfig.h"
@interface CSHotCourseListViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) NSMutableArray *dataSourceAry;

@property (nonatomic, strong) SMBaseTableView *coursesTable;

@property (nonatomic, assign) NSInteger currentPage;

@end

@implementation CSHotCourseListViewController

#pragma mark life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    self.view.backgroundColor = kBGColor;

    [self initData];
    [self.view addSubview:self.coursesTable];
    [self refreashInformation];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

#pragma mark logic
/**
 *  加载更多数据
 */
- (void)loadMoreInformation{
    self.currentPage ++;
    [self loadInformation];
}

/**
 *  刷新数据
 */
- (void)refreashInformation{
    self.currentPage = 1;
    [self loadInformation];
}

/**
 *  请求数据
 */
- (void)loadInformation{
    
    NSDictionary *params = @{@"projectId":[[CSProjectDefault shareProjectDefault] getProjectId],
                             @"rp":@"10",
                             @"page":[NSNumber numberWithInteger:self.currentPage],
                             @"type":@"HOT"};
    
    __weak CSHotCourseListViewController *weakSelf = self;
    [MBProgressHUD showMessage:@"加载中..." toView:self.view];
    [[CSHttpRequestManager shareManager] postDataFromNetWork:GET_COURSE_LIST parameters:params success:^(CSHttpRequestManager *manager, id model) {
        [MBProgressHUD hideHUDForView:weakSelf.view];
        
        [weakSelf.coursesTable.mj_header endRefreshing];
        [weakSelf.coursesTable.mj_footer endRefreshing];
        
        if( [model objectForKey:@"code"] && [[model objectForKey:@"code"] integerValue] == 0 ){
            
            if ( 1 == self.currentPage ) {
                [self.dataSourceAry removeAllObjects];
                if ( [[model objectForKey:@"courseList"] isKindOfClass:[NSArray class]] ) {
                    for ( NSDictionary *dic in [model objectForKey:@"courseList"] ) {
                        [self.dataSourceAry addObject:[[CSHotCourseListModel alloc] initWithDictionary:dic error:nil]];
                    }
                }
                [self.coursesTable reloadData];
            }
            
        }
        
    } failture:^(CSHttpRequestManager *manager, id nodel) {
        
        [weakSelf.coursesTable.mj_header endRefreshing];
        [weakSelf.coursesTable.mj_footer endRefreshing];
        
        [MBProgressHUD hideHUDForView:weakSelf.view];
        [MBProgressHUD showError:@"请求超时"];
    }];
    
}


#pragma mark UItableView Delegate Mehtod
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.dataSourceAry count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    CSCourseListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([CSCourseListTableViewCell class])];
    
    [cell setHotCourseCell:self.dataSourceAry[indexPath.row]];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    CSHotCourseListModel *model = self.dataSourceAry[indexPath.row];
    CSNormalCourseDetailViewController *detailVC = [[CSNormalCourseDetailViewController alloc] initWithCourseId:model.courseId
                                                                                                    CoureseName:model.name];
     detailVC.praiseCount = [model.praiseCount integerValue];
    detailVC.changePraiseType =  CSChangeePraiseCountType;
    UINavigationController *nav = [CSUtilFunction getCurrentRootNavigationController];
    detailVC.passBrowse = ^(NSInteger count,NSInteger praiseCount){
        NSInteger viewAmount = [model.viewAmount integerValue] + count;
        model.viewAmount = [NSNumber numberWithInteger:viewAmount];
        model.praiseCount = [NSNumber numberWithInteger:praiseCount];
        NSIndexPath *clickIndexPath = [NSIndexPath indexPathForRow:indexPath.row inSection:0];
        [tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:clickIndexPath, nil] withRowAnimation:UITableViewRowAnimationAutomatic];
    };
    [nav pushViewController:detailVC animated:YES];
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 10.0;
}
#pragma mark init
- (UITableView *)coursesTable{
    
    if ( !_coursesTable ) {
        _coursesTable = [[SMBaseTableView alloc]initWithFrame:CGRectMake(0, -kCSTableViewTopPadding, kCSScreenWidth, kCSScreenHeight - KNavigationHegiht - 44 + kCSTableViewTopPadding) style:UITableViewStyleGrouped];
        _coursesTable.delegate = self;
        _coursesTable.dataSource = self;
         _coursesTable.showsVerticalScrollIndicator = NO;
        _coursesTable.backgroundColor = kBGColor;
        [_coursesTable registerNib:[UINib nibWithNibName:NSStringFromClass([CSCourseListTableViewCell class]) bundle:nil]
         forCellReuseIdentifier:NSStringFromClass([CSCourseListTableViewCell class])];
        
        _coursesTable.rowHeight = 80;
        _coursesTable.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
        
        __weak CSHotCourseListViewController *weakSelf = self;
        _coursesTable.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            [weakSelf refreashInformation];
        }];
        _coursesTable.mj_footer = [MJRefreshAutoFooter footerWithRefreshingBlock:^{
            [weakSelf loadMoreInformation];
        }];
    }
    return _coursesTable;
}

- (void)initData{
    
    self.currentPage = 1;
    self.dataSourceAry = [NSMutableArray array];
}
@end
