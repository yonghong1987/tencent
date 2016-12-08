//
//  CSMyCourseViewController.m
//  tencent
//
//  Created by cyh on 16/7/26.
//  Copyright © 2016年 cyh. All rights reserved.
//

#import "CSMyCourseViewController.h"
#import "SMBaseTableView.h"
#import "SMBaseNetworkApi.h"
#import "CSFrameConfig.h"
#import "CSColorConfig.h"
#import "CSCourseListTableViewCell.h"
#import "CSHttpRequestManager.h"
#import "CSNormalCourseDetailViewController.h"
#import "CSConfig.h"
@interface CSMyCourseViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) SMBaseTableView *courseTable;
@property (nonatomic, strong) NSMutableArray *courses;
@end

@implementation CSMyCourseViewController

static NSString *courseCellIdentifier = @"CSCourseListTableViewCell";
- (void)viewDidLoad {
    [super viewDidLoad];
    self.courses = [NSMutableArray array];
    [self initUI];
    [self setupRefresh];
    // Do any additional setup after loading the view.
}


-(void)initUI{
    self.courseTable = [[SMBaseTableView alloc]initWithFrame:CGRectMake(0, -kCSTableViewTopPadding, kCSScreenWidth, kCSScreenHeight - KNavigationHegiht - 44 + kCSTableViewTopPadding) style:UITableViewStyleGrouped];
    self.courseTable.delegate = self;
    self.courseTable.dataSource = self;
    self.courseTable.backgroundColor = kBGColor;
    self.courseTable.tableFooterView = [[UIView alloc]initWithFrame:CGRectZero];
    self.courseTable.showsVerticalScrollIndicator = NO;
    self.courseTable.rowHeight = 80.0;
    [self.view addSubview:self.courseTable];
    [self.courseTable registerNib:[UINib nibWithNibName:NSStringFromClass([CSCourseListTableViewCell class]) bundle:nil] forCellReuseIdentifier:courseCellIdentifier];
}

- (void)setupRefresh{
    WS(weakSelf);
    [self.courseTable refreshHeaderRefresh:^{
        [weakSelf loadData];
    } withFooterRefreshingBlock:^{
        [weakSelf loadData];
    }];
    [self.courseTable beginRefreshing];
}
-(void)loadData{
    NSDictionary *parames = @{@"rp":@(RP),@"page":@(self.courseTable.page),@"type":@"ONLINE"};
    [[CSHttpRequestManager shareManager] postDataFromNetWork:MY_COLLECT_LIST parameters:parames success:^(CSHttpRequestManager *manager, id model) {
        NSArray *courseArr = model[@"courseList"];
        NSMutableArray *arrayDada = [NSMutableArray array];
        for (NSDictionary *courseDic in courseArr) {
            CSCourseListModel *course = [[CSCourseListModel alloc]initWithDictionary:courseDic error:nil];
            [arrayDada addObject:course];
        }
        if (self.courseTable.refreshState == SMBaseTableViewRefreshStateHeader) {
            self.courses = arrayDada;
        }else{
            [self.courses addObjectsFromArray:arrayDada];
        }
        [self.courseTable endReload];
    } failture:^(CSHttpRequestManager *manager, id nodel) {
        [self.courseTable endRefreshing];
    }];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.courses.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    CSCourseListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:courseCellIdentifier];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [cell setCourseCell:self.courses[indexPath.row]];
    return cell;
    
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    CSCourseListModel *model = self.courses[indexPath.row];
    
    CSNormalCourseDetailViewController *detailVC = [[CSNormalCourseDetailViewController alloc] initWithCourseId:model.courseId
                                                                                                    CoureseName:model.name];
    [self.navigationController pushViewController:detailVC animated:YES];
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
