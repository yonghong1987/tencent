//
//  CSStudyCaseDetailModel.h
//  tencent
//
//  Created by admin on 16/5/18.
//  Copyright © 2016年 cyh. All rights reserved.
//

#import "CSBaseModel.h"

@interface CSStudyCaseDetailModel : CSBaseModel

/**
 *  案列id
 */
@property (nonatomic, strong) NSNumber *caseId;
/**
 *案列名称
 */
@property (nonatomic, copy) NSString *caseName;
/**
 *试题题干
 */
@property (nonatomic, copy) NSString *caseQuestionTitle;
/**
 *试题内容
 */
@property (nonatomic, copy) NSString *caseQuestionUrl;
/**
 *案列开始时间
 */
@property (nonatomic, copy) NSString *answerStartDateTime;
/**
 *案列结束时间
 */
@property (nonatomic, copy) NSString *answerEndDateTime;
/**
 *案列专家观点
 */
@property (nonatomic, copy) NSString *viewPoint;
/**
 *案列是否已提交
 */
@property (nonatomic, strong) NSNumber *alreadySubmit;
/**
 *案列是否已过期
 */
@property (nonatomic, strong) NSNumber *alreadyOverTime;
/**
 *案列类型
 */
@property (nonatomic, strong) NSNumber *caseType;
/**
 *回答是否正确
 */
@property (nonatomic, strong) NSNumber *isCorrect;

/**
 *  案列选择题、判断题选项数组
 */
@property (nonatomic, strong) NSMutableArray *optionArray;
/**
 *  案列题型
 */
@property (nonatomic, copy) NSString *caseQuestionType;
/**
 *  评论数组
 */
@property (nonatomic, strong) NSMutableArray *commments;
/**
 *案列图片数组
 */
@property (nonatomic, strong) NSMutableArray *imageArr;
/**
 *  正确答案
 */
@property (nonatomic, copy) NSString *correctAnswer;
/**
 *用户选择的答案
 */
@property (nonatomic, copy) NSString *userAnswer;
/**
 *  评论个数
 */
@property (nonatomic, strong) NSNumber *commentCount;
@end
