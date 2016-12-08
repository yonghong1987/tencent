//
//  CSDeleteVideoFileModel.h
//  tencent
//
//  Created by cyh on 16/11/15.
//  Copyright © 2016年 cyh. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CSImagePath.h"
#import "CSConfig.h"
@interface CSDeleteVideoFileModel : NSObject
//删除下载的视频
-(BOOL)deleteLoadVideoWithUrlString:(NSString *)urlString;
//已下载文件的路径
-(NSString *)downFilePath:(NSString *)filePath;

@end
