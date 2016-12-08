//
//  CSBaseViewController.m
//  tencent
//
//  Created by sunon002 on 16/4/16.
//  Copyright © 2016年 cyh. All rights reserved.
//

#import "CSBaseViewController.h"
#import "CSFrameConfig.h"
#import "CSColorConfig.h"
#import "CSNotificationConfig.h"

@interface CSBaseViewController ()

@end

@implementation CSBaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = kBGColor;
    self.navigationController.navigationBar.titleTextAttributes = @{UITextAttributeTextColor:[UIColor whiteColor]};
    [self addBackBtn];
    [self addSearchBtn];
    [self.searchBtn setHidden:YES];
    [self setNaviBarColor];
     // Do any additional setup after loading the view.
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(didChangeProject)
                                                 name:kChangeProjectNotifycation
                                               object:nil];
}


- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)didChangeProject{
    self.changeProject = YES;
}

- (void)setNaviBarColor{
    self.navigationController.navigationBar.barTintColor = CSColorFromRGB(70.0, 188.0, 98.0);
}

- (void)addBackBtn{
    self.backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.backBtn.frame = CGRectMake(0, 20, 40, 40);
    
    [self.backBtn setImageEdgeInsets:UIEdgeInsetsMake(0, -30, 0, 0)];
    [self.backBtn setImage:[UIImage imageNamed:@"icon_back_white"] forState:UIControlStateNormal];
    [self.backBtn addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *back = [[UIBarButtonItem alloc]initWithCustomView:self.backBtn];
    self.navigationItem.leftBarButtonItem = back;
}

-(void)backAction{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)addSearchBtn{
    self.searchBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    self.searchBtn.backgroundColor = [[UIColor redColor] colorWithAlphaComponent:0.2];
    self.searchBtn.frame = CGRectMake(kCSScreenWidth - 40, 20, 40, 40);
    [self.searchBtn setImage:[UIImage imageNamed:@"icon_search_white"] forState:UIControlStateNormal];
    [self.searchBtn setImageEdgeInsets:UIEdgeInsetsMake(0, 20, 0, 0)];
    [self.searchBtn addTarget:self action:@selector(searchAction:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightBtn = [[UIBarButtonItem alloc]initWithCustomView:self.searchBtn];
    self.navigationItem.rightBarButtonItem = rightBtn;
}

-(void)removeFromSuper
{
    [self.topNav removeFromParentViewController];
    [_topNav.view removeFromSuperview];
    self.topNav=nil;
}

-(void)searchAction:(UIButton *)sender{

}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    [self.view endEditing:YES];
    
}

//-(NSUInteger)supportedInterfaceOrientations{
//    return UIInterfaceOrientationMaskLandscape;
//}
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
