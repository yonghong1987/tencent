//
//  CSRequiredViewController.m
//  tencent
//
//  Created by cyh on 16/10/24.
//  Copyright © 2016年 cyh. All rights reserved.
//

#import "CSRequiredViewController.h"
#import "SMBaseTableView.h"
#import "SMBaseNetworkApi.h"
#import "CSFrameConfig.h"
#import "CSColorConfig.h"
#import "CSCourseListTableViewCell.h"
#import "CSHttpRequestManager.h"
#import "CSNormalCourseDetailViewController.h"
#import "CSConfig.h"
#import "CSProjectDefault.H"


@interface CSRequiredViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) SMBaseTableView *courseTable;
@property (nonatomic, strong) NSMutableArray *courses;
@end

static NSString *courseCellIdentifier = @"CSCourseListTableViewCell";

@implementation CSRequiredViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"必修课";
    self.courses = [NSMutableArray array];
    [self initUI];
    [self setupRefresh];
    // Do any additional setup after loading the view.
}

-(void)initUI{
    self.courseTable = [[SMBaseTableView alloc]initWithFrame:CGRectMake(0, 0, kCSScreenWidth, kCSScreenHeight - KNavigationHegiht) style:UITableViewStylePlain];
    self.courseTable.delegate = self;
    self.courseTable.dataSource = self;
    self.courseTable.backgroundColor = kBGColor;
    self.courseTable.tableFooterView = [[UIView alloc]initWithFrame:CGRectZero];
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
    NSNumber *projectId = [[CSProjectDefault shareProjectDefault] getProjectId];
    NSDictionary *parames = @{@"rp":@(RP),@"page":@(self.courseTable.page),@"type":@"REQUIRED",@"projectId":projectId};
    [[CSHttpRequestManager shareManager] postDataFromNetWork:GET_COURSE_LIST parameters:parames success:^(CSHttpRequestManager *manager, id model) {
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



@end
