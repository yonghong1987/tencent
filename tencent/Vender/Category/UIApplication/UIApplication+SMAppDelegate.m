//
//  UIApplication+SMAppDelegate.m
//  sunMobile
//
//  Created by duck on 16/3/17.
//  Copyright © 2016年 www.sunontalent.com. All rights reserved.
//

#import "UIApplication+SMAppDelegate.h"

@implementation UIApplication (SMAppDelegate)
/**
 *  获取 AppDelegate 单例
 *
 *  @return AppDelegate
 */
+ (AppDelegate *)sharedAppDelegate{
     return (AppDelegate*)[UIApplication sharedApplication].delegate;
}

@end
