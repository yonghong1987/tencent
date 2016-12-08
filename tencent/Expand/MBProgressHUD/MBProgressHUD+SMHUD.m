//
//  MBProgressHUD+SMHUD.m
//  sunMobile
//
//  Created by duck on 16/4/15.
//  Copyright © 2016年 www.sunontalent.com. All rights reserved.
//

#import "MBProgressHUD+SMHUD.h"

const NSTimeInterval  TimeAfterDelay = 2.0;
@interface MBProgressHUD ()

@end

@implementation MBProgressHUD (SMHUD)
//-------------
+ (MBProgressHUD *)showToIndeterminate:(UIView *)toView{
    return [MBProgressHUD showToView:toView title:nil];
}

+ (MBProgressHUD *)showToView:(UIView *)toView{
    return  [MBProgressHUD showToView:toView title:NSLocalizedString(@"HUD_Loading", nil)];
}

+ (MBProgressHUD *)showToView:(UIView *)toView title:(NSString *)title{
   return [MBProgressHUD showToView:toView title:title details:nil];
}

+ (MBProgressHUD *)showToView:(UIView *)toView title:(NSString *)title details:(NSString *)details{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:toView animated:YES];
    hud.label.text = title;
    hud.removeFromSuperViewOnHide = YES;
    hud.detailsLabel.text = details;
    hud.backgroundView.style = MBProgressHUDBackgroundStyleSolidColor;
    return hud;
}
//-------------

+ (MBProgressHUD *)showToView:(UIView *)toView text:(NSString *)text hideBlock:(MBProgressHUDBlock )block{
   return  [MBProgressHUD showToView:toView text:text afterDelay:TimeAfterDelay hideBlock:block];
}
+ (MBProgressHUD *)showToView:(UIView *)toView text:(NSString *)text afterDelay:(NSTimeInterval)afterDelay hideBlock:(MBProgressHUDBlock )block{
    return [MBProgressHUD showToView:toView title:text details:nil afterDelay:afterDelay hideBlock:block];
}



+ (MBProgressHUD *)showSuccessToView:(UIView *)toView hideBlock:(MBProgressHUDBlock )block{
    
    [MBProgressHUD hideToView:toView];
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:toView animated:YES];
    UIImage *image = [[UIImage imageNamed:@"btn_agree"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
    hud.customView = imageView;
    hud.mode = MBProgressHUDModeCustomView;
    hud.label.text = NSLocalizedString(@"HUD_Save_Successful", nil);
    hud.block = block;
    [hud hideAnimated:YES afterDelay:TimeAfterDelay];
    return hud;
}
+ (MBProgressHUD *)showFailureToView:(UIView *)toView hideBlock:(MBProgressHUDBlock )block{
    [MBProgressHUD hideToView:toView];

    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:toView animated:YES];
    UIImage *image = [[UIImage imageNamed:@"btn_agree"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
    hud.customView = imageView;
    hud.mode = MBProgressHUDModeCustomView;
    hud.label.text = NSLocalizedString(@"HUD_Save_Failure", nil);
    hud.block = block;
    [hud hideAnimated:YES afterDelay:TimeAfterDelay];
    return hud;
}




+ (void)hideToView:(UIView *)toView{
    [MBProgressHUD hideHUDForView:toView animated:YES];
}

/**
 *自定义时间后hud隐藏
 */
+ (MBProgressHUD *)showToView:(UIView *)toView title:(NSString *)title details:(NSString *)details
                   afterDelay:(NSTimeInterval)afterDelay hideBlock:(MBProgressHUDBlock )block{
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:toView animated:YES];
    hud.mode = MBProgressHUDModeText;
    hud.label.text = title;
    hud.label.numberOfLines = 0;
    hud.block = block;
    hud.detailsLabel.text = details;
    [hud hideAnimated:YES afterDelay:afterDelay];

    return hud;

}
@end
