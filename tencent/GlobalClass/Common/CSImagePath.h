//
//  CSImagePath.h
//  tencent
//
//  Created by sunon002 on 16/4/16.
//  Copyright © 2016年 cyh. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CSImagePath : NSObject


NSString *noEncodeingImageOrVideoUrl(NSString *imgUrl);
NSString* getMd5FileName(NSString* url);

/*
 **创建manager对象
 */
+ (NSString *)getImageUrl:(NSString *)imageUrl;
/*
 **未经过编码的图片路径
 */
+ (NSString *)noEncodeingImageUrl:(NSString *)imageUrl;

@end
