//
//  CSExamResultModel.h
//  tencent
//
//  Created by cyh on 16/8/16.
//  Copyright © 2016年 cyh. All rights reserved.
//

#import "CSBaseModel.h"
typedef  NS_ENUM(NSInteger, CSExamResultIsPassType){
    CSExamPassType = 100,
    CSExamNoPassType,
    
};
@interface CSExamResultModel : CSBaseModel

/**
 *试卷总分
 */
@property (nonatomic, strong) NSNumber *score;
/**
 *试卷合格分
 */
@property (nonatomic, strong) NSNumber *passingScore;
/**
 *考试得分
 */
@property (nonatomic, strong) NSNumber *finalScore;
/**
 *成绩id
 */
@property (nonatomic, strong) NSNumber *actTestAttId;
/**
 *考试状态
 */
@property (nonatomic, copy) NSString *status;
/**
 *考试状态名称
 */
@property (nonatomic, copy) NSString *statusName;
/**
 *考试状态名称
 */
@property (nonatomic, strong) NSNumber *displayAnswer;
/**
 *是否可以提交试卷
 */
@property (nonatomic, strong) NSNumber *canAnswer;



/**
 *进入考试结果页添加的字段
 */

/**
 *考试等级名称
 */
@property (nonatomic, strong) NSNumber *scoreLevel;
/**
 *考试等级图片
 */
@property (nonatomic, copy) NSString *levelImg;
/**
 *是否可以进入考试
 */
@property (nonatomic, strong) NSNumber *canTest;
/**
 *考试ID
 */
@property (nonatomic, strong) NSNumber *examActivityId;
/**
 *考试提示语
 */
@property (nonatomic, copy) NSString *levelMsg;
/**
 *试卷ID
 */
@property (nonatomic, strong) NSNumber *testId;
/**
 *考试名称
 */
@property (nonatomic, copy) NSString *examActivityName;
/**
 *用于跳转到某个页面
 */
@property (nonatomic, copy) NSString *toPage;
/**
 *提示
 */
@property (nonatomic, copy) NSString *tip;
/**
 *超过百分比
 */
@property (nonatomic, copy) NSString *overPercent;
/**
 *查看试卷
 */
@property (nonatomic, strong) NSMutableArray *resultList;
@property (nonatomic, assign) CSExamResultIsPassType examResultType;
@end
