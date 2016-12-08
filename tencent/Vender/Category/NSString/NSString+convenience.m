//
//  NSString+convenience.m
//  eLearning
//
//  Created by sunon on 14-5-27.
//  Copyright (c) 2014年 sunon. All rights reserved.
//

#import "NSString+convenience.h"

@implementation NSString (convenience)
-(NSString *)GetRidOfBlank
{
    NSString* str=[self stringByReplacingOccurrencesOfString:@" " withString:@""];
    return str;
}
-(NSString *)RemoveleftRightBlank
{
    NSString *str=[self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    return str;
}
-(NSString *)removeHeaderSeperator
{
    NSString* str=self;
    while([str hasPrefix:@"\n"]){
        str=[str substringFromIndex:2];
    }
    return str;
}
- (NSString *)URLEncodedString
{
    NSString *result = (__bridge_transfer NSString *)
    CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,
                                            (CFStringRef)self,
                                            NULL,
                                            CFSTR("!*'();:@&=+$,/?%#[]"),
                                            kCFStringEncodingUTF8);
    return result;
}
- (NSString*)URLDecodedString
{
    NSString   *result = (__bridge_transfer NSString *)CFURLCreateStringByReplacingPercentEscapesUsingEncoding(kCFAllocatorDefault,
                                                                                           (CFStringRef)self,
                                                                                           CFSTR(""),
                                                                                           kCFStringEncodingUTF8);
    return result;
}
-(int)calculateStrContainHanZiLength
{
    int j=0;
    for (int i=0; i<[self length]; i++) {
        unichar c=[self characterAtIndex:i];
        if (c>=0x4E00&&c<=0x9FA5) {
            j+=2;
        }else{
            j+=1;
        }
    }
    return j;
}
-(BOOL)isContainsEmoji{
    __block BOOL isEomji = NO;
    [self enumerateSubstringsInRange:NSMakeRange(0, [self length]) options:NSStringEnumerationByComposedCharacterSequences usingBlock:
     ^(NSString *substring, NSRange substringRange, NSRange enclosingRange, BOOL *stop) {
         const unichar hs = [substring characterAtIndex:0];
         if (0xd800 <= hs && hs <= 0xdbff) {
             if (substring.length > 1) {
                 const unichar ls = [substring characterAtIndex:1];
                 const int uc = ((hs - 0xd800) * 0x400) + (ls - 0xdc00) + 0x10000;
                 if (0x1d000 <= uc && uc <= 0x1f77f) {
                     isEomji = YES;
                 }
             }
         } else if (substring.length > 1) {
             const unichar ls = [substring characterAtIndex:1];
             if (ls == 0x20e3) {
                 isEomji = YES;
             }
         } else {
//             if (0x2100 <= hs && hs <= 0x27ff && hs != 0x263b) {
//                 isEomji = YES;
//             } else
             if (0x2B05 <= hs && hs <= 0x2b07) {
                 isEomji = YES;
             } else if (0x2934 <= hs && hs <= 0x2935) {
                 isEomji = YES;
             } else if (0x3297 <= hs && hs <= 0x3299) {
                 isEomji = YES;
             } else if (hs == 0xa9 || hs == 0xae || hs == 0x303d || hs == 0x3030 || hs == 0x2b55 || hs == 0x2b1c || hs == 0x2b1b || hs == 0x2b50|| hs == 0x231a ) {
                 isEomji = YES;
             }
         }
     }];
    return isEomji;
}
-(NSString *)removeEmojiInStr
{
    __block NSString* str=[NSString stringWithFormat:@"%@",self];
    [self enumerateSubstringsInRange:NSMakeRange(0, [self length]) options:NSStringEnumerationByComposedCharacterSequences usingBlock:
     ^(NSString *substring, NSRange substringRange, NSRange enclosingRange, BOOL *stop) {
         const unichar hs = [substring characterAtIndex:0];
         if (0xd800 <= hs && hs <= 0xdbff) {
             if (substring.length > 1) {
                 const unichar ls = [substring characterAtIndex:1];
                 const int uc = ((hs - 0xd800) * 0x400) + (ls - 0xdc00) + 0x10000;
                 if (0x1d000 <= uc && uc <= 0x1f77f) {
                     str=[str stringByReplacingOccurrencesOfString:substring withString:@""];
                 }
             }
         } else if (substring.length > 1) {
             const unichar ls = [substring characterAtIndex:1];
             if (ls == 0x20e3) {
                 str=[str stringByReplacingOccurrencesOfString:substring withString:@""];
             }
         } else {
//             if (0x2100 <= hs && hs <= 0x27ff && hs != 0x263b) {
//                 str=[str stringByReplacingOccurrencesOfString:substring withString:@""];
//             } else
            if (0x2B05 <= hs && hs <= 0x2b07) {
                 str=[str stringByReplacingOccurrencesOfString:substring withString:@""];
             } else if (0x2934 <= hs && hs <= 0x2935) {
                 str=[str stringByReplacingOccurrencesOfString:substring withString:@""];
             } else if (0x3297 <= hs && hs <= 0x3299) {
                 str=[str stringByReplacingOccurrencesOfString:substring withString:@""];
             } else if (hs == 0xa9 || hs == 0xae || hs == 0x303d || hs == 0x3030 || hs == 0x2b55 || hs == 0x2b1c || hs == 0x2b1b || hs == 0x2b50|| hs == 0x231a ) {
                 str=[str stringByReplacingOccurrencesOfString:substring withString:@""];
             }
         }
     }];
    return str;
}
@end
