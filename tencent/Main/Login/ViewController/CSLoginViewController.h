//
//  CSLoginViewController.h
//  tencent
//
//  Created by sunon002 on 16/4/15.
//  Copyright © 2016年 cyh. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CSLoginViewController : UIViewController
/*
 ***用户名输入框
 */
@property (weak, nonatomic) IBOutlet UITextField *userNameTF;
/*
 **密码输入框
 */
@property (weak, nonatomic) IBOutlet UITextField *passwordTF;
/*
 **登录按钮
 */
@property (weak, nonatomic) IBOutlet UIButton *loginBtn;

@end
