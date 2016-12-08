//
//  UIView+SMXIB.m
//  sunMobile
//
//  Created by duck on 16/4/27.
//  Copyright © 2016年 www.sunontalent.com. All rights reserved.
//

#import "UIView+SMXIB.h"

@implementation UIView (SMXIB)
+ (instancetype)loadXIBView{
    NSString * className = NSStringFromClass([self class]);
    return [[[NSBundle mainBundle]loadNibNamed:className owner:nil options:nil]lastObject];
}
@end
