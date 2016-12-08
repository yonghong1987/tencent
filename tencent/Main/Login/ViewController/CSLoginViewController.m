//
//  CSLoginViewController.m
//  tencent
//
//  Created by sunon002 on 16/4/15.
//  Copyright © 2016年 cyh. All rights reserved.
//

#import "CSLoginViewController.h"
#import "UIView+SDAutoLayout.h"
#import "CSTextLengthConfig.h"
#import <CommonCrypto/CommonDigest.h>
#import "CSHttpRequestManager.h"
#import "CSUrl.h"
#import "NSDictionary+convenience.h"
#import "CSProjectModel.h"
#import "CSUserModel.h"
#import "CSProjectDefault.h"
#import "CSUserDefaults.h"
#import "CSMd5.h"
#import "AppDelegate.h"
#import "AppDelegate+Category.h"
#import "MBProgressHUD+CYH.h"
#import "SMBaseNetworkApi.h"
#import "CSDeviceType.h"
@interface CSLoginViewController ()

@end

@implementation CSLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"登录";
    // Do any additional setup after loading the view from its nib.
}

- (void)initUI{
    self.userNameTF.sd_layout
    .topSpaceToView(self.view,80)
    .leftSpaceToView(self.view,40)
    .rightSpaceToView(self.view,40)
    .heightIs(40);
    
    self.passwordTF.sd_layout
    .topSpaceToView(self.userNameTF,20)
    .leftEqualToView(self.userNameTF)
    .rightEqualToView(self.userNameTF)
    .heightIs(self.userNameTF.height);
    
    self.loginBtn.sd_layout
    .topSpaceToView(self.passwordTF,20)
    .leftEqualToView(self.userNameTF)
    .widthIs(self.userNameTF.width)
    .heightIs(50);
    
}


#pragma mark loginAction
- (IBAction)loginAction:(id)sender {
    [self judgeUserAndPassword];
    // 获取设备信息
    
    UIDevice *device=[[UIDevice alloc] init];
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters setValue:self.userNameTF.text forKey:@"employeeNumber"];
    [parameters setValue:[CSMd5 md5HexDigest:self.passwordTF.text] forKey:@"password"];
    [parameters setValue:device.identifierForVendor.UUIDString forKey:@"identification"];
    [parameters setValue:device.systemName forKey:@"system"];
    [parameters setValue:device.systemVersion forKey:@"version"];
    [parameters setValue:device.name forKey:@"models"];
//     [parameters setValue:[CSDeviceType platform] forKey:@"models"];
    [parameters setValue:device.model forKey:@"brand"];
    
    [[CSHttpRequestManager shareManager] postDataFromNetWork:URL_USER_LOGIN parameters:parameters success:^(CSHttpRequestManager *manager, id model) {
        if ([[model objectForKey:@"code"] integerValue] == 0) {
            NSString *token = [model stringForKey:@"token"];
            NSMutableArray *projectList = [[NSMutableArray alloc] init];
            NSArray *arrCamp = [model arrayForKey:@"projectList"];
            //解析出项目信息
            if (arrCamp.count > 0) {
                for (NSDictionary *projectDic in arrCamp) {
                    CSProjectModel *projectModel = [[CSProjectModel alloc]initWithDictionary:projectDic error:nil];
                    [projectList addObject:projectModel];
                }
                //保存第一个项目
                CSProjectModel *projectModel = [projectList objectAtIndex:0];
                [[CSProjectDefault shareProjectDefault] saveProjectId:projectModel.projectId];
                [[CSProjectDefault shareProjectDefault] saveProjectName:projectModel.appName];
                [[CSProjectDefault shareProjectDefault] saveProjectTotal:[NSString stringWithFormat:@"%ld",arrCamp.count]];
            }
            //解析出用户信息
            NSDictionary *userDic = [model dictForKey:@"user"];
            CSUserModel *userModel = [[CSUserModel alloc] initWithDictionary:userDic error:nil];
            [[CSUserDefaults shareUserDefault]saveUserToken:token];
            [[CSUserDefaults shareUserDefault]saveUserName:self.userNameTF.text];
            [[CSUserDefaults shareUserDefault]saveUser:userModel];
            //保存登陆状态
            [[CSUserDefaults shareUserDefault]saveLoginSuccessStatus:YES];
            [[AppDelegate sharedInstance] enterWhichVC];
        }

    } failture:^(CSHttpRequestManager *manager, id nodel) {
        
    }];
}

#pragma 判断输入的账号与密码是否符合规则
-(void)judgeUserAndPassword{
    if (self.userNameTF.text.length < kUserNameAndPasswordMinLength || self.userNameTF.text.length > kUserNameAndPasswordMaxLength) {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"请输入有效用户名。" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
        return;
    }
    if (self.passwordTF.text.length < kUserNameAndPasswordMinLength || self.passwordTF.text.length > kUserNameAndPasswordMaxLength) {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"请输入有效密码。" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
        return;
    }

}
-(void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    [self initUI];
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
