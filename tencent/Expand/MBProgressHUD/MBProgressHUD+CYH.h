//
//  MBProgressHUD+CYH.h
//  tencent
//
//  Created by sunon002 on 16/4/22.
//  Copyright © 2016年 cyh. All rights reserved.
//

//#import <MBProgressHUD/MBProgressHUD.h>
#import "MBProgressHUD.h"

///默认hud 消失时间
#define HUDDelay 2.0

typedef void(^HUDProgressBlock)(NSInteger);

@interface MBProgressHUD (CYH)

/**
 *  显示正在加载
 */
+ (MBProgressHUD *)showLoading;

+ (MBProgressHUD *)showLoadingToView:(UIView *)view;

+ (MBProgressHUD *)showLoadingMessage:(NSString *)message toView:(UIView *)view;

/**
 *  带进度显示
 */
+ (MBProgressHUD *)showAnnularDeterminate:(void (^)(MBProgressHUD *hud))whileExecutingBlock;

+ (MBProgressHUD *)showAnnularDeterminate:(void (^)(MBProgressHUD *))whileExecutingBlock toView:(UIView *)view completionBlock:(void (^)())completion;

+ (MBProgressHUD *)showAnnularDeterminateWithMessage:(NSString *)message  toView:(UIView *)view whileExecutingBlock:(void (^)(MBProgressHUD *hud))whileExecutingBlock completionBlock:(void (^)())completion;

/**
 *  显示成功
 */
+ (MBProgressHUD *)showSuccess:(NSString *)success;

+ (MBProgressHUD *)showSuccess:(NSString *)success toView:(UIView *)view;

/**
 *  显示错误
 */
+ (MBProgressHUD *)showError:(NSString *)error;

+ (MBProgressHUD *)showError:(NSString *)error toView:(UIView *)view;

/**
 *  显示带图片信息
 */
+ (MBProgressHUD *)showMessage:(NSString *)message icon:(NSString *)icon toView:(UIView *)view delay:(CGFloat)delay;

/**
 *  显示信息
 */
+ (MBProgressHUD *)showMessage:(NSString *)message;

+ (MBProgressHUD *)showMessage:(NSString *)message toView:(UIView *)view;

+ (MBProgressHUD *)showMessage:(NSString *)message toView:(UIView *)view delay:(CGFloat)delay;
/**
 *  隐藏
 */
+ (void)hideHUD;

+ (void)hideHUDForView:(UIView *)view;

/**
 *  显示 Details
 */
+ (MBProgressHUD *)showLoadingMessage:(NSString *)message WithDetails:(NSString *)details;
+ (MBProgressHUD *)showLoadingMessage:(NSString *)message WithDetails:(NSString *)details toView:(UIView *)view;
/**
 *  显示 进度条
 */
+ (MBProgressHUD *)showLoadingMessage:(NSString *)message withProgress:(float)progress toView:(UIView *)view;
@end
