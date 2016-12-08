//
//  CSBaseNavigationController.m
//  tencent
//
//  Created by sunon002 on 16/4/15.
//  Copyright © 2016年 cyh. All rights reserved.
//

#import "CSBaseNavigationController.h"

@interface CSBaseNavigationController ()

@end

@implementation CSBaseNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNavigationBar];
    self.navigationBar.translucent = NO;
    // Do any additional setup after loading the view.
}

/*
 **设置导航栏
 */
- (void)setNavigationBar{
//    [[UINavigationBar appearance] setTintColor:[UIColor greenColor]];
//    [[UINavigationBar appearance] setBarTintColor:[UIColor greenColor]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskPortrait;
}
-(BOOL)shouldAutorotate
{
    return [self.visibleViewController shouldAutorotate];
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
