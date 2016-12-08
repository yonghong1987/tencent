//
//  CSDeleteVideoFileModel.m
//  tencent
//
//  Created by cyh on 16/11/15.
//  Copyright © 2016年 cyh. All rights reserved.
//

#import "CSDeleteVideoFileModel.h"

@implementation CSDeleteVideoFileModel

//删除下载的视频
-(BOOL)deleteLoadVideoWithUrlString:(NSString *)urlString{
    NSString *targetStr = [self downFilePath:urlString];
    BOOL result = [self deleteFileWithPath:targetStr];
    return result;
}
//是否执行删除操作
-(BOOL)deleteFileWithPath:(NSString *)path{
    return NO;
}
//已下载文件的路径
-(NSString *)downFilePath:(NSString *)filePath{
    NSString *tranStr = [CSImagePath noEncodeingImageUrl:filePath];
    NSString *videoPath = [cacheDir stringByAppendingPathComponent:VIDOEDOWNLOADPATH];
    NSString *fileName = [self getMd5FileName:videoPath];
    NSString *targetStr = [videoPath stringByAppendingPathComponent:fileName];
    NSLog(@"targetStr:%@",targetStr);
    return targetStr;
}

//得到md5文件名
-(NSString *)getMd5FileName:(NSString *)filePath{
    NSString* urlSuffix=[NSString stringWithFormat:@".%@",[[filePath componentsSeparatedByString:@"."] lastObject]];//文件的后缀名
//    NSString* fileName=[[self md5String:filePath] stringByAppendingString:urlSuffix];//文件经过md5加密的名字
    return urlSuffix;
}

@end
