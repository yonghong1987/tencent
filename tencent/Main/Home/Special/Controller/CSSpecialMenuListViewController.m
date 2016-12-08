//
//  CSSpecialMenuListViewController.m
//  tencent
//
//  Created by admin on 16/5/3.
//  Copyright © 2016年 cyh. All rights reserved.
//

#import "CSSpecialMenuListViewController.h"
#import "CSUrl.h"
#import "CSHttpRequestManager.h"
#import "CSUserDefaults.h"
#import "CSConfig.h"
#import "CSFrameConfig.h"
#import "CSColorConfig.h"
#import "MJRefresh.h"
#import "NSDictionary+convenience.h"
#import "MBProgressHUD+CYH.h"
#import "CSSpecialListModel.h"
#import "CSCourseListTableViewCell.h"
#import "CSSpecialDetailViewController.h"
@interface CSSpecialMenuListViewController ()
@property (nonatomic, strong) NSMutableArray *specialLists;// 专题列表数组
@end

@implementation CSSpecialMenuListViewController

static NSString *const kSpecialListCell = @"CSCourseListTableViewCell";

- (void)viewDidLoad {
    [super viewDidLoad];
    self.specialLists = [NSMutableArray array];
    [self loadData:YES];
    [self setupRefresh];
    self.automaticallyAdjustsScrollViewInsets = NO;
    // Do any additional setup after loading the view.
}

#pragma mark controlInit
- (UITableView *)specialTable{
    if (!_specialTable) {
        _specialTable = [[SMBaseTableView alloc]initWithFrame:CGRectMake(0, -39, kCSScreenWidth, kCSScreenHeight - KNavigationHegiht - 9 ) style:UITableViewStyleGrouped];
        _specialTable.delegate = self;
        _specialTable.dataSource = self;
        _specialTable.rowHeight = 80.0;
        _specialTable.backgroundColor = kBGColor;
        _specialTable.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
        _specialTable.showsVerticalScrollIndicator = NO;
        [self.view addSubview:_specialTable];
        [_specialTable registerNib:[UINib nibWithNibName:@"CSCourseListTableViewCell" bundle:nil] forCellReuseIdentifier:kSpecialListCell];
    }
    return _specialTable;
}

#pragma mark loadData
- (void)loadData:(BOOL)reload{
    NSMutableDictionary *paramters = [NSMutableDictionary dictionary];
    [paramters setValue:self.specialMenuid forKey:@"catalogId"];
    [paramters setValue:@(RP) forKey:@"rp"];
    [paramters setValue:@(self.specialTable.page) forKey:@"page"];
//    [paramters setValue:@"SEMINAR" forKey:@"type"];
    [[CSHttpRequestManager shareManager] postDataFromNetWork:GET_SPECIAL_LIST parameters:paramters success:^(CSHttpRequestManager *manager, id model) {
        NSArray *array = [(NSDictionary *)model arrayForKey:@"courseList"];
        NSMutableArray *arrayData = [NSMutableArray array];
        for (NSDictionary *specialDic in array) {
            CSSpecialListModel *special = [[CSSpecialListModel alloc]initWithDictionary:specialDic error:nil];
            [arrayData addObject:special];
        }
        if (self.specialTable.refreshState == SMBaseTableViewRefreshStateHeader) {
            self.specialLists = arrayData;
        }else{
            [self.specialLists addObjectsFromArray:arrayData];
        }
        [self.specialTable endReload];
    } failture:^(CSHttpRequestManager *manager, id nodel) {
         [self.specialTable endRefreshing];
    }];
}

#pragma mark -  UITableViewDelegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.specialLists.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    CSCourseListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kSpecialListCell];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [cell setSpecialCell:self.specialLists[indexPath.row]];
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 10.0;
}
//
//-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
//    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kCSScreenWidth, 10)];
//    view.backgroundColor = kBGColor;
//    return view;
//}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    CSSpecialDetailViewController *specialDetailVC = [[CSSpecialDetailViewController alloc] init];
    CSSpecialListModel *specialModel = self.specialLists[indexPath.row];
    specialDetailVC.specialid = specialModel.courseId;
    
    [self.navigationController pushViewController:specialDetailVC animated:YES];

}

#pragma mark controlInit
- (void)setupRefresh{
    WS(weakSelf);
    [self.specialTable refreshHeaderRefresh:^{
        [weakSelf loadData:YES];
    } withFooterRefreshingBlock:^{
        [weakSelf loadData:NO];
    }];
    [self.specialTable beginRefreshing];

}

-(void)dealloc{

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
