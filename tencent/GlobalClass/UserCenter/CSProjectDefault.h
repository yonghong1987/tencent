//
//  CSProjectDefault.h
//  Tencent
//
//  Created by sunon002 on 16/4/21.
//  Copyright © 2016年 cyh. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CSProjectModel.h"
@class CSProjectDefault;
//保存项目
#define kProjectDefaultProject @"project"
//保存项目名称
#define kProjectDefaultName @"projectName"
//保存项目id
#define kProjectDefaultId @"projectid"
//项目总数
#define kProjectDefaultTotal @"projectTotal"

@interface CSProjectDefault : NSObject

#pragma 单列
+ (CSProjectDefault *)shareProjectDefault;
//保存项目
- (void)saveProject:(CSProjectModel *)project;
//取出项目
- (CSProjectModel *)getProject;
//保存项目id
- (void)saveProjectId:(NSString *)projectid;
//取出项目id
- (NSString *)getProjectId;
//保存项目名称
- (void)saveProjectName:(NSString *)projectName;
//取出项目名称
- (NSString *)getProjectName;
//保存项目总数
- (void)saveProjectTotal:(NSString *)projectTotal;
//取出项目总数
- (NSString *)getProjectTotal;
@end
