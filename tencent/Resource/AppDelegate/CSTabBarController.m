//
//  CSTabBarController.m
//  tencent
//
//  Created by bill on 16/8/8.
//  Copyright © 2016年 cyh. All rights reserved.
//

#import "CSTabBarController.h"

@interface CSTabBarController ()

@end

@implementation CSTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
 }


-(UIInterfaceOrientationMask)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskPortrait;
}
-(BOOL)shouldAutorotate
{
    UIViewController *vc=self.selectedViewController;
    return [vc shouldAutorotate];
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



- (void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item{
    item.title = @"";
}


@end
