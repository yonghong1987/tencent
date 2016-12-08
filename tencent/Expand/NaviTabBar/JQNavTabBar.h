//
//  JQNavTabBar.h
//  JQNavTabBarController
//
//  Created by Evan on 16/4/22.
//  Copyright © 2016年 Evan. All rights reserved.
//

#import <UIKit/UIKit.h>

@class JQNavTabBar;

@protocol JQNavTabBarDelegate <NSObject>

- (void)navTabBar:(JQNavTabBar *)navTabBar didSelectedItemWithIndex:(NSInteger)index animated:(BOOL)animated;

@end

@interface JQNavTabBar : UIView

@property (weak, nonatomic) id<JQNavTabBarDelegate> delegate;

@property (nonatomic, assign) NSInteger currentItemIndex;
/**
 *  最大列数 默认4
 */
@property (nonatomic, assign) NSInteger maxColunm;
/**
 *  标签数组
 */
@property (strong, nonatomic) NSArray *tagsList;
/**
 *  选择颜色
 */
@property (nonatomic, strong) UIColor *itemNormalColor;
/**
 *  正常颜色
 */
@property (nonatomic, strong) UIColor *itemSelectedColor;

- (void)selectItemAtIndex:(NSInteger)selectIndex scrollAnimated:(BOOL)animated;

@end
