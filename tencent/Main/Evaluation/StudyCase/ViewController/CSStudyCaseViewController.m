//
//  CSStudyCaseViewController.m
//  tencent
//
//  Created by admin on 16/5/12.
//  Copyright © 2016年 cyh. All rights reserved.
//

#import "CSStudyCaseViewController.h"
#import "CSUrl.h"
#import "CSHttpRequestManager.h"
#import "CSUserDefaults.h"
#import "CSProjectDefault.h"
#import "CSFrameConfig.h"
#import "CSStudyCaseCell.h"
#import "CSColorConfig.h"
#import "MJRefresh.h"
#import "NSDictionary+convenience.h"
#import "MBProgressHUD+CYH.h"
#import "CSConfig.h"
#import "CSStudyCaseModel.h"
#import "UITableView+SDAutoTableViewCellHeight.h"
#import "CSStudyCaseDetailViewController.h"
#import "SMBaseTableView.h"
#import "ConstFile.h"
#import "CSHttpRequestManager.h"
@interface CSStudyCaseViewController ()<UITableViewDelegate,UITableViewDataSource>
/**
 *  table
 */
@property (nonatomic, strong) SMBaseTableView *caseTable;
/**
 *  数组
 */
@property (nonatomic, strong) NSMutableArray *caseLists;

@end

@implementation CSStudyCaseViewController

static NSString *studyCaseIdentifier = @"studyCaseCell";

- (void)viewDidLoad {
    [super viewDidLoad];
    self.caseLists = [NSMutableArray array];
    [self initUI];
    [self setupRefresh];
    // Do any additional setup after loading the view.
}


- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    if( self.changeProject ){
        self.changeProject = NO;
        self.caseTable.page = 1;
        [self loadData:YES];
    }
}
#pragma mark controlInit
-(void)initUI{
        _caseTable = [[SMBaseTableView alloc] initWithFrame:CGRectMake(0, 0, kCSScreenWidth, kCSScreenHeight - KNavigationHegiht - 49 - 44) style:UITableViewStylePlain];
        _caseTable.backgroundColor = kBGColor;
        _caseTable.delegate = self;
        _caseTable.dataSource = self;
        _caseTable.rowHeight = 80.0;
        _caseTable.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
        [self.view addSubview:_caseTable];
        [_caseTable registerClass:[CSStudyCaseCell class] forCellReuseIdentifier:studyCaseIdentifier];
}

- (void)changedProjectMenuItem{
    self.caseLists = [NSMutableArray array];
    self.caseTable.page = 1;
    [self loadData:YES];
}
#pragma mark loadData
- (void)loadData:(BOOL)reload{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setValue:@(CONST_RP) forKey:@"rp"];
    [params setValue:@(self.caseTable.page) forKey:@"page"];
    NSNumber *projectId = [[CSProjectDefault shareProjectDefault] getProjectId];
    [params setValue:projectId forKey:@"projectId"];
    [[CSHttpRequestManager shareManager] postDataFromNetWork:GET_STUDY_CASE_LIST parameters:params success:^(CSHttpRequestManager *manager, id model) {
        if ([model[@"code"] intValue] == 0) {
            NSArray *array = model[@"caseList"];
            NSMutableArray *arrayData = [NSMutableArray array];
            for (NSDictionary *caselDic in array) {
                CSStudyCaseModel *studyCase = [[CSStudyCaseModel alloc] initWithDictionary:caselDic error:nil];
                [arrayData addObject:studyCase];
            }
            if (self.caseTable.page == 1) {
                [self.caseLists removeAllObjects];
            }
            if (self.caseTable.refreshState == SMBaseTableViewRefreshStateHeader) {
                self.caseLists = arrayData;
            }else{
                [self.caseLists addObjectsFromArray:arrayData];
            }
            [self.caseTable endReload];
        }else{
            [self.caseTable endRefreshing];
        }

    } failture:^(CSHttpRequestManager *manager, id nodel) {
        [self.caseTable endRefreshing];
    }];
}

#pragma mark UITableViewDelegate UITableViewDataSourse
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.caseLists.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    CSStudyCaseCell *cell = [tableView dequeueReusableCellWithIdentifier:studyCaseIdentifier];
    CSStudyCaseModel *studyCaseModel = self.caseLists[indexPath.row];
    cell.studyCaseModel = studyCaseModel;
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
     CSStudyCaseModel *studyCaseModel = self.caseLists[indexPath.row];
    return [self.caseTable cellHeightForIndexPath:indexPath model:studyCaseModel keyPath:@"studyCaseModel" cellClass:[CSStudyCaseCell class] contentViewWidth:kCSScreenWidth];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    self.changeProject = NO;
    CSStudyCaseDetailViewController *detailVC= [[CSStudyCaseDetailViewController alloc] init];
    CSStudyCaseModel *studyCaseModel = self.caseLists[indexPath.row];
    detailVC.caseId = studyCaseModel.caseId;
    detailVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:detailVC animated:YES];
}

#pragma mark setRefresh
- (void)setupRefresh{
    WS(weakSelf);
    [self.caseTable refreshHeaderRefresh:^{
        [self loadData:YES];
    } withFooterRefreshingBlock:^{
        [weakSelf loadData:NO];
    }];
    [self.caseTable beginRefreshing];
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
