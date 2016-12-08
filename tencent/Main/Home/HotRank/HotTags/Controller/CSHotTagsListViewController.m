//
//  CSHotTagsListViewController.m
//  tencent
//
//  Created by bill on 16/4/28.
//  Copyright © 2016年 cyh. All rights reserved.
//

#import "CSHotTagsListViewController.h"
#import "CSHotTagsTableViewCell.h"

#import "MBProgressHUD+CYH.h"
#import "CSHttpRequestManager.h"
#import "CSUserModel.h"
#import "CSUserDefaults.h"
#import "CSProjectDefault.h"
#import "CSUrl.h"
#import "MJRefresh.h"
#import "CSConfig.h"
#import "CSFrameConfig.h"
#import "CSHotTagsListModel.h"
#import "CSTagCourseViewController.h"
#define KCSHotTagsTableViewCell @"CSHotTagsTableViewCell"

@interface CSHotTagsListViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) NSMutableArray *dataSourceAry;

@property (nonatomic, strong) UITableView *tagsTable;

@property (nonatomic, assign) NSInteger currentPage;

@end

@implementation CSHotTagsListViewController

#pragma mark life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    
    [self initData];
    [self.view addSubview:self.tagsTable];
    [self refreashInformation];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(refreashInformation)
                                                 name:kChangeProjectNotifycation
                                               object:nil];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    if ([self respondsToSelector:@selector(setEdgesForExtendedLayout:)]) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
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
 *  加载更多
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
                             @"token":[[CSUserDefaults shareUserDefault] getUserToken],
                             @"rp":@"10",
                             @"page":[NSNumber numberWithInteger:self.currentPage]};

    __weak CSHotTagsListViewController *weakSelf = self;
    [MBProgressHUD showMessage:@"加载中..." toView:self.view];
    [[CSHttpRequestManager shareManager] postDataFromNetWork:GET_HOT_SPECIAL parameters:params success:^(CSHttpRequestManager *manager, id model) {
        [MBProgressHUD hideHUDForView:weakSelf.view];
        
        [weakSelf.tagsTable.mj_header endRefreshing];
        [weakSelf.tagsTable.mj_footer endRefreshing];
        
        if( [model objectForKey:@"code"] && [[model objectForKey:@"code"] integerValue] == 0 ){
            
            if ( 1 == self.currentPage ) {
                [self.dataSourceAry removeAllObjects];
                if ( [[model objectForKey:@"specialList"] isKindOfClass:[NSArray class]] ) {
                    for ( NSDictionary *dic in [model objectForKey:@"specialList"] ) {
                        [self.dataSourceAry addObject:[[CSHotTagsListModel alloc] initWithDictionary:dic error:nil]];
                    }
                }
                [self.tagsTable reloadData];
            }
            
        }
        
    } failture:^(CSHttpRequestManager *manager, id nodel) {
        
        [weakSelf.tagsTable.mj_header endRefreshing];
        [weakSelf.tagsTable.mj_footer endRefreshing];
        
        [MBProgressHUD hideHUDForView:weakSelf.view];
        [MBProgressHUD showError:@"请求超时"];
    }];

}


#pragma mark UItableView Delegate Mehtod
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.dataSourceAry count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    CSHotTagsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:KCSHotTagsTableViewCell];
    
    [cell setCellInfo:self.dataSourceAry[indexPath.row]];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    CSHotTagsListModel *tagList = self.dataSourceAry[indexPath.row];
    CSTagCourseViewController *tagCourse = [[CSTagCourseViewController alloc]init];
    tagCourse.tagList = tagList;
    [self.navigationController pushViewController:tagCourse animated:YES];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 10.0;
}

#pragma mark init
- (UITableView *)tagsTable{
    
    if ( !_tagsTable ) {
        _tagsTable = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kCSScreenWidth, kCSScreenHeight - KNavigationHegiht +kCSTableViewTopPadding) style:UITableViewStyleGrouped];
        _tagsTable.delegate = self;
        _tagsTable.dataSource = self;
        _tagsTable.showsVerticalScrollIndicator = NO;
        [_tagsTable registerNib:[UINib nibWithNibName:@"CSHotTagsTableViewCell" bundle:nil]
         forCellReuseIdentifier:KCSHotTagsTableViewCell];
        
        _tagsTable.rowHeight = 208;
        _tagsTable.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
        
        __weak CSHotTagsListViewController *weakSelf = self;
        _tagsTable.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            [weakSelf refreashInformation];
        }];
        
        _tagsTable.mj_footer = [MJRefreshAutoFooter footerWithRefreshingBlock:^{
            [weakSelf loadMoreInformation];
        }];
    }
    return _tagsTable;
}

- (void)initData{
    
    self.currentPage = 1;
    self.dataSourceAry = [NSMutableArray array];
}
@end
