//
//  CSExtensionReadViewController.h
//  tencent
//
//  Created by cyh on 16/8/15.
//  Copyright © 2016年 cyh. All rights reserved.
//

#import "CSBaseViewController.h"
#import "CSCourseResourceModel.h"
typedef NS_ENUM(NSInteger, CSExtensionReadType) {
    CSExtensionReadCaseType = 100,//案列跳转进来
    CSExtensionReadCourseType = 101,//课程跳转进来
};
@interface CSExtensionReadViewController : CSBaseViewController
/**
 *案列id
 */
@property (nonatomic, strong) NSNumber *caseId;
/**
 *课程id
 */
@property (nonatomic, strong) NSNumber *courseId;
@property (nonatomic, assign) CSExtensionReadType extensionReadType;

/*
 *保存点击的视频实体的url
 */
@property (nonatomic, copy) NSString *resourceUrl;

/*
 *保存点击的视频model
 */
@property (nonatomic, strong) CSCourseResourceModel* resourceModel;
/**
 *保存视频播放的进度
 */
@property (nonatomic, assign) float vedioProgress;
/**
 *保存视频播放总时长
 */
@property (nonatomic, assign) NSTimeInterval timeDuration;

@end
