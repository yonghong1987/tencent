//
//  CSTagCourseViewController.m
//  tencent
//
//  Created by cyh on 16/11/24.
//  Copyright © 2016年 cyh. All rights reserved.
//

#import "CSTagCourseViewController.h"
#import "SMBaseTableView.h"
#import "CSFrameConfig.h"
#import "CSColorConfig.h"
#import "CSCourseListTableViewCell.h"
#import "CSHttpRequestManager.h"
#import "CSConfig.h"
#import "CSUrl.h"
#import "CSCourseListModel.h"
#import "CSProjectDefault.h"
#import "UIImageView+WebCache.h"
#import "CSNormalCourseDetailViewController.h"
@interface CSTagCourseViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) SMBaseTableView *courseTable;
@property (nonatomic, strong) NSMutableArray *courses;

@end

@implementation CSTagCourseViewController
static NSString *courseCellIdentifier = @"CSCourseListTableViewCell";
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"最热标签";
    self.courses = [NSMutableArray array];
    [self setupRefresh];
    // Do any additional setup after loading the view.
}

-(SMBaseTableView *)courseTable{
    if (!_courseTable) {
        _courseTable = [[SMBaseTableView alloc]initWithFrame:CGRectMake(0, 0, kCSScreenWidth, kCSScreenHeight - KNavigationHegiht +kCSTableViewTopPadding) style:UITableViewStyleGrouped];
        _courseTable.delegate = self;
        _courseTable.dataSource = self;
        _courseTable.showsVerticalScrollIndicator = NO;
        _courseTable.backgroundColor = kBGColor;
        _courseTable.tableFooterView = [[UIView alloc]initWithFrame:CGRectZero];
        _courseTable.rowHeight = 80.0;
        [self.view addSubview:_courseTable];
        [_courseTable registerNib:[UINib nibWithNibName:NSStringFromClass([CSCourseListTableViewCell class]) bundle:nil] forCellReuseIdentifier:courseCellIdentifier];
        UIImageView *headIV = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, kCSScreenWidth, 160)];
        [headIV sd_setImageWithURL:[NSURL URLWithString:self.tagList.img] placeholderImage:nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            
        }];
        _courseTable.tableHeaderView = headIV;
    }
    return _courseTable;
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
    NSDictionary *parames = @{@"rp":@(RP),@"page":@(self.courseTable.page),@"projectid":[[CSProjectDefault shareProjectDefault] getProjectId],@"specialId":self.tagList.specialId};
    [[CSHttpRequestManager shareManager] postDataFromNetWork:TAG_COURSE parameters:parames success:^(CSHttpRequestManager *manager, id model) {
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
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    [cell setCourseCell:self.courses[indexPath.row]];
    return cell;
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    CSCourseListModel *model = self.courses[indexPath.row];
    CSNormalCourseDetailViewController *detailVC = [[CSNormalCourseDetailViewController alloc] initWithCourseId:model.courseId
                                                                                                    CoureseName:model.name];
    detailVC.praiseCount = [model.praiseCount integerValue];
    detailVC.changePraiseType =  CSChangeePraiseCountType;
    detailVC.passBrowse = ^(NSInteger count,NSInteger praiseCount){
        NSInteger viewAmount = [model.viewAmount integerValue] + count;
        model.viewAmount = [NSNumber numberWithInteger:viewAmount];
        model.praiseCount = [NSNumber numberWithInteger:praiseCount];
        NSIndexPath *clickIndexPath = [NSIndexPath indexPathForRow:indexPath.row inSection:0];
        [tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:clickIndexPath, nil] withRowAnimation:UITableViewRowAnimationAutomatic];
    };

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
