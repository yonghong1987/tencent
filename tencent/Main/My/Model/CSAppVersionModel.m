//
//  CSAppVersionModel.m
//  tencent
//
//  Created by bill on 16/8/5.
//  Copyright © 2016年 cyh. All rights reserved.
//

#import "CSAppVersionModel.h"
#import "MBProgressHUD+CYH.h"
#import "CSHttpRequestManager.h"
#import "CSUrl.h"

#define UPDATETAG 1000
@implementation CSAppVersionModel


+ (CSAppVersionModel *)shareInstance{

    static CSAppVersionModel *shareInstance = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if ( !shareInstance ) {
            shareInstance = [CSAppVersionModel new];
        }
    });
    return shareInstance;
}

- (void)checkVersion:(UIView *)currentView ShowTip:(BOOL)needShow{
    [MBProgressHUD showMessage:@"加载中..." toView:currentView];
    
    NSDictionary *params = @{@"type":@"IOS"};
    __block BOOL showMsg = needShow;
    [[CSHttpRequestManager shareManager] postDataFromNetWork:URL_CHECK_VERSION parameters:params success:^(CSHttpRequestManager *manager, id model) {
        [MBProgressHUD hideHUDForView:currentView];
        
        CSAppVersionModel *appVersion = [[CSAppVersionModel shareInstance] initWithDictionary:[model objectForKey:@"apkversion"] error:nil];
   
        NSString *msg = @"";
        NSInteger tag = 0;
        NSComparisonResult result = [self compareVersion];
        if ( result == NSOrderedDescending ) {
            showMsg = YES;
            msg = appVersion.message;
            tag = UPDATETAG;
        }else{
            msg = @"当前为最新版本";
        }
        if( showMsg ){
            [self alertMsg:msg AlertTag:tag];
        }
        
    }failture:^(CSHttpRequestManager *manager, id nodel) {
        ;
    }];
}

- (NSComparisonResult)compareVersion{

    NSString *localVersion = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    
    CSAppVersionModel *appVersion = [CSAppVersionModel shareInstance];
    return [appVersion.code compare:localVersion];
}

- (void)alertMsg:(NSString *)msg AlertTag:(NSInteger)alertTag{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"温馨提示"
                                                    message:msg
                                                   delegate:self
                                          cancelButtonTitle:@"取消"
                                          otherButtonTitles:@"确定", nil];
    alert.tag = alertTag;
    [alert show];
}


- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if ( alertView.tag == UPDATETAG && buttonIndex == 1 ) {
        [self updateVersion];
    }
}

- (void)updateVersion
{
    CSAppVersionModel *appVersion = [CSAppVersionModel shareInstance];
    if ( appVersion.url.length > 0 ) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:appVersion.url]];
    }else{
        [self alertMsg:@"无效的安装包地址" AlertTag:0];
    }
}

@end
