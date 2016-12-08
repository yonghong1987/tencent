//
//  CSViewController.m
//  eLearning
//
//  Created by sunon002 on 14-7-17.
//  Copyright (c) 2014年 sunon. All rights reserved.
//

#import "CSViewController.h"

@interface CSViewController ()

@end

@implementation CSViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"nav_back.png"] style:UIBarButtonItemStylePlain target:self action:@selector(navBack:)];
    
//    if(IOS7_OR_LATER) {
        self.automaticallyAdjustsScrollViewInsets = NO;
//    }
    self.view.backgroundColor = [UIColor whiteColor];
}

- (void)navBack:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)removeFromSuper
{
    [self.topNav removeFromParentViewController];
    [_topNav.view removeFromSuperview];
    self.topNav=nil;
}


-(void)showPromptHUD:(NSString *)str
{
//    if(str.length>0){
//        [MBPHUDHelper showMessageWithView:self.view message:str yOffset:0 andDelay:1.0];
//    }else{
//        NSLog(@"=======showPromptHUD str is nil");
//    }
    
}
@end
