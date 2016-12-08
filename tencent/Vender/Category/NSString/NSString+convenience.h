//
//  NSString+convenience.h
//  eLearning
//
//  Created by sunon on 14-5-27.
//  Copyright (c) 2014年 sunon. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (convenience)
//去掉NSString中的空白
-(NSString *)GetRidOfBlank;
/**
 *  去掉左右两边的空格
 *
 *  @return 字符串类型
 */
-(NSString *)RemoveleftRightBlank;
-(NSString *)removeHeaderSeperator;
- (NSString *)URLEncodedString;
- (NSString*)URLDecodedString;
//计算包含中文的文字的长度   一个汉字相当于2个字符
-(int)calculateStrContainHanZiLength;
-(BOOL)isContainsEmoji;
-(NSString *)removeEmojiInStr;
@end
