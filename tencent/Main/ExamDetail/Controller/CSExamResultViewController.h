//
//  CSExamResultViewController.h
//  tencent
//
//  Created by bill on 16/5/9.
//  Copyright © 2016年 cyh. All rights reserved.
//

#import "CSBaseViewController.h"
typedef NS_ENUM(NSUInteger, CSExamResultType) {
    CSExamResultDataType = 100,//从练身手列表进去
    CSExamResultBeforeType = 101,//从学习地图详情界面(课前)进去
    CSExamResultAfterType = 102,//从学习地图详情界面(课后)进去
    CSStudyResultBeforeType = 103,//从学习课程详情界面(课前)进去
    CSStudyResultAfterType = 104,//从学习课程详情界面(课后)进去
};

typedef NS_ENUM(NSInteger, CSWhichVcComeType) {
    CSNormalDetailVcComeType = 100,//从课程详情进入
    CSMapDetailVcComeType = 101,//从地图关卡详情进入
};

typedef NS_ENUM(NSInteger, CSExamContentType) {
    CSSkillListType = 100,//从练身手列表进入
};

@interface CSExamResultViewController : CSBaseViewController

/**
 *  资源Id
 */
@property (nonatomic, strong) NSNumber *resourceId;
/**
 *  课程或者考试成绩id
 */
@property (nonatomic, strong) NSNumber *examActivityId;
@property (nonatomic, assign) CSExamResultType examReultType;
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
 *点击是哪个cell（从前一界面传过来）
 */

@property (nonatomic, assign) NSInteger whichRow;
/**
 *从课程详情直接进入
 */
@property (nonatomic, assign) CSWhichVcComeType comeType;
/**
 *是否从练身手列表界面进入
 */
@property (nonatomic, assign) CSExamContentType examContentType;
@end
