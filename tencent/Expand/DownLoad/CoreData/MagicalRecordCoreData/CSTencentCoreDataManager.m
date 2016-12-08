//
//  CSTencentCoreDataManage.m
//  tencent
//
//  Created by duck on 2016/11/28.
//  Copyright © 2016年 cyh. All rights reserved.
//

#import "CSTencentCoreDataManager.h"
#import "MagicalRecord.h"
#import "TencentCourseDetail+CoreDataClass.h"
#import "CSUserDefaults.h"
#import "CSProjectDefault.h"
#import "VedioPlayProgress+CoreDataClass.h"
@implementation CSTencentCoreDataManager

+ (void)savaCourseDetail:(NSNumber * )courseId withJson:(id)jsonData{
    
    // MagicalRecord保存的方法，不是主线程
    [MagicalRecord saveWithBlock:^(NSManagedObjectContext *localContext) {
        
        TencentCourseDetail * courseDetailEntity = [CSTencentCoreDataManager queryCourseDetail:courseId];
        if (courseDetailEntity) {
            ///如果数据库有该数据，就停止插入
            return ;
        }
        courseDetailEntity = [TencentCourseDetail MR_createEntityInContext:localContext];
        courseDetailEntity.jsonData = jsonData;
        courseDetailEntity.userId = [[CSUserDefaults shareUserDefault].getUser.userId intValue];
        courseDetailEntity.projectId = [[[CSProjectDefault shareProjectDefault] getProjectId] intValue];
        courseDetailEntity.courseId = [courseId intValue];
        
    } completion:^(BOOL contextDidSave, NSError *error) {
        
        NSLog(@"com = %@",@(contextDidSave));
        
    }];
}



+ (id)queryCourseDetail:(NSNumber*)courseId{
    
    TencentCourseDetail * courseDetailEntity  = [CSTencentCoreDataManager queryCourseDetailEntity:courseId];
    return courseDetailEntity.jsonData;
}


+ (NSArray *)queryCourseAll{
    
    NSArray * allEntity  = [TencentCourseDetail MR_findByAttribute:@"userId" withValue:[CSUserDefaults shareUserDefault].getUser.userId];
    if (allEntity.count) {
        NSMutableArray * allJsonData = [[NSMutableArray alloc]init];
        for (TencentCourseDetail * courseDetailEntity in allEntity) {
            [allJsonData addObject:courseDetailEntity.jsonData];
        }
        return allJsonData;
    }
    return nil;
}

/**
 *通过项目id查询课程的数目
 */
+ (NSArray *)queryCourseWithProjectId{
    NSArray *courseCount = [TencentCourseDetail MR_findByAttribute:@"projectId" withValue:[CSProjectDefault shareProjectDefault].getProjectId];
    if (courseCount.count) {
        NSMutableArray * allJsonData = [[NSMutableArray alloc]init];
        for (TencentCourseDetail * courseDetailEntity in courseCount) {
            [allJsonData addObject:courseDetailEntity.jsonData];
        }
        return allJsonData;
    }
    return nil;
}

+ (void)deleteCourseDetail:(NSNumber *)courseId{
    
    TencentCourseDetail * courseDetailEntity = [CSTencentCoreDataManager queryCourseDetailEntity:courseId];
    
    if (courseDetailEntity) {
        [courseDetailEntity MR_deleteEntity];
        [[NSManagedObjectContext MR_defaultContext] MR_saveToPersistentStoreAndWait];
    }
    
}

///返回coreData 实体
+ (id)queryCourseDetailEntity:(NSNumber*)courseId{
    
    TencentCourseDetail * courseDetailEntity  = [[TencentCourseDetail MR_findByAttribute:@"courseId" withValue:courseId] lastObject];
    return courseDetailEntity;
}

+ (id)queryVedioPlayProgress:(NSString *)resourceUrl{
    VedioPlayProgress *progress = [[VedioPlayProgress MR_findByAttribute:@"resourceUrl" withValue:resourceUrl] lastObject];
    return progress;
}
/**
 *保存视频播放时长
 */
+ (void)saveVedioPlayTime:(float)progressTime resourceUrl:(NSString *)resourceUrl{
[MagicalRecord saveWithBlock:^(NSManagedObjectContext * _Nonnull localContext) {
    VedioPlayProgress *progress = [CSTencentCoreDataManager queryVedioPlayProgress:resourceUrl];
    if (progress) {
        [CSTencentCoreDataManager deleteVedio:resourceUrl];
    }
        progress = [VedioPlayProgress MR_createEntityInContext:localContext];
        progress.resourceUrl = resourceUrl;
        progress.playProgress = progressTime;
} completion:^(BOOL contextDidSave, NSError * _Nullable error) {
    NSLog(@"progressError");
}];
}

/**
 *查询该视频的播放时长
 */
+ (float)queryVedioPlayProgressWithResourceUrl:(NSString *)resourceUrl{
    VedioPlayProgress * progress = [CSTencentCoreDataManager queryVedioPlayProgress:resourceUrl];
    return progress.playProgress;
}

+ (void)deleteVedio:(NSString *)resourceUrl{
    VedioPlayProgress *progress = [CSTencentCoreDataManager queryVedioPlayProgress:resourceUrl];
    if (progress) {
        [progress MR_deleteEntity];
        [[NSManagedObjectContext MR_defaultContext] MR_saveToPersistentStoreAndWait];
    }
}
@end
