//
//  CSExamContentViewController.h
//  tencent
//
//  Created by bill on 16/5/9.
//  Copyright © 2016年 cyh. All rights reserved.
//

#import "CSBaseViewController.h"
#import "CSUrl.h"
#import "CSHttpRequestManager.h"
#import "CSExamRadioViewController.h"
#import "CSMultiChoiceViewController.h"
#import "CSParserExamDataModel.h"
#import "CSExaminationPaperModel.h"
#import "CSFrameConfig.h"
#import "CSRadioModel.h"
#import "CSGlobalMacro.h"
#import "CSExamResultViewController.h"
@interface CSExamContentViewController : CSBaseViewController

/**
 *  资源Id （成绩id）
 */
@property (nonatomic, copy) NSString *resourceId;
/**
 *  试卷Id
 */
@property (nonatomic, strong) NSNumber *testId;
/**
 *  课程或者考试成绩id
 */
@property (nonatomic, strong) NSNumber *examActivityId;
/**
 *点击考试考试返回的考试成绩id
 */
@property (nonatomic, strong) NSNumber *actTestAttId;
/**
 *历史成绩id
 */
@property (nonatomic, strong) NSNumber *actTestHistoryId;
/**
 *历史成绩id
 */
@property (nonatomic, strong)NSNumber *startTimestamp;

/**
 *考试类别   0-待填写列表（默认），1-再来一次列表，2-全部答案列表，3-看错题列表，4-看对题列表
 */
@property (nonatomic, strong) NSNumber *examType;
/**
 *是否可以提交答案
 */
@property (nonatomic, strong) NSNumber *canTest;
/**
 *点击是哪个cell（从前一界面传过来）
 */
@property (nonatomic, assign) NSInteger whichRow;

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
@end
