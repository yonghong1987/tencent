//
//  SMHomeViewController.h
//  sunMobile
//
//  Created by duck on 16/3/17.
//  Copyright © 2016年 www.sunontalent.com. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^ItemActonBlock)(UIBarButtonItem *);
@interface UIBarButtonItem (Common)
/**
 *  国际化处理
 */
@property (nonatomic ,assign)NSString * locaString;






+ (UIBarButtonItem *)itemWithBtnTitle:(NSString *)title target:(id)obj action:(SEL)selector;

+ (UIBarButtonItem *)itemWithIcon:(NSString*)iconName showBadge:(BOOL)showbadge target:(id)obj action:(SEL)selector;


/**
 *  UIBarButtonItem
 *
 *  @param title       tittle
 *  @param actionBlock block
 *
 *  @return UIBarButtonItem
 */
+ (UIBarButtonItem *)itemWithBtnTitle:(NSString *)title  actionBolock:(ItemActonBlock)actionBlock;

/**
 *  UIBarButtonItem
 *
 *  @param iconName    图片名称
 *  @param showbadge   badge 暂未实现
 *  @param actionBlock block
 *
 *  @return UIBarButtonItem
 */
+ (UIBarButtonItem *)itemWithIcon:(NSString*)iconName highlightedIcon:(NSString *)hIconName showBadge:(BOOL)showbadge count:(NSInteger)count actionBolock:(ItemActonBlock)actionBlock;

+ (UIBarButtonItem *)itemWithIcon:(NSString*)iconName showBadge:(BOOL)showbadge actionBolock:(ItemActonBlock)actionBlock;

/**
 *  UIBarButtonItem
 *
 *  @param iconName   UIControlStateNormal  图片名称
 *  @param hIconName    UIControlStateHighlighted  图片名称
 *  @param showbadge   badge 暂未实现
 *  @param actionBlock block
 *
 *  @return UIBarButtonItem
 */
+ (UIBarButtonItem *)itemWithIcon:(NSString*)iconName highlightedIcon:(NSString *)hIconName showBadge:(BOOL)showbadge actionBolock:(ItemActonBlock)actionBlock;
/**
 *  是否高亮
 */
@property (nonatomic ,assign)BOOL isHighlighted;

@end

