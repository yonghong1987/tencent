//
//  CSProjectDefault.m
//  Tencent
//
//  Created by sunon002 on 16/4/21.
//  Copyright © 2016年 cyh. All rights reserved.
//

#import "CSProjectDefault.h"

@implementation CSProjectDefault

#pragma 单列
+ (CSProjectDefault *)shareProjectDefault{
    static CSProjectDefault *share = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        share = [[CSProjectDefault alloc]init];
    });
    return share;
}

#pragma mark -
//取出保存的信息
- (id)getData:(NSString *)key
{
    NSUserDefaults *standardUserDefaults = [NSUserDefaults standardUserDefaults];
    NSString *val = nil;
    
    if (standardUserDefaults)
        val = [standardUserDefaults objectForKey:key];
    
    return val;
}
//保存信息
- (BOOL)saveData:(NSString *)key andValue:(id)value
{
    NSUserDefaults *standardUserDefaults = [NSUserDefaults standardUserDefaults];
    BOOL bResult = NO;
    if (standardUserDefaults) {
        [standardUserDefaults setObject:value forKey:key];
        [standardUserDefaults synchronize];
        bResult = YES;
    }
    return bResult;
}
//保存项目
- (void)saveProject:(CSProjectModel *)project{
    NSData *projectData = [NSKeyedArchiver archivedDataWithRootObject:project];
    [self saveData:kProjectDefaultProject andValue:projectData];
}
//取出项目
- (CSProjectModel *)getProject{
    NSData *projectData = [self getData:kProjectDefaultProject];
    CSProjectModel *project = [CSProjectModel new];
    if (projectData.length > 0) {
        project = [NSKeyedUnarchiver unarchiveObjectWithData:projectData];
    }
    return project;
}
//保存项目id
- (void)saveProjectId:(NSString *)projectid{
    [self saveData:kProjectDefaultId andValue:projectid];
}
//取出项目id
- (NSString *)getProjectId{
    return [self getData:kProjectDefaultId];
}
//保存项目名称
- (void)saveProjectName:(NSString *)projectName{
    [self saveData:kProjectDefaultName andValue:projectName];
}
//取出项目名称
- (NSString *)getProjectName{
    return [self getData:kProjectDefaultName];
}

//保存项目总数
- (void)saveProjectTotal:(NSString *)projectTotal{
    [self saveData:kProjectDefaultTotal andValue:projectTotal];
}
//取出项目总数
- (NSString *)getProjectTotal{
    return [self getData:kProjectDefaultTotal];
}
@end
