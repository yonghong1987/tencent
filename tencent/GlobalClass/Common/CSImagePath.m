//
//  CSImagePath.m
//  tencent
//
//  Created by sunon002 on 16/4/16.
//  Copyright © 2016年 cyh. All rights reserved.
//

#import "CSImagePath.h"
#import "CSUrl.h"
#import "NSSring+MD5.h"
@implementation CSImagePath



NSString* noEncodeingImageOrVideoUrl(NSString *imgUrl)
{
    if (imgUrl.length>0) {
        NSString* str=nil;
        if ([imgUrl rangeOfString:@"http://"].location==NSNotFound&&[imgUrl rangeOfString:@"https://"].location==NSNotFound) {
            str=[NSString stringWithFormat:@"%@%@/%@",BASE_URL_STRING,MIDDLE_CATE,imgUrl];
        }else{
            str=imgUrl;
        }
        return str;
    }
    return @"";
}

NSString* getMd5FileName(NSString* url)
{
    NSString* urlSuffix=[NSString stringWithFormat:@".%@",[[url componentsSeparatedByString:@"."] lastObject]];//文件的后缀名
//    NSString* fileName=[[NSString md5String:url] stringByAppendingString:urlSuffix];//文件经过md5加密的名字
    return urlSuffix;
}

/*
 **获取图片路径
 */
+ (NSString *)getImageUrl:(NSString *)imageUrl{
    if (imageUrl.length > 0) {
        NSString *str = [self noEncodeingImageUrl:imageUrl];
        NSString* tranStr=[str stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        return tranStr;
    }
    return @"";
}
/*
 **未经过编码的图片路径
 */
+ (NSString *)noEncodeingImageUrl:(NSString *)imageUrl{
    if (imageUrl.length > 0) {
        NSString *str = nil;
        if ([imageUrl rangeOfString:@"http://"].location == NSNotFound && [imageUrl rangeOfString:@"https://"].location==NSNotFound) {
            str = [NSString stringWithFormat:@"%@%@/%@",BASE_URL_STRING,MIDDLE_CATE,imageUrl];
        }else{
            str = imageUrl;
        }
        return str;
    }
    return @"";
}

@end
