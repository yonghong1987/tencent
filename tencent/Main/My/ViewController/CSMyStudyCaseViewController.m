//
//  CSMyStudyCaseViewController.m
//  tencent
//
//  Created by cyh on 16/7/26.
//  Copyright © 2016年 cyh. All rights reserved.
//

#import "CSMyStudyCaseViewController.h"
#import "SMBaseTableView.h"
#import "SMBaseNetworkApi.h"
#import "CSFrameConfig.h"
#import "CSColorConfig.h"
#import "CSStudyCaseCell.h"
#import "CSHttpRequestManager.h"
#import "CSStudyCaseDetailModel.h"
#import "CSConfig.h"
#import "UITableView+SDAutoTableViewCellHeight.h"
#import "CSStudyCaseDetailViewController.h"
@interface CSMyStudyCaseViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) SMBaseTableView *caseTable;
@property (nonatomic, strong) NSMutableArray *cases;


@end

@implementation CSMyStudyCaseViewController
static NSString *caseCellIdentifier = @"caseViewCell";
- (void)viewDidLoad {
    [super viewDidLoad];
    self.cases = [NSMutableArray array];
    [self initUI];
    [self setupRefresh];

    // Do any additional setup after loading the view.
}
-(void)initUI{
    self.caseTable = [[SMBaseTableView alloc]initWithFrame:CGRectMake(0, 0, kCSScreenWidth, kCSScreenHeight - KNavigationHegiht - 44) style:UITableViewStylePlain];
    self.caseTable.delegate = self;
    self.caseTable.dataSource = self;
    self.caseTable.backgroundColor = kBGColor;
    self.caseTable.tableFooterView = [[UIView alloc]initWithFrame:CGRectZero];
    self.caseTable.rowHeight = 80.0;
    [self.view addSubview:self.caseTable];
     [_caseTable registerClass:[CSStudyCaseCell class] forCellReuseIdentifier:caseCellIdentifier];
}

- (void)setupRefresh{
    WS(weakSelf);
    [self.caseTable refreshHeaderRefresh:^{
        [weakSelf loadData];
    } withFooterRefreshingBlock:^{
        [weakSelf loadData];
    }];
    [self.caseTable beginRefreshing];
}
-(void)loadData{
    NSDictionary *parames = @{@"rp":@(RP),@"page":@(self.caseTable.page)};
    [[CSHttpRequestManager shareManager] postDataFromNetWork:MY_CASE parameters:parames success:^(CSHttpRequestManager *manager, id model) {
        NSArray *caseArr = model[@"caseList"];
        NSMutableArray *arrayDada = [NSMutableArray array];
        for (NSDictionary *caseDic in caseArr) {
            CSStudyCaseModel *studyCase = [[CSStudyCaseModel alloc]initWithDictionary:caseDic error:nil];
            [arrayDada addObject:studyCase];
        }
        if (self.caseTable.refreshState == SMBaseTableViewRefreshStateHeader) {
            self.cases = arrayDada;
        }else{
            [self.cases addObjectsFromArray:arrayDada];
        }
        [self.caseTable endReload];
    } failture:^(CSHttpRequestManager *manager, id nodel) {
        [self.caseTable endRefreshing];
    }];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.cases.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    CSStudyCaseCell *cell = [tableView dequeueReusableCellWithIdentifier:caseCellIdentifier];
    CSStudyCaseModel *studyCaseModel = self.cases[indexPath.row];
    cell.studyCaseModel = studyCaseModel;
    return cell;
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    CSStudyCaseModel *studyCaseModel = self.cases[indexPath.row];
    return [self.caseTable cellHeightForIndexPath:indexPath model:studyCaseModel keyPath:@"studyCaseModel" cellClass:[CSStudyCaseCell class] contentViewWidth:kCSScreenWidth];
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    CSStudyCaseDetailViewController *detailVC= [[CSStudyCaseDetailViewController alloc] init];
    CSStudyCaseModel *studyCaseModel = self.cases[indexPath.row];
    detailVC.caseId = studyCaseModel.caseId;
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
