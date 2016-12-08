//
//  CSTencentCoreDataManage.h
//  tencent
//
//  Created by duck on 2016/11/28.
//  Copyright © 2016年 cyh. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CSTencentCoreDataManager : NSObject

/**
 保存课程

 @param courseId 课程id
 @param jsonData 课程数据
 */
+ (void)savaCourseDetail:(NSNumber * )courseId withJson:(id)jsonData;

/**
 查询课程详情

 @param courseId 课程id
 @return 课程数据
 */
+ (id)queryCourseDetail:(NSNumber*)courseId;

/**
 查询所有的课程

 @return 课程数据集合
 */
+ (NSArray *)queryCourseAll;

/**
 *通过项目id查询课程的数目
 */
+ (NSArray *)queryCourseWithProjectId;
/**
 *通过projectId与courseId查出课程数目
 */
+ (NSArray *)queryCourseWithProjectIdAndCourseId;
/**
 课程详情

 @param courseId 课程id
 */
+ (void)deleteCourseDetail:(NSNumber *)courseId;


/**
 *保存视频播放时长
 */
+ (void)saveVedioPlayTime:(float)progressTime resourceUrl:(NSString *)resourceUrl;
/**
 *查询该视频的播放时长
 */
+ (float)queryVedioPlayProgressWithResourceUrl:(NSString *)resourceUrl;
+ (void)deleteVedio:(NSString *)resourceUrl;


@end
