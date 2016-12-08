//
//  NSMutableAttributedString+Uitls.m
//  sunMobile
//
//  Created by duck on 16/4/13.
//  Copyright © 2016年 www.sunontalent.com. All rights reserved.
//

#import "NSMutableAttributedString+Uitls.h"

@implementation NSMutableAttributedString (Uitls)

- (void)addAttributeWithTextColor:(UIColor*)color range:(NSRange)range{
    
     [self addAttributes:@{NSForegroundColorAttributeName:color } range:range];
    
}

- (void)addAttributeWithFont:(UIFont *)font range:(NSRange)range{
    [self addAttributes:@{NSFontAttributeName:font } range:range];
}

- (void)addAttributeWithFont:(UIFont *)font color:(UIColor*)color range:(NSRange)range{
    [self addAttributes:@{NSFontAttributeName:font,NSForegroundColorAttributeName:
                          color} range:range];
}

+ (id)addAttributeWithText:(NSString * )attString{
    
    NSMutableAttributedString  * attributed = [[NSMutableAttributedString alloc]initWithString:attString];

    NSShadow * shadow = [[NSShadow alloc]init];
    shadow.shadowBlurRadius = 5;
    shadow.shadowColor = [UIColor blackColor];
    
    [attributed addAttributes:@{NSShadowAttributeName:shadow} range: NSMakeRange(0, attString.length)];
    
    return attributed;
}

@end
