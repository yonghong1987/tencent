//
//  NSSring+MD5.h
//  PJAPP
//
//  Created by 付 亚明 on 1/2/14.
//  Copyright (c) 2014 yuchangtao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString(MD5)
/**
 *md5加密
 */
+ (NSString *)md5String:(NSString *)str;
/**
 *md5解密
 */
+ (NSString *)getMd5FileName:(NSString *)url;
@end
