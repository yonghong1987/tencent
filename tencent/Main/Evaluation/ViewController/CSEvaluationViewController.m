//
//  CSEvaluationViewController.m
//  tencent
//
//  Created by sunon002 on 16/4/16.
//  Copyright © 2016年 cyh. All rights reserved.
//

#import "CSEvaluationViewController.h"
#import "CSStudyMapViewController.h"
#import "CSStudyCaseViewController.h"
#import "CSPracticeSkillViewController.h"
#import "JQNavTabBarController.h"
@interface CSEvaluationViewController ()
/**
 *  控制器数组
 */
@property (nonatomic, strong) NSMutableArray *subViewControllers;
@property (nonatomic, strong) CSStudyCaseViewController *studyCaseVC;
@property (nonatomic, strong) CSPracticeSkillViewController *practiceSkillVC;
@property (nonatomic, strong) CSStudyMapViewController *studyMapVC;
@end

@implementation CSEvaluationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.backBtn setHidden:YES];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.subViewControllers = [NSMutableArray array];
    [self addViewControllers];
    // Do any additional setup after loading the view from its nib.
}

- (void)changedProjectItem{
    [self.studyCaseVC changedProjectMenuItem];
    [self.practiceSkillVC changedProjectMenuItem];
    [self.studyMapVC changedProjectMenuItem];
}
/**
 *  添加NavTabBar
 */
- (void)addViewControllers{
   JQNavTabBarController *naviTabBarController = [[JQNavTabBarController alloc]init];
    naviTabBarController.preferredContentSize = CGSizeMake(self.view.frame.size.width, self.view.frame.size.height);
    self.studyCaseVC = [[CSStudyCaseViewController alloc] init];
    self.studyCaseVC.title = @"学案例";
    [self.subViewControllers addObject:self.studyCaseVC];
    
    self.practiceSkillVC = [[CSPracticeSkillViewController alloc] init];
    self.practiceSkillVC.title = @"练身手";
    [self.subViewControllers addObject:self.practiceSkillVC];
    
    self.studyMapVC = [[CSStudyMapViewController alloc] init];
    self.studyMapVC.title = @"学习地图";
    [self.subViewControllers addObject:self.studyMapVC];
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
