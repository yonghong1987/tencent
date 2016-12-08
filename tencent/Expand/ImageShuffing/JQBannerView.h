//
//  JQBannerView.h
//  XCar
//
//  Created by Evan on 15/10/10.
//  Copyright © 2015年 Evan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JQBannerView : UIView
/*
 ***广告页图片数组
 */
@property (strong, nonatomic) NSArray *bannerArray;
/*
 **pageControl的颜色
 */
@property (nonatomic, strong) UIColor *currentPageIndicatorTintColor;

@property (copy, nonatomic) void(^didSelectItemAtIndex)(NSUInteger );
/*
 **定时器
 */
@property (strong, nonatomic) NSTimer *timer;

- (void)addTimer;
- (void)removeTimer;
@end
