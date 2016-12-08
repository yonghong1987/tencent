//
//  CSStudyMapViewController.m
//  tencent
//
//  Created by admin on 16/5/12.
//  Copyright © 2016年 cyh. All rights reserved.
//

#import "CSStudyMapViewController.h"
#import "CSUrl.h"
#import "CSHttpRequestManager.h"
#import "CSUserDefaults.h"
#import "CSProjectDefault.h"
#import "CSFrameConfig.h"
#import "CSCourseListTableViewCell.h"
#import "CSColorConfig.h"
#import "MJRefresh.h"
#import "NSDictionary+convenience.h"
#import "MBProgressHUD+CYH.h"
#import "CSConfig.h"
#import "CSStudyMapModel.h"
#import "UITableView+SDAutoTableViewCellHeight.h"
#import "SMBaseTableView.h"
#import "ConstFile.h"
#import "CSMapCheckPointViewController.h"
@interface CSStudyMapViewController ()<UITableViewDelegate,UITableViewDataSource>

/**
 *  table
 */
@property (nonatomic, strong) SMBaseTableView *mapTable;
/**
 *  数组
 */
@property (nonatomic, strong) NSMutableArray *mapLists;
@end

@implementation CSStudyMapViewController

static NSString *const kSpecialListCell = @"CSCourseListTableViewCell";
- (void)viewDidLoad {
    [super viewDidLoad];
    self.mapLists = [NSMutableArray array];
    [self initUI];
    [self setupRefresh];

        // Do any additional setup after loading the view.
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if( self.changeProject ){
        self.changeProject = NO;
        self.mapTable.page = 1;
        [self loadData:YES];
    }

}

#pragma mark controlInit
-(void)initUI{
    _mapTable = [[SMBaseTableView alloc] initWithFrame:CGRectMake(0, 0, kCSScreenWidth, kCSScreenHeight - KNavigationHegiht - 44 - 49) style:UITableViewStylePlain];
    _mapTable.backgroundColor = kBGColor;
    _mapTable.delegate = self;
    _mapTable.dataSource = self;
    _mapTable.rowHeight = 80.0;
    _mapTable.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    [self.view addSubview:_mapTable];
   [_mapTable registerNib:[UINib nibWithNibName:@"CSCourseListTableViewCell" bundle:nil] forCellReuseIdentifier:kSpecialListCell];
}

- (void)changedProjectMenuItem{
    self.mapLists = [NSMutableArray array];
    self.mapTable.page = 1;
    [self loadData:YES];
}
#pragma mark loadData
- (void)loadData:(BOOL)reload{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setValue:@(CONST_RP) forKey:@"rp"];
    [params setValue:@(self.mapTable.page) forKey:@"page"];
    NSNumber *projectId = [[CSProjectDefault shareProjectDefault] getProjectId];
    [params setValue:projectId forKey:@"projectId"];
    
    [[CSHttpRequestManager shareManager] postDataFromNetWork:GET_STUDY_MAP_LIST parameters:params success:^(CSHttpRequestManager *manager, id model) {
        NSArray *array = model[@"mapList"];
        NSMutableArray *arrayData = [NSMutableArray array];
        for (NSDictionary *caselDic in array) {
            CSStudyMapModel *studyCase = [[CSStudyMapModel alloc] initWithDictionary:caselDic error:nil];
            [arrayData addObject:studyCase];
        }
        if (self.mapTable.page == 1) {
            [self.mapLists removeAllObjects];
        }
        if (self.mapTable.refreshState == SMBaseTableViewRefreshStateHeader) {
            self.mapLists = arrayData;
        }else{
            [self.mapLists addObjectsFromArray:arrayData];
        }
        [self.mapTable endReload];
       [self.mapTable endRefreshing];
    } failture:^(CSHttpRequestManager *manager, id nodel) {
        [self.mapTable endRefreshing];
    }];
}

#pragma mark UITableViewDelegate UITableViewDataSourse
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.mapLists.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    CSCourseListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kSpecialListCell];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [cell setMapCell:self.mapLists[indexPath.row]];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    self.changeProject = NO;
    CSStudyMapModel *mapModel = self.mapLists[indexPath.row];
    CSMapCheckPointViewController *mapCheck = [[CSMapCheckPointViewController alloc]init];
    mapCheck.hidesBottomBarWhenPushed = YES;
    mapCheck.mapModel = mapModel;
    [self.navigationController pushViewController:mapCheck animated:YES];
}


#pragma  mark setRefresh
- (void)setupRefresh{
    WS(weakSelf);
    [self.mapTable refreshHeaderRefresh:^{
        [self loadData:YES];
    } withFooterRefreshingBlock:^{
        [weakSelf loadData:NO];
    }];
    [self.mapTable beginRefreshing];
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
