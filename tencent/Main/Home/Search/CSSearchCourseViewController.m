//
//  CSSearchCourseViewController.m
//  tencent
//
//  Created by cyh on 16/10/27.
//  Copyright © 2016年 cyh. All rights reserved.
//

#import "CSSearchCourseViewController.h"
#import "CSColorConfig.h"
#import "CSFrameConfig.h"
#import "CSSearchResultViewController.h"
#import "SMBaseTableView.h"
#import "CSProjectDefault.h"
#import "CSHttpRequestManager.h"
#import "CSUrl.h"
#import "CSConfig.h"
#import "CSCourseListModel.h"
#import "CSCourseListTableViewCell.h"
#import "MJRefresh.h"
#import "CSNormalCourseDetailViewController.h"
@interface CSSearchCourseViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic, strong) SMBaseTableView *resultTable;
@property (nonatomic, strong) NSMutableArray *courseArr;
@end

@implementation CSSearchCourseViewController
static NSString *courseCellIdentifier = @"CSCourseListTableViewCell";
-(void)viewDidLoad{
    [super viewDidLoad];
    self.courseArr = [NSMutableArray array];
    [self.backBtn setHidden:YES];
    //搜索框
    self.searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(20, 0, kCSScreenWidth - 20, 44)];
    self.searchBar.delegate = self;
    self.searchBar.barStyle = UISearchBarStyleDefault;
    self.searchBar.showsCancelButton = YES;
    if ([self.searchBar respondsToSelector:@selector(setBarTintColor:)]) {
        [self.searchBar setBarTintColor:kCSThemeColor];
    }else{
        [[self.searchBar.subviews objectAtIndex:0]removeFromSuperview];
    }
    [self.searchBar becomeFirstResponder];
    [self.navigationController.navigationBar addSubview:self.searchBar];
    [self initResultTable];
}

-(void)initResultTable{
    self.resultTable = [[SMBaseTableView alloc]initWithFrame:self.view.bounds];
    self.resultTable.delegate = self;
    self.resultTable.dataSource = self;
    self.resultTable.rowHeight = 80.0;
    [self.view addSubview:self.resultTable];
    [self.resultTable setHidden:YES];
      [self.resultTable registerNib:[UINib nibWithNibName:NSStringFromClass([CSCourseListTableViewCell class]) bundle:nil] forCellReuseIdentifier:courseCellIdentifier];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.courseArr.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    CSCourseListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:courseCellIdentifier];
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    [cell setCourseCell:self.courseArr[indexPath.row]];

    return cell;
}
- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar{
    [self.rootVC removeFromSuper];
}

-(void)searchBarTextDidBeginEditing:(UISearchBar*)searchBar{
    [searchBar setShowsCancelButton:YES animated:YES];
    UIButton *btn=[searchBar valueForKey:@"_cancelButton"];
    [btn setTitle:@"取消" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
}

#pragma mark-UISearchBarDelegate
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    [self.searchBar resignFirstResponder];
    [self.searchBar removeFromSuperview];
    self.searchWord = searchBar.text;
    UILabel *titleLb = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 60, 30)];
    titleLb.text = @"搜索结果";
    titleLb.textColor = [UIColor whiteColor];
    titleLb.backgroundColor=[UIColor clearColor];
    self.navigationItem.titleView = titleLb;
    
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    backBtn.frame = CGRectMake(20, 20, 40, 40);
    [backBtn setImageEdgeInsets:UIEdgeInsetsMake(0, 15, 0, 0)];
    [backBtn setImage:[UIImage imageNamed:@"icon_back_white"] forState:UIControlStateNormal];
    [backBtn addTarget:self.rootVC action:@selector(removeFromSuper) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *back = [[UIBarButtonItem alloc]initWithCustomView:backBtn];
    self.navigationItem.leftBarButtonItem = back;
    [self.resultTable setHidden:NO];
//    [self loadData];
     [self setupRefresh];
}
- (void)setupRefresh{
    WS(weakSelf);
    [self.resultTable refreshHeaderRefresh:^{
        [weakSelf loadData];
    } withFooterRefreshingBlock:^{
        [weakSelf loadData];
    }];
    [self.resultTable beginRefreshing];
}
-(void)loadData{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [ params setObject:self.searchWord.length > 0 ? self.searchWord : @" " forKey:@"queryCondition"];
    NSNumber *projetId = [[CSProjectDefault shareProjectDefault] getProjectId];
    [params setObject:projetId forKey:@"projectId"];
    [params setObject:@(RP) forKey:@"rp"];
    [params setObject:@(self.resultTable.page) forKey:@"page"];
    NSString *searchUrl = nil;
    if (self.searchType == CSSearchRepositoryType) {
        searchUrl = GET_COURSE_LIST;
        [params setObject:@"ALL" forKey:@"type"];
    }else if (self.searchType == CSSearchCourseType){
        searchUrl = GET_COURSE_LIST;
        [params setObject:@"HOT" forKey:@"type"];
    }else if (self.searchType == CSSearchSpecialType){
        searchUrl = GET_SPECIAL_LIST;
    }
    [[CSHttpRequestManager shareManager] postDataFromNetWork:searchUrl parameters:params success:^(CSHttpRequestManager *manager, id model) {
        NSArray *courseArr = model[@"courseList"];
        NSMutableArray *arrayDada = [NSMutableArray array];
        for (NSDictionary *courseDic in courseArr) {
            CSCourseListModel *course = [[CSCourseListModel alloc]initWithDictionary:courseDic error:nil];
            [arrayDada addObject:course];
        }
        if (self.resultTable.refreshState == SMBaseTableViewRefreshStateHeader) {
            self.courseArr = arrayDada;
        }else{
            [self.courseArr addObjectsFromArray:arrayDada];
        }
        [self.resultTable endReload];
    } failture:^(CSHttpRequestManager *manager, id nodel) {
         [self.resultTable endRefreshing];
    }];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    CSCourseListModel *model = self.courseArr[indexPath.row];
    CSNormalCourseDetailViewController *detailVC = [[CSNormalCourseDetailViewController alloc] initWithCourseId:model.courseId
                                                                                                    CoureseName:model.name];
    [self.navigationController pushViewController:detailVC animated:YES];
}

@end
