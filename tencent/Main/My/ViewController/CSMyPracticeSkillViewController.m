//
//  CSMyPracticeSkillViewController.m
//  tencent
//
//  Created by cyh on 16/7/26.
//  Copyright © 2016年 cyh. All rights reserved.
//

#import "CSMyPracticeSkillViewController.h"
#import "CSUrl.h"
#import "CSHttpRequestManager.h"
#import "CSUserDefaults.h"
#import "CSProjectDefault.h"
#import "CSFrameConfig.h"
#import "CSStudySkillCell.h"
#import "CSColorConfig.h"
#import "MJRefresh.h"
#import "NSDictionary+convenience.h"
#import "MBProgressHUD+CYH.h"
#import "CSConfig.h"
#import "CSStudySkillModel.h"
#import "UITableView+SDAutoTableViewCellHeight.h"
#import "CSExamContentViewController.h"
#import "SMBaseTableView.h"
#import "ConstFile.h"
#import "CSExamResultViewController.h"

@interface CSMyPracticeSkillViewController ()<UITableViewDelegate,UITableViewDataSource>

/**
 *  table
 */
@property (nonatomic, strong) SMBaseTableView *examTable;
/**
 *  数组
 */
@property (nonatomic, strong) NSMutableArray *examLists;

@end

@implementation CSMyPracticeSkillViewController

static NSString *studySkillIdentifier = @"studySkillCell";

- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.examLists = [NSMutableArray array];
    [self initUI];
    [self setupRefresh];

    // Do any additional setup after loading the view.
}

#pragma mark controlInit
-(void)initUI{
    _examTable = [[SMBaseTableView alloc] initWithFrame:CGRectMake(0, 0, kCSScreenWidth, kCSScreenHeight - KNavigationHegiht - 44) style:UITableViewStylePlain];
    _examTable.backgroundColor = kBGColor;
    _examTable.delegate = self;
    _examTable.dataSource = self;
    _examTable.rowHeight = 80.0;
    _examTable.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    [self.view addSubview:_examTable];
    [_examTable registerClass:[CSStudySkillCell class] forCellReuseIdentifier:studySkillIdentifier];
}

#pragma mark loadData
- (void)loadData:(BOOL)reload{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setValue:@(CONST_RP) forKey:@"rp"];
    [params setValue:@(self.examTable.page) forKey:@"page"];
    [[CSHttpRequestManager shareManager] postDataFromNetWork:MY_SKILL parameters:params success:^(CSHttpRequestManager *manager, id model) {
        NSArray *array = model[@"examList"];
        NSMutableArray *arrayData = [NSMutableArray array];
        for (NSDictionary *caselDic in array) {
            CSStudySkillModel *studyCase = [[CSStudySkillModel alloc] initWithDictionary:caselDic error:nil];
            [arrayData addObject:studyCase];
        }
        if (self.examTable.refreshState == SMBaseTableViewRefreshStateHeader) {
            self.examLists = arrayData;
        }else{
            [self.examLists addObjectsFromArray:arrayData];
        }
        [self.examTable endReload];
    } failture:^(CSHttpRequestManager *manager, id nodel) {
        [self.examTable endRefreshing];
    }];
}

#pragma mark UITableViewDelegate UITableViewDataSourse
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.examLists.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    CSStudySkillCell *cell = [tableView dequeueReusableCellWithIdentifier:studySkillIdentifier];
    CSStudySkillModel *studySkillModel = self.examLists[indexPath.row];
    cell.studySkillModel = studySkillModel;
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    CSStudySkillModel *studyCaseModel = self.examLists[indexPath.row];
    return [self.examTable cellHeightForIndexPath:indexPath model:studyCaseModel keyPath:@"studySkillModel" cellClass:[CSStudySkillCell class] contentViewWidth:kCSScreenWidth ];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    CSExamResultViewController *examResultVC = [[CSExamResultViewController alloc]init];
    CSStudySkillModel *studyCaseModel = self.examLists[indexPath.row];
    examResultVC.examActivityId = studyCaseModel.examActivityId;
    [self.navigationController pushViewController:examResultVC animated:YES];
}

#pragma mark setRefresh
- (void)setupRefresh{
    WS(weakSelf);
    [self.examTable refreshHeaderRefresh:^{
        [self loadData:YES];
    } withFooterRefreshingBlock:^{
        [weakSelf loadData:NO];
    }];
    [self.examTable beginRefreshing];
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
