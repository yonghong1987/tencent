//
//  CSMd5.h
//  tencent
//
//  Created by sunon002 on 16/4/18.
//  Copyright © 2016年 cyh. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CSMd5 : NSObject
//MD5加密
+ (NSString *)md5HexDigest:(NSString*)input;

+ (NSString *)getMd5FileName:(NSString*)fileName;



@end
