//
//  MBProgressHUD+CYH.m
//  tencent
//
//  Created by sunon002 on 16/4/22.
//  Copyright © 2016年 cyh. All rights reserved.
//

#import "MBProgressHUD+CYH.h"

@implementation MBProgressHUD (CYH)

#pragma mark - 显示正在加载
+ (MBProgressHUD *)showLoading
{
    return [self showLoadingToView:nil];
}

+ (MBProgressHUD *)showLoadingToView:(UIView *)view
{
    return [self showMessage:@"loading..." toView:view];
}

+ (MBProgressHUD *)showLoadingMessage:(NSString *)message toView:(UIView *)view
{
    return [self showMessage:message toView:view];
}

#pragma mark - 带进度显示
+ (MBProgressHUD *)showAnnularDeterminate:(void (^)(MBProgressHUD *hud))whileExecutingBlock
{
    return [self showAnnularDeterminate:whileExecutingBlock toView:nil completionBlock:nil];
}

+ (MBProgressHUD *)showAnnularDeterminate:(void (^)(MBProgressHUD *))whileExecutingBlock toView:(UIView *)view completionBlock:(void (^)())completion
{
    return [self showAnnularDeterminateWithMessage:@"Loading..." toView:view whileExecutingBlock:whileExecutingBlock completionBlock:completion];
}

+ (MBProgressHUD *)showAnnularDeterminateWithMessage:(NSString *)message  toView:(UIView *)view whileExecutingBlock:(void (^)(MBProgressHUD *hud))whileExecutingBlock completionBlock:(void (^)())completion
{
    if (!view) {
        view = [[UIApplication sharedApplication].windows lastObject];
    }
    // 快速显示一个提示信息
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    
    // Set determinate mode
    hud.mode = MBProgressHUDModeAnnularDeterminate;
    
    hud.labelText = message;
    
    // myProgressTask uses the HUD instance to update progress
    [hud showAnimated:YES whileExecutingBlock:^{
        if (whileExecutingBlock) {
            whileExecutingBlock(hud);
        }
    } completionBlock:^{
        if (completion) {
            completion();
        }
    }];
    return hud;
}

#pragma mark - 显示成功信息
+ (MBProgressHUD *)showSuccess:(NSString *)success
{
    return [self showSuccess:success toView:nil];
}

+ (MBProgressHUD *)showSuccess:(NSString *)success toView:(UIView *)view
{
    return [self showMessage:success icon:@"success.png" toView:view];
}

#pragma mark - 显示错误信息
+ (MBProgressHUD *)showError:(NSString *)error
{
    return [self showError:error toView:nil];
}

+ (MBProgressHUD *)showError:(NSString *)error toView:(UIView *)view
{
    return [self showMessage:error icon:@"error.png" toView:view];
}

#pragma mark - 显示带图片信息
+ (MBProgressHUD *)showMessage:(NSString *)message icon:(NSString *)icon toView:(UIView *)view delay:(CGFloat)delay
{
    if (view == nil){
        view = [[UIApplication sharedApplication].windows lastObject];
    }
    // 快速显示一个提示信息
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    hud.labelText = message;
    // 设置图片
    hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:[NSString stringWithFormat:@"MBProgressHUD.bundle/%@", icon]]];
    // 再设置模式
    hud.mode = MBProgressHUDModeCustomView;
    
    // 隐藏时候从父控件中移除
    hud.removeFromSuperViewOnHide = YES;
    
    // 1秒之后再消失
    [hud hide:YES afterDelay:delay];
    
    return hud;
}

#pragma mark - 显示文字信息
+ (MBProgressHUD *)showMessage:(NSString *)message
{
    return [self showMessage:message toView:nil];
}

+ (MBProgressHUD *)showMessage:(NSString *)message icon:(NSString *)icon toView:(UIView *)view
{
    return [self showMessage:message icon:icon toView:view delay:HUDDelay];
}

+ (MBProgressHUD *)showMessage:(NSString *)message toView:(UIView *)view
{
    if (view == nil)
    {
        view = [[UIApplication sharedApplication].windows lastObject];
    }
    // 快速显示一个提示信息
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    hud.labelText = message;
    // 隐藏时候从父控件中移除
    hud.removeFromSuperViewOnHide = YES;
    // YES代表需要蒙版效果
    // hud.dimBackground = YES;
    hud.square = YES;
    return hud;
}
+ (MBProgressHUD *)showLoadingMessage:(NSString *)message WithDetails:(NSString *)details{
    return [MBProgressHUD showLoadingMessage:message WithDetails:details toView:nil];
}
+ (MBProgressHUD *)showLoadingMessage:(NSString *)message WithDetails:(NSString *)details toView:(UIView *)view{
    
    if (view == nil)
    {
        view = [[UIApplication sharedApplication].windows lastObject];
    }
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    hud.labelText = message;
    hud.detailsLabelText = details;
    hud.square = YES;
    hud.removeFromSuperViewOnHide = YES;
    
    return hud;
}
+ (MBProgressHUD *)showLoadingMessage:(NSString *)message withProgress:(float)progress toView:(UIView *)view {
    
    if (view == nil)
    {
        view = [[UIApplication sharedApplication].windows lastObject];
    }
    
    MBProgressHUD *hud = [self HUDForView:view];
    if (!hud) {
        hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
        hud.mode = MBProgressHUDModeDeterminate;
        hud.square = YES;
        hud.removeFromSuperViewOnHide = YES;
        hud.labelText = message;
    }
    hud.progress = progress;
    if (hud.progress == 1) {
        [self hideHUDForView:view];
    }
    return hud;
}


+ (MBProgressHUD *)showMessage:(NSString *)message toView:(UIView *)view delay:(CGFloat)delay{
    if (view == nil)
    {
        view = [[UIApplication sharedApplication].windows lastObject];
    }
    // 快速显示一个提示信息
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    hud.labelText = message;
    // 隐藏时候从父控件中移除
    hud.removeFromSuperViewOnHide = YES;
    // YES代表需要蒙版效果
    // hud.dimBackground = YES;
    hud.square = YES;
    [hud hide:YES afterDelay:delay];
    
    return hud;

}

#pragma mark - 隐藏
+ (void)hideHUD
{
    [self hideHUDForView:nil];
}

+ (void)hideHUDForView:(UIView *)view
{
    if (view == nil)
    {
        view = [[UIApplication sharedApplication].windows lastObject];
    }
    [self hideHUDForView:view animated:YES];
}

@end
