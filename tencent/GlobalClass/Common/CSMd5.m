//
//  CSMd5.m
//  tencent
//
//  Created by sunon002 on 16/4/18.
//  Copyright © 2016年 cyh. All rights reserved.
//

#import "CSMd5.h"
#import <CommonCrypto/CommonDigest.h>
@implementation CSMd5

+ (NSString *)md5HexDigest:(NSString*)input
{
    const char* str = [input UTF8String];
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    CC_MD5(str, strlen(str), result);
    NSMutableString *ret = [NSMutableString string];//
    
    for(int i = 0; i<CC_MD5_DIGEST_LENGTH; i++) {
        [ret appendFormat:@"%02X",result[i]];
    }
    return [ret lowercaseString];
}

+ (NSString *)getMd5FileName:(NSString *)fileName{
    
    NSString *urlSuffix=[NSString stringWithFormat:@".%@",[[fileName componentsSeparatedByString:@"."] lastObject]];//文件的后缀名
    NSString *md5FileName = [[CSMd5 md5HexDigest:fileName] stringByAppendingString:urlSuffix];//文件经过md5加密的名字
    return md5FileName;
}

@end
