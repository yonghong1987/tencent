//
//  JQNavTabBarController.h
//  JQNavTabBarController
//
//  Created by Evan on 16/4/22.
//  Copyright © 2016年 Evan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JQNavTabBarController : UIViewController
/*
 **控制器数组
 */
@property (nonatomic, strong) NSMutableArray *viewControllers;

@property (assign, nonatomic) BOOL bounces;
/**
 *  是否滚动
 */
@property(nonatomic,getter=isScrollEnabled) BOOL scrollEnabled;

@end
