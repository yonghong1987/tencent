//
//  CSGuideViewController.m
//  tencent
//
//  Created by cyh on 16/8/29.
//  Copyright © 2016年 cyh. All rights reserved.
//

#import "CSGuideViewController.h"
#import "CSUserDefaults.h"
#import "AppDelegate+Category.h"
@interface CSGuideViewController ()<UIScrollViewDelegate>

@end

@implementation CSGuideViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.backBtn setHidden:YES];
    [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationFade];
    [self.navigationController.navigationBar setHidden:YES];
    [[CSUserDefaults shareUserDefault] saveFirstLaunch:YES];
    self.view.backgroundColor = [UIColor whiteColor];
    [self initUI];
    // Do any additional setup after loading the view.
}

- (void)initUI{
    UIImageView* backImgV=[[UIImageView alloc] initWithFrame:self.view.bounds];
    backImgV.image=[UIImage imageNamed:@"guide_bg"];
    [self.view addSubview:backImgV];

    
    UIScrollView* scroll=[[UIScrollView alloc] initWithFrame:self.view.bounds];
    scroll.delegate=self;
    scroll.pagingEnabled=YES;
    scroll.backgroundColor=[UIColor clearColor];
    scroll.showsVerticalScrollIndicator=NO;
    scroll.contentSize=CGSizeMake(scroll.frame.size.width, scroll.frame.size.height*3);
    [self.view addSubview:scroll];
    
    for (int i=0; i<3; i++) {
        UIImageView* imgV=[[UIImageView alloc] initWithFrame:CGRectMake(0, i*scroll.frame.size.height, scroll.frame.size.width, scroll.frame.size.height)];
        imgV.image=[UIImage imageNamed:[NSString stringWithFormat:@"guide_page%d",i]];
        imgV.userInteractionEnabled=YES;
        [scroll addSubview:imgV];
        if (i==2) {
            UIButton *btn=[UIButton buttonWithType:UIButtonTypeCustom];
            btn.frame=CGRectMake((self.view.bounds.size.width-260)/2.0, self.view.bounds.size.height-55.0, 260.0, 40.0);
            [btn setImage:[UIImage imageNamed:@"guide_start"] forState:UIControlStateNormal];
            [btn setImage:[UIImage imageNamed:@"guide_start_pressed"] forState:UIControlStateHighlighted];
            [btn addTarget:self action:@selector(start:) forControlEvents:UIControlEventTouchUpInside];
            [imgV addSubview:btn];
        }
    }
}

- (void)start:(UIButton *)sender{
    [[AppDelegate sharedInstance] enterLoginVC];
}


-(NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskPortrait;
}
-(BOOL)shouldAutorotate
{
    return NO;
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
