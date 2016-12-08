//
//  UIView+Gesture.m
//  sunMobile
//
//  Created by Evan on 16/4/6.
//  Copyright © 2016年 www.sunontalent.com. All rights reserved.
//

#import "UIView+Gesture.h"

@implementation UIView (Gesture)

#pragma mark - 点击view空白处自动隐藏键盘
- (void)singleTapEndTapped
{
    /**
     *  点击空白收回键盘
     */
    self.userInteractionEnabled = YES;
    
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(fingerTapped:)];
    singleTap.cancelsTouchesInView = NO;
    [self addGestureRecognizer:singleTap];
}

-(void)fingerTapped:(UITapGestureRecognizer *)gestureRecognizer
{
    [self endEditing:YES];
}

@end
