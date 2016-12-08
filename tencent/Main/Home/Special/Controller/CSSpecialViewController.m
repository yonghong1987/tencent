//
//  CSSpecialViewController.m
//  tencent
//
//  Created by admin on 16/5/3.
//  Copyright © 2016年 cyh. All rights reserved.
//

#import "CSSpecialViewController.h"
#import "CSUrl.h"
#import "CSHttpRequestManager.h"
#import "CSUserDefaults.h"
#import "CSProjectDefault.h"
#import "CSSpecialParentModel.h"
#import "CSSpecialMenuListViewController.h"
#import "CSSpecialMenuModel.h"
#import "JQNavTabBarController.h"
#import "CSSearchCourseViewController.h"
#import "CSFrameConfig.h"

@interface CSSpecialViewController ()
@property (nonatomic, strong) NSMutableArray *specialMenus;//专题目录列表
@property (nonatomic, strong) NSMutableArray *viewControllers;//控制器数组

@end

@implementation CSSpecialViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadData];
    [self.searchBtn setHidden:NO];
    // Do any additional setup after loading the view.
}

#pragma mark controlInit
- (void)loadData{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters setValue:[NSString stringWithFormat:@"%d",[[[CSProjectDefault shareProjectDefault] getProjectId] intValue]] forKey:@"projectId"];
    [parameters setValue:@(2) forKey:@"ctype"];
    [[CSHttpRequestManager shareManager] postDataFromNetWork:GET_SPECIAL_MENU parameters:parameters success:^(CSHttpRequestManager *manager, id model) {
        self.specialMenus = [NSMutableArray array];
        self.viewControllers = [NSMutableArray array];
        NSArray *array = model[@"catalogList"];
        for (NSDictionary *menuDic in array) {
             CSSpecialMenuModel *special = [[CSSpecialMenuModel alloc] initWithDictionary:menuDic error:nil];
            [self.specialMenus addObject:special];
        }
        JQNavTabBarController *naviTabBarController = [[JQNavTabBarController alloc]init];
        naviTabBarController.preferredContentSize = CGSizeMake(self.view.frame.size.width, self.view.frame.size.height);
        for (CSSpecialMenuModel* specialMenu in self.specialMenus) {
            CSSpecialMenuListViewController *specialListVC = [[CSSpecialMenuListViewController alloc] init];
            specialListVC.title = specialMenu.name;
            specialListVC.specialMenuid = specialMenu.catalogId;
            [self.viewControllers addObject:specialListVC];
        }
        naviTabBarController.viewControllers = self.viewControllers;
        [self addChildViewController:naviTabBarController];
        [self.view addSubview:naviTabBarController.view];
    } failture:^(CSHttpRequestManager *manager, id nodel) {
        
    }];
}

-(void)searchAction:(UIButton *)sender{
    CSSearchCourseViewController *searchVC = [[CSSearchCourseViewController alloc]init];
    searchVC.rootVC = self;
    searchVC.searchType = CSSearchSpecialType;
    self.topNav = [[CSBaseNavigationController alloc]initWithRootViewController:searchVC];
    [self.tabBarController addChildViewController:self.topNav];
    [self.tabBarController.view addSubview:self.topNav.view];
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
