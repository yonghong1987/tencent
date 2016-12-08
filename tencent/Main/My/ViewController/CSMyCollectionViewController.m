//
//  CSMyCollectionViewController.m
//  tencent
//
//  Created by cyh on 16/7/26.
//  Copyright © 2016年 cyh. All rights reserved.
//

#import "CSMyCollectionViewController.h"
#import "CSMyCourseViewController.h"
#import "CSMySpecialViewController.h"
#import "CSMyCheckPointViewController.h"
#import "JQNavTabBarController.h"
@interface CSMyCollectionViewController ()
/**
 *  控制器数组
 */
@property (nonatomic, strong) NSMutableArray *subViewControllers;
@end

@implementation CSMyCollectionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"我的收藏";
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.subViewControllers = [NSMutableArray array];
    [self addViewControllers];

    // Do any additional setup after loading the view.
}

/**
 *  添加NavTabBar
 */
- (void)addViewControllers{
    JQNavTabBarController *naviTabBarController = [[JQNavTabBarController alloc]init];
    naviTabBarController.preferredContentSize = CGSizeMake(self.view.frame.size.width, self.view.frame.size.height);
    CSMyCourseViewController *courseVC = [[CSMyCourseViewController alloc] init];
    courseVC.title = @"课程";
    [self.subViewControllers addObject:courseVC];
    
    CSMySpecialViewController *specialVC = [[CSMySpecialViewController alloc] init];
    specialVC.title = @"专题";
    [self.subViewControllers addObject:specialVC];
    
    CSMyCheckPointViewController *checkPointVC = [[CSMyCheckPointViewController alloc] init];
    checkPointVC.title = @"关卡";
    [self.subViewControllers addObject:checkPointVC];
    naviTabBarController.viewControllers = self.subViewControllers;
    [self addChildViewController:naviTabBarController];
    [self.view addSubview:naviTabBarController.view];
    
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
