//
//  CSCourseResourceModel.h
//  tencent
//
//  Created by bill on 16/5/3.
//  Copyright © 2016年 cyh. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CSDownLoadResourceModel.h"
#import "JSONModel.h"
#import "CSBaseModel.h"

@interface CSCourseResourceModel : CSBaseModel


typedef NS_ENUM(NSInteger, DOWN_TYPE) {
    DOWN_DEFAULT = 0,//未开始
    DOWN_LOADING,//正在下载中
    DOWN_PAUSE, //暂停
    DOWN_SUCCESS,//成功
    DOWN_FAIL  //下载失败
};
 

/**
 *  资源类型 VIDEO,视频;ARTICLE，图文;LIVEVIDEO,直播;PRECOURSE课前考试，AFCOURSE课后考试
 */
//@property (nonatomic, strong) NSString *resourceType;
@property (nonatomic, strong) NSString *resCode;

/**
 *  允许下载
 */
@property (nonatomic, strong) NSNumber *allowDown;

/**
 *  资源Id
 */
//@property (nonatomic, strong) NSNumber *resourceId;
@property (nonatomic, strong) NSNumber *resId;

/**
 *  资源名
 */
//@property (nonatomic, strong) NSString *resourceName;
@property (nonatomic, strong) NSString *resName;

/**
 *  资源描述
 */
//@property (nonatomic, strong) NSString *resourceDescription;
@property (nonatomic, strong) NSString *describe;

/**
 *练身手中的延伸阅读--资源描述
 */
@property (nonatomic, copy) NSString *resDescribe;
/**
 *  资源浏览数
 */
//@property (nonatomic, strong) NSString *resourceViewAmount;
@property (nonatomic, strong) NSNumber *viewAmount;

/**
 *  资源详细内容
 */
@property (nonatomic, strong) NSString *resourceContent;

/**
 *  资源路径（视频播放地址或直播id）
 */
@property (nonatomic, strong) NSString *resource;
@property (nonatomic, strong) NSString *rsUrl;

/**
 *  直播开始时间
 */
//@property (nonatomic, strong) NSString *liveStartDate;
@property (nonatomic, strong) NSString *startDate;

/**
 *  直播结束时间
 */
//@property (nonatomic, strong) NSString *liveEndDate;
@property (nonatomic, strong) NSString *endDate;

///**
// *  //试卷状态（F=不合格/不通过  P=已合格/已通过 NOTSTART=待填写 NOTCOMMIT_TEST=未提交  ASSESSING=待评卷 OVERDUE_F = 过期未通过）
// */
//@property (nonatomic, strong) NSString *examStatus;
@property (nonatomic, strong) NSString *status;


/**
 *是否可以考试
 */
@property (nonatomic, strong) NSNumber *canTest;
/**
 *该跳转到哪个页面
 */
@property (nonatomic, copy) NSString *toPage;

/**
 *考试成绩id
 */
@property (nonatomic, strong) NSNumber *examActivityId;
/**
 *学习活动模块id
 */
@property (nonatomic, strong) NSNumber *modId;

/**
 *资源创建事件
 */
@property (nonatomic, strong) NSString *modifiedDate;
/**
 *  下载状态
 */
@property (nonatomic, assign) DOWN_TYPE download_type;

/**
 *  下载进度
 */
@property (nonatomic, strong) NSNumber *downLoadProgress;
/**
 *课程id
 */
@property (nonatomic, strong) NSNumber *courseId;

- (id)initWithDownLoadResourceModel:(CSDownLoadResourceModel *)downResourceModel;


///下载完成以后 视频的路径
@property (nonatomic ,copy) NSString * filePath;


@end
