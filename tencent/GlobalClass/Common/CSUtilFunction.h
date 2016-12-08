//
//  CSUtilFunction.h
//  tencent
//
//  Created by bill on 16/5/4.
//  Copyright © 2016年 cyh. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface CSUtilFunction : NSObject
+ (BOOL)isNotNiLString:(NSString*)str;
/**
 *  获取当前视图的根视图
 *
 *  @return 根视图
 */
+ (UINavigationController *)getCurrentRootNavigationController;


/**
 *  字符串转成Number
 *
 *  @param convertStr 需要转换的字符串
 *
 *  @return 转换结果
 */
+ (NSNumber *)stringToNumber:(NSString *)convertStr;

/**
 *  Number转成字符串
 *
 *  @param convertNum 需要转换的Number
 *
 *  @return 转换结果
 */
+ (NSString *)numberToString:(NSNumber *)convertNum;

@end
