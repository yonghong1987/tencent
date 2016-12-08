//
//  CSMySpecialViewController.m
//  tencent
//
//  Created by cyh on 16/7/26.
//  Copyright © 2016年 cyh. All rights reserved.
//

#import "CSMySpecialViewController.h"
#import "SMBaseTableView.h"
#import "CSFrameConfig.h"
#import "CSColorConfig.h"
#import "CSUrl.h"
#import "CSHttpRequestManager.h"
#import "CSCourseListTableViewCell.h"
#import "CSConfig.h"
#import "CSSpecialListModel.h"
#import "CSSpecialDetailViewController.h"
@interface CSMySpecialViewController ()
<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) SMBaseTableView *specialTable;
@property (nonatomic, strong) NSMutableArray *specicals;

@end

@implementation CSMySpecialViewController

static NSString *specialCellIdentifier = @"CSSpecialListTableViewCell";
- (void)viewDidLoad {
    [super viewDidLoad];
    self.specicals = [NSMutableArray array];
    [self initUI];
    [self setupRefresh];
    // Do any additional setup after loading the view.
}
-(void)initUI{
    self.specialTable = [[SMBaseTableView alloc]initWithFrame:CGRectMake(0, -kCSTableViewTopPadding, kCSScreenWidth, kCSScreenHeight - KNavigationHegiht - 44 + kCSTableViewTopPadding) style:UITableViewStyleGrouped];
    self.specialTable.delegate = self;
    self.specialTable.dataSource = self;
    self.specialTable.backgroundColor = kBGColor;
    self.specialTable.tableFooterView = [[UIView alloc]initWithFrame:CGRectZero];
    self.specialTable.showsVerticalScrollIndicator = NO;
    self.specialTable.rowHeight = 80.0;
    [self.view addSubview:self.specialTable];
    [self.specialTable registerNib:[UINib nibWithNibName:NSStringFromClass([CSCourseListTableViewCell class]) bundle:nil] forCellReuseIdentifier:specialCellIdentifier];
    
}

#pragma mark controlInit
- (void)setupRefresh{
    WS(weakSelf);
    [self.specialTable refreshHeaderRefresh:^{
        [weakSelf loadData];
    } withFooterRefreshingBlock:^{
        [weakSelf loadData];
    }];
    [self.specialTable beginRefreshing];
    
}

-(void)loadData{
    NSDictionary *parames = @{@"rp":@(RP),@"page":@(self.specialTable.page),@"type":@"SEMINAR"};
    [[CSHttpRequestManager shareManager] postDataFromNetWork:MY_COLLECT_LIST parameters:parames success:^(CSHttpRequestManager *manager, id model) {
        NSArray *courseArr = model[@"courseList"];
        NSMutableArray *arrayDada = [NSMutableArray array];
        for (NSDictionary *courseDic in courseArr) {
            CSSpecialListModel *course = [[CSSpecialListModel alloc]initWithDictionary:courseDic error:nil];
            [arrayDada addObject:course];
        }
        if (self.specialTable.refreshState == SMBaseTableViewRefreshStateHeader) {
            self.specicals = arrayDada;
        }else{
            [self.specicals addObjectsFromArray:arrayDada];
        }
        [self.specialTable endReload];
    } failture:^(CSHttpRequestManager *manager, id nodel) {
        [self.specialTable endRefreshing];
    }];

}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
        return self.specicals.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    CSCourseListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:specialCellIdentifier];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [cell setSpecialCell:self.specicals[indexPath.row]];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    CSSpecialDetailViewController *specialDetailVC = [[CSSpecialDetailViewController alloc] init];
    CSSpecialListModel *specialModel = self.specicals[indexPath.row];
    specialDetailVC.specialid = specialModel.courseId;
    
    [self.navigationController pushViewController:specialDetailVC animated:YES];

}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 10.0;
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
