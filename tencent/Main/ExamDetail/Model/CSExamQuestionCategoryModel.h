//
//  CSExamQuestionCategoryModel.h
//  tencent
//
//  Created by bill on 16/5/23.
//  Copyright © 2016年 cyh. All rights reserved.
//

#import "CSBaseModel.h"
#import "CSFillInBlankModel.h"

@interface CSExamQuestionCategoryModel : CSBaseModel

/**
 *  大题Id
 */
@property (nonatomic, strong) NSNumber *categoryId;

/**
 *  大题类型
 */
@property (nonatomic, strong) NSString *questionType;

/**
 *  大题标题
 */
@property (nonatomic, strong) NSString *questionTypeText;

/**
 *  是否隐藏大题标题 0-否，1-是
 */
@property (nonatomic, strong) NSNumber *displayTitle;

/**
 *  大题总分
 */
@property (nonatomic, strong) NSNumber *totalScore;

/**
 *  大题得分
 */
@property (nonatomic, strong) NSNumber *finalScore;

/**
 *  小题列表
 */
@property (nonatomic, strong) NSMutableArray *questionList;

@end
