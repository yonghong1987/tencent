//
//  CSViewController.h
//  eLearning
//
//  Created by sunon002 on 14-7-17.
//  Copyright (c) 2014年 sunon. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CSViewController : UIViewController

@property(nonatomic,strong)UINavigationController* topNav;
-(void)removeFromSuper;
-(void)showPromptHUD:(NSString *)str;
@end
