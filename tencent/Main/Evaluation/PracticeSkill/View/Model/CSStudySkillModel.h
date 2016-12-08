//
//  CSStudySkillModel.h
//  tencent
//
//  Created by admin on 16/5/16.
//  Copyright © 2016年 cyh. All rights reserved.
//

#import "CSBaseModel.h"
typedef NS_ENUM(NSInteger, CSCourseExamType) {
    CSPrecourseExamType = 100,
    CSAftercourseExamType,
};
@interface CSStudySkillModel : CSBaseModel
/**
 *  试卷id
 */
@property (nonatomic, strong) NSNumber *testId;
/**
 *  成绩id
 */
@property (nonatomic, strong) NSNumber *actAttId;
/**
 *  课程或者考试id
 */
@property (nonatomic, strong) NSNumber *examActivityId;
/**
 *  考试类型 EXAM-在线考试，PRECOURSE=课前测验，AFCOURSE=课后测验
 */
@property (nonatomic, copy) NSString *type;
/**
 *考试类型名称
 */
@property (nonatomic, copy) NSString *typeName;
/**
 *  考试开始时间
 */
@property (nonatomic, copy) NSString *startDate;
/**
 *  考试截止时间
 */
@property (nonatomic, copy) NSString *endDate;
/**
 *  课程或者考试的标题
 */
@property (nonatomic, copy) NSString *examActivityName;
/**
 *
 */
@property (nonatomic, copy) NSString *activityType;
/**
 *  试卷状态
 */
@property (nonatomic, copy) NSString *status;
/**
 *  是否可以重考
 */
@property (nonatomic, strong) NSNumber *isRepeat;
/**
 *考试状态名称
 */
@property (nonatomic, copy) NSString *statusName;
/**
 *是否可以考试
 */
@property (nonatomic, strong) NSNumber *canTest;
/**
 *该跳转到哪个页面
 */
@property (nonatomic, copy) NSString *toPage;
/**
 *是否已过期
 */
@property (nonatomic, strong) NSNumber *isOverTime;
@property (nonatomic, assign) CSCourseExamType courseExamType;

@end
