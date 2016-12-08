//
//  CSDownManager.h
//  eLearning
//
//  Created by sunon on 14-5-19.
//  Copyright (c) 2014年 sunon. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CSCourseResourceModel.h"
@interface CSDownManager : NSObject

+ (CSDownManager *)sharedManger;

//@property(nonatomic,strong)NSManagedObjectContext *otherContext;
//-(void)addObject:(CSResouceModel *)obj;
//-(void)otherOperate:(CSResouceModel *)obj;


/**
 *  初始化下载
 *
 *  @param model 下载视频的信息
 */
- (void)initDownload:(CSCourseResourceModel *)model;

/**
 *  更新视频下载状态
 *
 *  @param model 下载视频的信息
 */
- (void)resetDownLoad:(CSCourseResourceModel *)model;

@end
