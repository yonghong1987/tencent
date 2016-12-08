//
//  CSCourseDetailOperationModel.h
//  tencent
//
//  Created by bill on 16/5/9.
//  Copyright © 2016年 cyh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

#import "CSDownManager.h"
#import "CSCourseDetailModel.h"
#import "CSCourseResourceModel.h"

//判断是从学习列表进入还是学习地图列表进入
typedef NS_ENUM(NSInteger, CSStudyType) {
    CSStudyModelType = 100, //从学习列表进入
    CSStudyMapType = 101, //从学习地图进入
};


@interface CSCourseDetailOperationModel : NSObject

/**
 *  课程知识点数组
 */
@property (nonatomic, strong) NSArray *resourceModelAry;

/**
 *  课程详情Model
 */
@property (nonatomic, strong) CSCourseDetailModel *courseDetailContent;
@property (nonatomic, assign) CSStudyType studyType;
/**
 *  关卡Id
 */
@property (nonatomic, strong) NSNumber *tollgateId;
/**
 *课程id
 */
@property (nonatomic, strong) NSNumber *courseId;
/**
 *关卡名
 */
@property (nonatomic, copy) NSString *tollgateName;
/**
 *  下一关关卡闯关成功动画
 */
@property (nonatomic, strong) NSString *nextLevelSuccessAnimation;

/**
 *  下一关关卡闯关失败动画
 */
@property (nonatomic, strong) NSString *nextLevelFailAnimation;
/**
 *  维持下载记录
 */
@property (nonatomic, strong) NSMutableDictionary *updateProgessDic;

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
/**
 *  父视图
 */
@property (nonatomic, strong) UIViewController *controlJump;

/**
 *  初始化下载Model
 *
 *  @param detailModel 课程详情模型
 *  @param resourceAry 资源队列
 *  @param parentVC    父视图
 *
 *  @return 下载Model
 */
- (id)initCSCourseDetailModel:(CSCourseDetailModel *)detailModel
        CSCourseResourceArray:(NSArray *)resourceAry
         parentViewController:(UIViewController *)parentVC;


/**
 *  注册sdk
 */
+ (void)configurationTVKSDK;

/**
 *  课前测验
 *
 *  @param sender 点击按钮
 */
- (void)examBeforeCourse:(UIButton *)sender;

/**
 *  课后测验 
 *
 *  @param sender 点击按钮
 */
- (void)examAfterCourse:(UIButton *)sender;

/**
 *  阅读文章
 *
 *  @param sender 点击按钮
 */
- (void)readArticle:(UIButton *)sender;

/**
 *  点播视频
 *
 *  @param sender 点击按钮
 */
- (void)playVideo:(UIButton *)sender;

/**
 *  直播视频
 *
 *  @param sender 点击按钮
 */
- (void)playLiveVideo:(UIButton *)sender;


/**
 *  视频下载
 *
 *  @param sender 点击按钮
 */
- (void)downLoadResource:(UIButton *)sender;

/**
 *记录资源浏览次数
 */
-(void)resourceBrowseWithResource:(CSCourseResourceModel *)resource;
@end
