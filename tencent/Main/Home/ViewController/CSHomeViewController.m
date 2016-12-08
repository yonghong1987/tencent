//
//  CSHomeViewController.m
//  tencent
//
//  Created by sunon002 on 16/4/16.
//  Copyright © 2016年 cyh. All rights reserved.
//

#import "CSHomeViewController.h"
#import "JQBannerView.h"
#import "CSFrameConfig.h"
#import "CSHttpRequestManager.h"
#import "CSUserDefaults.h"
#import "CSProjectDefault.h"
#import "CSUrl.h"
#import "CSBannerModel.h"
#import "CSProjectModel.h"
#import "CSCourseModel.h"
#import "CSHomeMenuTableCell.h"
#import "CSColorConfig.h"
#import "CSHomeCourseCell.h"
#import "MJRefresh.h"
#import "CSNormalCourseDetailViewController.h"
#import "MBProgressHUD+CYH.h"
#import "CSAppVersionModel.h"
#import "CSRequiredViewController.h"
#import "UIBarButtonItem+Common.h"
#import "CSConfig.h"
#import "UIColor+HEX.h"
#import "NSDictionary+convenience.h"
#import "CSAppWakeUpManager.h"
#import "NSString+convenience.h"
#import "CSGlobalMacro.h"
#import "CSForumDetailViewController.h"
#import "CSStudyCaseDetailViewController.h"
#import "CSSpecialDetailViewController.h"
#import "CSMapCheckPointViewController.h"
#import "CSStudyMapModel.h"
#import "CSExamContentViewController.h"
@interface CSHomeViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) UITableView *homeTable;
/*
 **图片轮播视图
 */
@property (nonatomic, strong) JQBannerView *bannerView;
/*
 **课程数组
 */
@property (nonatomic, strong) NSMutableArray *courseArray;
@property (nonatomic, strong) CSProjectModel *project;
/*
 **是否已经有banner图片数组
 */
@property (nonatomic, assign) BOOL isHasBannerArr;

/**
 *banner数组
 */
@property (nonatomic, strong) NSMutableArray *banners;
@property (nonatomic, assign) NSInteger seminarTotal;
@property (nonatomic, assign) NSInteger knowLedgeTotal;
@end

@implementation CSHomeViewController

static NSString *const kMenuCell = @"SMHomeMenuTableCell";
static NSString *const kCourseCell = @"SMHomeCourseTableCell";

- (void)viewDidLoad {
    [super viewDidLoad];
    self.isHasBannerArr = NO;
    self.banners = [NSMutableArray array];
    [self.backBtn setHidden:YES];
    //检查版本是否要更新
    [[CSAppVersionModel shareInstance] checkVersion:self.view ShowTip:NO];

    [self loadData];
    [self setupRefresh];
    
    NSDictionary *dic = [NSDictionary dictionary];
    CSAppWakeUpManager *wakeup = [[CSAppWakeUpManager alloc]init];
    [wakeup controllerMediator:dic];
}


- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if( self.changeProject ){
        [self changedProjectItem];
    }
}

- (void)changedProjectItem{
    [self.bannerView removeFromSuperview];
    [self loadData];
}

#pragma mark controlInit
-(UITableView *)homeTable{
    if (!_homeTable) {
        _homeTable  = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, kCSScreenWidth, kCSScreenHeight - KNavigationHegiht - 49.0) style:UITableViewStylePlain];
        _homeTable.delegate = self;
        _homeTable.dataSource =self;
       _homeTable.backgroundColor = kBGColor;
        _homeTable.separatorStyle = UITableViewCellSeparatorStyleNone;
        [self.view addSubview:_homeTable];
        [_homeTable registerClass:[CSHomeMenuTableCell class] forCellReuseIdentifier:kMenuCell];
        [_homeTable registerClass:[CSHomeCourseCell class] forCellReuseIdentifier:kCourseCell];
    }
    return _homeTable;
}

- (void)addRightBtnWithBadgeCount:(NSInteger)Badgecount{
    WS(weakSelf);
    UIBarButtonItem *right = [UIBarButtonItem itemWithIcon:@"icon_file_white" highlightedIcon:@"icon_file_white" showBadge:YES count:Badgecount actionBolock:^(UIBarButtonItem *item) {
        [weakSelf gotoRequiredVC];
    }];
    self.navigationItem.rightBarButtonItem =  right;
}

-(void)addBannerView{
    _bannerView = [[JQBannerView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, kCSBannerHeight)];
    WS(weakSelf);
    [_bannerView setDidSelectItemAtIndex:^(NSUInteger index) {
        if (index == weakSelf.banners.count) {
            index -= 1 ;
        }
        CSBannerModel *bannerModel = weakSelf.banners[index];
        NSString *url = [bannerModel.url RemoveleftRightBlank];
        if ([url rangeOfString:OpenURLCompare].location!=NSNotFound) {
            NSString * subStr = [url substringFromIndex:OpenURLCompare.length];
            NSArray  * arrParam =[subStr componentsSeparatedByString:@"&"];
            NSMutableDictionary * dicParam = [[NSMutableDictionary alloc] initWithCapacity:arrParam.count];
            for(NSString *param in arrParam) {
                NSMutableArray *oneParam = (NSMutableArray *)[param componentsSeparatedByString:@"="];
                if([oneParam containsObject:@""])
                    [oneParam removeObject:@""];
                [dicParam setValue:[oneParam lastObject] forKey:[oneParam firstObject]];
            }
            NSString *typeValue = [dicParam stringForKey:OpenURLType];
            //跳转到课程详情
            if ([typeValue isEqualToString:URLParamOnline]) {
                NSInteger courseId = [dicParam integerForKey:OpenURLCourseId];
                CSNormalCourseDetailViewController *normalCource = [[CSNormalCourseDetailViewController alloc]initWithCourseId:[NSNumber numberWithInteger:courseId] CoureseName:nil];
                normalCource.hidesBottomBarWhenPushed = YES;
                [weakSelf.navigationController pushViewController:normalCource animated:YES];
                //跳转到考试
            }
            else if ([typeValue isEqualToString:URLParamExam]){
                
                CSExamContentViewController *examVC = [[CSExamContentViewController alloc]init];
                examVC.examActivityId = [NSNumber numberWithInteger:[dicParam integerForKey:OpenURLActivityId]];
                examVC.hidesBottomBarWhenPushed = YES;
                [weakSelf.navigationController pushViewController:examVC animated:YES];
                //跳转到帖子详情
            }else if ([typeValue isEqualToString:URLParamForum]){
                NSInteger forumId = [dicParam integerForKey:OpenURLForumId];
                CSForumDetailViewController *forumDetail = [[CSForumDetailViewController alloc]init];
                forumDetail.forumId = [NSNumber numberWithInteger:forumId];
                forumDetail.hidesBottomBarWhenPushed = YES;
                [weakSelf.navigationController pushViewController:forumDetail animated:YES];
                //跳转到案列详情
            }else if ([typeValue isEqualToString:URLParamCase]){
                NSInteger caseId = [dicParam integerForKey:OpenURLCaseId];
                CSStudyCaseDetailViewController *studyCase = [[CSStudyCaseDetailViewController alloc]init];
                studyCase.caseId = [NSNumber numberWithInteger:caseId];
                studyCase.hidesBottomBarWhenPushed = YES;
                [weakSelf.navigationController pushViewController:studyCase animated:YES];
                //跳转到专题详情
            }else if ([typeValue isEqualToString:URLParamTopic]){
                NSInteger courseId = [dicParam integerForKey:OpenURLCourseId];
                CSSpecialDetailViewController *specialDetail = [[CSSpecialDetailViewController alloc]init];
                specialDetail.specialid = [NSNumber numberWithInteger:courseId];
                specialDetail.hidesBottomBarWhenPushed = YES;
                [weakSelf.navigationController pushViewController:specialDetail animated:YES];
                //跳转到学习地图
            }else if ([typeValue isEqualToString:URLParamMap]){
                NSInteger courseId = [dicParam integerForKey:OpenURLMapId];
                CSMapCheckPointViewController *mapVC = [[CSMapCheckPointViewController alloc]init];
                CSStudyMapModel *mapModel = [[CSStudyMapModel alloc]init];
                mapModel.mappId = [NSNumber numberWithInteger:courseId];
                mapVC.mapModel = mapModel;
                mapVC.hidesBottomBarWhenPushed = YES;
                [weakSelf.navigationController pushViewController:mapVC animated:YES];
            }
        }
    }];
    _bannerView.currentPageIndicatorTintColor = [UIColor redColor];
}

#pragma mark loadData
- (void)loadData{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    NSNumber *projectId = [[CSProjectDefault shareProjectDefault] getProjectId];
    [parameters setValue:projectId  forKey:@"projectId"];
    [MBProgressHUD showMessage:@"加载中..." toView:self.view];
    [[CSHttpRequestManager shareManager] postDataFromNetWork:GET_PROJECT_LIST parameters:parameters success:^(CSHttpRequestManager *manager, id model) {
        self.changeProject = NO;
        [MBProgressHUD hideHUDForView:self.view];
        [self endRefresh];
        [self addBannerView];
        _homeTable.tableHeaderView = self.bannerView;
        NSArray *bans = model[@"bannerList"];
 
        [self.banners removeAllObjects];
       NSMutableArray *bannerImgs = [NSMutableArray array];
        for (NSDictionary *bannerDic in bans) {
            CSBannerModel *banner = [[CSBannerModel alloc]initWithDictionary:bannerDic error:nil];
            [self.banners addObject:banner];
            NSString *imageUrl = banner.img;
            [bannerImgs addObject:imageUrl];
        }
        
        self.bannerView.bannerArray = bannerImgs;
//        if (self.bannerView.bannerArray.count > 0) {
             self.isHasBannerArr = YES;
//        }
        
        NSArray *courses = model[@"recommendCourseList"];
        self.courseArray = [NSMutableArray array];
        for (NSDictionary *courseDic in courses) {
            CSCourseModel *course = [[CSCourseModel alloc]initWithDictionary:courseDic error:nil];
            [self.courseArray addObject:course];
        }
        
        if (self.isHasBannerArr == YES) {
            [self.homeTable reloadData];
        }
        //必修课角标
        NSInteger badgeCount = [[model numberForKey:@"requiredCourseTotal"] integerValue];
        if (badgeCount > 0) {
             [self addRightBtnWithBadgeCount:(NSInteger)badgeCount];
        }
        //帖子角标
        NSInteger forumBadgeCount = [[model numberForKey:@"forumReplyTotal"] integerValue];
        //评论角标
        NSInteger commentBadgeCount = [[model numberForKey:@"commentReplyTotal"] integerValue];
        NSInteger totalCount = forumBadgeCount + commentBadgeCount;
        self.seminarTotal = [[model numberForKey:@"seminarTotal"] integerValue];
        self.knowLedgeTotal = [[model numberForKey:@"seminarTotal"] integerValue];
        if (totalCount > 0) {
            UITabBarItem * commentItem=[self.tabBarController.tabBar.items objectAtIndex:3];
            commentItem.badgeValue=[NSString stringWithFormat:@"%d",totalCount];
        }
        NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
        [ud setValue:[NSString stringWithFormat:@"%d",forumBadgeCount] forKey:@"forumBadgeCount"];
        [ud setValue:[NSString stringWithFormat:@"%d",commentBadgeCount] forKey:@"commentBadgeCount"];
        [ud synchronize];
       //将评论数与帖子数传递到我的界面
        [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationCommentCountAndForumCount object:self userInfo:@{@"commentCount":[NSString stringWithFormat:@"%d",commentBadgeCount],@"forumCount":[NSString stringWithFormat:@"%d",forumBadgeCount]}];
    } failture:^(CSHttpRequestManager *manager, id nodel) {
        [MBProgressHUD hideHUDForView:self.view];
        [self endRefresh];
    }];
}

#pragma mark UITableViewDelegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 3;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if (self.isHasBannerArr == YES) {
        if (section == 0) {
            return 1;
        }else if (section == 1){
            return 1;
        }else if (section == 2){
            return self.courseArray.count;
            
        }
    }
    return 0;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.isHasBannerArr == YES) {
        if (indexPath.section == 0) {
            CSHomeMenuTableCell *cell = [tableView dequeueReusableCellWithIdentifier:kMenuCell];
            cell.backgroundColor = CSColorFromRGB(235.0, 235.0, 235.0);
            cell.seminarTotal = self.seminarTotal;
            cell.knowLedgeTotal = self.knowLedgeTotal;
            cell.model = nil;
            return cell;
        }else if (indexPath.section == 1){
            CSHomeCourseCell *cell = [tableView dequeueReusableCellWithIdentifier:kCourseCell];
            if (!cell) {
                cell = [[CSHomeCourseCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kCourseCell];
            }
            cell.backgroundColor = CSColorFromRGB(235.0, 235.0, 235.0);
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.titleLabel.text = @"    最近更新";
            cell.titleLabel.textColor = CSColorFromRGB(153.0, 153.0, 153.0);
            cell.titleLabel.font = [UIFont systemFontOfSize:13.0];
            return cell;
        }else if (indexPath.section == 2){
            CSHomeCourseCell *cell = [tableView dequeueReusableCellWithIdentifier:kCourseCell];
            cell.backgroundColor = CSColorFromRGB(235.0, 235.0, 235.0);
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            CSCourseModel *course = self.courseArray[indexPath.row];
            cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
            cell.titleLabel.text = [NSString stringWithFormat:@"    %@",course.name];
            cell.titleLabel.font = [UIFont systemFontOfSize:16.0];
            cell.titleLabel.textColor = [[UIColor blackColor]colorWithAlphaComponent:0.7];
            return cell;
        }

    }
        return 0;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 2) {
        
        CSCourseModel *course = self.courseArray[indexPath.row];
        NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
        
        CSNormalCourseDetailViewController *courseDetailVC = [[CSNormalCourseDetailViewController alloc] initWithCourseId:[formatter numberFromString:course.courseId]
                                                                                                        CoureseName:course.name];
        courseDetailVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:courseDetailVC animated:YES];
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    CGFloat height = 0;
    if (indexPath.section == 0) {
        height = (kCSScreenWidth-40)/3 + 10;
    }else if (indexPath.section == 1 || indexPath.section == 2){
        height = 40;
    }
    return height;
}

-(void)gotoRequiredVC{
    
    CSRequiredViewController *requiredVC = [[CSRequiredViewController alloc]init];
    requiredVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:requiredVC animated:YES];
}
- (void)setupRefresh{
    self.homeTable.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self loadData];
    }];
    
}

- (void)endRefresh{
    [self.homeTable.mj_header endRefreshing];
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
