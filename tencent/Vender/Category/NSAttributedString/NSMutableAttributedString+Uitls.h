//
//  NSMutableAttributedString+Uitls.h
//  sunMobile
//
//  Created by duck on 16/4/13.
//  Copyright © 2016年 www.sunontalent.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface NSMutableAttributedString (Uitls)

/**
 *  给文字加投影
 *
 *  @param attString 需要投影的文字
 *
 *  @return NSMutableAttributedString
 */
+ (id)addAttributeWithText:(NSString * )attString;

/**
 *  duck
 *
 *  @param color UIColor
 *  @param range NSRange
 */
- (void)addAttributeWithTextColor:(UIColor*)color range:(NSRange)range;
/**
 *  duck
 *
 *  @param color UIColor
 *  @param range NSRange
 */
- (void)addAttributeWithFont:(UIFont *)font range:(NSRange)range;
/**
 *  duck
 *
 *  @param color UIColor
 *  @param range NSRange
 */
- (void)addAttributeWithFont:(UIFont *)font color:(UIColor*)color range:(NSRange)range;


@end
