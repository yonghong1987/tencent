//
//  CSPracticeSkillViewController.m
//  tencent
//
//  Created by admin on 16/5/12.
//  Copyright © 2016年 cyh. All rights reserved.
//

#import "CSPracticeSkillViewController.h"
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
#import "SMBaseNetworkApi.h"
#import "ConstFile.h"
#import "CSExamResultViewController.h"
#import "CSNotificationConfig.h"
#import "MBProgressHUD+SMHUD.h"
@interface CSPracticeSkillViewController ()<UITableViewDelegate,UITableViewDataSource>

/**
 *  table
 */
@property (nonatomic, strong) SMBaseTableView *examTable;
/**
 *  数组
 */
@property (nonatomic, strong) NSMutableArray *examLists;

@property (nonatomic, strong) SMBaseNetworkApi *netWorkApi;
@end

@implementation CSPracticeSkillViewController

static NSString *studySkillIdentifier = @"studySkillCell";

- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.examLists = [NSMutableArray array];
    [self initUI];
    [self setupRefresh];
    //项目切换时   会触发请求   此时需要重新请求服务器  并刷新数据
    // Do any additional setup after loading the view.
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if ([self respondsToSelector:@selector(setEdgesForExtendedLayout:)]) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    if( self.changeProject ){
        self.changeProject = NO;
        self.examTable.page = 1;
        [self loadData:YES];
    }
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(replaceToPage:) name:passToPage object:nil];
}

-(void)replaceToPage:(NSNotification *)noti{
    NSString *toPage = noti.userInfo[@"toPage"];
    NSInteger whichRow = [noti.userInfo[@"whichRow"] integerValue];
    NSString *statusName = noti.userInfo[@"statusName"];
    CSStudySkillModel *studySkillModel = self.examLists[whichRow];
    studySkillModel.toPage = toPage;
    studySkillModel.statusName = statusName;
    NSIndexPath *index = [NSIndexPath indexPathForRow:whichRow inSection:0];
    [self.examTable reloadRowsAtIndexPaths:@[index] withRowAnimation:UITableViewRowAnimationAutomatic];
}
- (void)changedProjectMenuItem{
    self.examLists = [NSMutableArray array];
    self.examTable.page = 1;
    [self loadData:YES];
}
#pragma mark controlInit
-(void)initUI{
    _examTable = [[SMBaseTableView alloc] initWithFrame:CGRectMake(0, 0, kCSScreenWidth, kCSScreenHeight - KNavigationHegiht - 49 - 44) style:UITableViewStylePlain];
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
    NSNumber *projectId = [[CSProjectDefault shareProjectDefault] getProjectId];
    [params setValue:projectId forKey:@"projectId"];
    [[CSHttpRequestManager shareManager] postDataFromNetWork:GET_PRACTICE_SKILL_LIST parameters:params success:^(CSHttpRequestManager *manager, id model) {
        NSArray *array = model[@"examList"];
        NSMutableArray *arrayData = [NSMutableArray array];
        for (NSDictionary *caselDic in array) {
            CSStudySkillModel *studyCase = [[CSStudySkillModel alloc] initWithDictionary:caselDic error:nil];
            [arrayData addObject:studyCase];
        }
        if (self.examTable.page == 1) {
            [self.examLists removeAllObjects];
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
    CSStudySkillModel *studySkillModel = self.examLists[indexPath.row];
    self.changeProject = NO;
    //查询该跳转到哪个界面
    //如果toPage的值为空，则什么都不做
    if ([studySkillModel.toPage isEqualToString:@""]) {
        //如果toPage的值为EXAMRESULT，则进入考试结果页
    }else if ([studySkillModel.toPage isEqualToString:@"EXAMRESULT"]){
        CSExamResultViewController *examResultVC = [[CSExamResultViewController alloc]init];
        examResultVC.hidesBottomBarWhenPushed = YES;
        examResultVC.examActivityId = studySkillModel.examActivityId;
        examResultVC.examReultType = CSExamResultDataType;
        examResultVC.examContentType = CSSkillListType;
        [self.navigationController pushViewController:examResultVC animated:YES];
        //如果toPage的值为QUESTIONLIST，则进入考试题目页
    }else if ([studySkillModel.toPage isEqualToString:@"QUESTIONLIST"]){
        //如果canTest大于0，则可以进行考试，可以提交
        if ([studySkillModel.canTest integerValue] > 0) {
            NSMutableDictionary *params = [NSMutableDictionary dictionary];
            [params setValue:studySkillModel.examActivityId forKey:@"examActivityId"];
            [[CSHttpRequestManager shareManager] postDataFromNetWork:START_GO_EXAM parameters:params success:^(CSHttpRequestManager *manager, id model) {
                NSNumber *canTest = model[@"canTest"];
                if ([canTest integerValue] > 0 ) {
                    CSExamContentViewController *examContentVC = [[CSExamContentViewController alloc] init];
                    examContentVC.testId = studySkillModel.testId;
                    examContentVC.examActivityId = studySkillModel.examActivityId;
                    examContentVC.actTestHistoryId = [model numberForKey:@"actTestHistoryId"];
                    examContentVC.whichRow = indexPath.row;
                    examContentVC.actTestAttId = [model numberForKey:@"actTestAttId"];
                    examContentVC.startTimestamp = [model numberForKey:@"startTimestamp"];
                    NSInteger examType = 0;
                    examContentVC.examType = [NSNumber numberWithInteger:examType];
                    examContentVC.examReultType = CSExamResultDataType;
                    examContentVC.canTest = canTest;
                    examContentVC.hidesBottomBarWhenPushed = YES;
                    [self.navigationController pushViewController:examContentVC animated:YES];
                }
            } failture:^(CSHttpRequestManager *manager, id nodel) {
                
            }];
            //如果canTest等于0，则只可以查看，不能提交
        }else{
            
            if ([studySkillModel.isOverTime integerValue] == -1) {
                [MBProgressHUD showToView:self.view text:@"还未到开始考试时间！" afterDelay:1.0 hideBlock:^(MBProgressHUD * _Nonnull hud) {
                    
                }];
            }else if ([studySkillModel.isOverTime integerValue] == 1){
                CSExamContentViewController *examContentVC = [[CSExamContentViewController alloc] init];
                examContentVC.testId = studySkillModel.testId;
                examContentVC.examActivityId = studySkillModel.examActivityId;
                NSInteger examType = 0;
                examContentVC.canTest = studySkillModel.canTest;
                examContentVC.examReultType = CSExamResultDataType;
                examContentVC.examType = [NSNumber numberWithInteger:examType];
                examContentVC.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:examContentVC animated:YES];
            }
        }
    }
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

-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
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
