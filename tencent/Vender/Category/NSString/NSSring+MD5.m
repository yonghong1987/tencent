//
//  NSSring+MD5.m
//  PJAPP
//
//  Created by 付 亚明 on 1/2/14.
//  Copyright (c) 2014 yuchangtao. All rights reserved.
//

#import "NSSring+MD5.h"
#import <CommonCrypto/CommonDigest.h>

@implementation NSString(MD5)

+ (NSString *)md5String:(NSString *)str
{
    const char *cStr = [str UTF8String];
    unsigned char result[16];
    CC_MD5( cStr, strlen(cStr), result );
    return [NSString stringWithFormat:
            @"%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X",
            result[0], result[1], result[2], result[3],
            result[4], result[5], result[6], result[7],
            result[8], result[9], result[10], result[11],
            result[12], result[13], result[14], result[15]
            ];
}

+ (NSString *)getMd5FileName:(NSString *)url{
    NSString* urlSuffix=[NSString stringWithFormat:@".%@",[[url componentsSeparatedByString:@"."] lastObject]];//文件的后缀名
    NSString* fileName=[[NSString md5String:url] stringByAppendingString:urlSuffix];//文件经过md5加密的名字
    return fileName;
}
@end
