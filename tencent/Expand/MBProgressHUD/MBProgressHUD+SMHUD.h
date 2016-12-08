//
//  MBProgressHUD+SMHUD.h
//  sunMobile
//
//  Created by duck on 16/4/15.
//  Copyright © 2016年 www.sunontalent.com. All rights reserved.
//

#import "MBProgressHUD.h"

@interface MBProgressHUD (SMHUD)


+ (MBProgressHUD *)showToIndeterminate:(UIView *)toView;


/**
 *  显示HUD 默认文字loading...
 *
 *  @param toView 显示在那个Viwe上
 */
+ (MBProgressHUD *)showToView:(UIView *)toView;
/**
 *  显示HUD 需传入文字
 *
 *  @param toView 显示在那个Viwe上
 *  @param title  title
 */
+ (MBProgressHUD *)showToView:(UIView *)toView title:(NSString *)title;
/**
 *  显示HUD 需传入文字 和描述 描述文字
 *
 *  @param toView
 *  @param title
 *  @param details
 */
+ (MBProgressHUD *)showToView:(UIView *)toView title:(NSString *)title details:(NSString *)details;


/**
 *  显示 提示HUD 3秒后消失
 *
 *  @param toView
 *  @param text
 */
+ (MBProgressHUD *)showToView:(UIView *)toView text:(NSString *)text hideBlock:(MBProgressHUDBlock )block;
/**
 *  显示 提示HUD 几秒后消失
 *
 *  @param toView
 *  @param text
 *  @param afterDelay 时间
 */
+ (MBProgressHUD *)showToView:(UIView *)toView text:(NSString *)text afterDelay:(NSTimeInterval)afterDelay hideBlock:(MBProgressHUDBlock )block;
/**
 * 自定义时间后hud隐藏
 */
+ (MBProgressHUD *)showToView:(UIView *)toView title:(NSString *)title details:(NSString *)details afterDelay:(NSTimeInterval)afterDelay hideBlock:(MBProgressHUDBlock )block;

/**
 *  显示成功的图片 2s 秒消失
 *
 *  @param toView
 *
 *  @return
 */

+ (MBProgressHUD *)showSuccessToView:(UIView *)toView hideBlock:(MBProgressHUDBlock )block;

/**
 *  显示失败的图片 2s 秒消失
 *
 *  @param toView
 *  @param block
 *
 *  @return
 */
+ (MBProgressHUD *)showFailureToView:(UIView *)toView hideBlock:(MBProgressHUDBlock )block;

/**
 *  隐藏HUD
 *
 *  @param toView Show View
 */
+ (void )hideToView:(UIView *)toView;


@end
