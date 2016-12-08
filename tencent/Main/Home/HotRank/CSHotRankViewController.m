//
//  CSHotRankViewController.m
//  tencent
//
//  Created by bill on 16/4/28.
//  Copyright © 2016年 cyh. All rights reserved.
//

#import "CSHotRankViewController.h"

#import "CSMyCourseViewController.h"
#import "CSHotTagsListViewController.h"
#import "CSHotCourseListViewController.h"

#import "JQNavTabBarController.h"
#import "CSSearchCourseViewController.h"
@interface CSHotRankViewController ()


@property(nonatomic,strong) JQNavTabBarController *navTabBarController;

@end

@implementation CSHotRankViewController

#pragma mark life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self addViewControllers];
     [self.searchBtn setHidden:NO];
    
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

#pragma mark init
- (void)addViewControllers{
    
    NSMutableArray *subViewControllers = [NSMutableArray array];
    
    CSHotTagsListViewController *tagsList = [[CSHotTagsListViewController alloc] init];
    tagsList.title = @"最热标签";
    [subViewControllers addObject:tagsList];
    
    CSHotCourseListViewController *courseList = [[CSHotCourseListViewController alloc] init];
    courseList.title = @"最热课程";
    [subViewControllers addObject:courseList];
    
    
    JQNavTabBarController *naviTabBarController = [[JQNavTabBarController alloc]init];
    naviTabBarController.preferredContentSize = self.view.frame.size;
    naviTabBarController.viewControllers = subViewControllers;
    [self addChildViewController:naviTabBarController];
    [self.view addSubview:naviTabBarController.view];
}


-(void)searchAction:(UIButton *)sender{
    CSSearchCourseViewController *searchVC = [[CSSearchCourseViewController alloc]init];
    searchVC.rootVC = self;
    searchVC.searchType = CSSearchCourseType;
    self.topNav = [[CSBaseNavigationController alloc]initWithRootViewController:searchVC];
    [self.tabBarController addChildViewController:self.topNav];
    [self.tabBarController.view addSubview:self.topNav.view];
}
@end
