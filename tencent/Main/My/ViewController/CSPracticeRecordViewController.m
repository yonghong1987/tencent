//
//  CSPracticeRecordViewController.m
//  tencent
//
//  Created by cyh on 16/7/26.
//  Copyright © 2016年 cyh. All rights reserved.
//

#import "CSPracticeRecordViewController.h"
#import "CSMyStudyCaseViewController.h"
#import "CSMyPracticeSkillViewController.h"
#import "JQNavTabBarController.h"
@interface CSPracticeRecordViewController ()
/**
 *  控制器数组
 */
@property (nonatomic, strong) NSMutableArray *subViewControllers;
@end

@implementation CSPracticeRecordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"实战记录";
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
    CSMyStudyCaseViewController *caseVC = [[CSMyStudyCaseViewController alloc] init];
    caseVC.title = @"学案例";
    [self.subViewControllers addObject:caseVC];
    
    CSMyPracticeSkillViewController *practiceVC = [[CSMyPracticeSkillViewController alloc] init];
    practiceVC.title = @"练身手";
    [self.subViewControllers addObject:practiceVC];
    
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
