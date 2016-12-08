//
//  CSRadioModel.h
//  tencent
//
//  Created by admin on 16/5/17.
//  Copyright © 2016年 cyh. All rights reserved.
//

#import "CSBaseModel.h"

@interface CSRadioModel : CSBaseModel
/**
 *该小题所在的大题id
 */
@property (nonatomic, strong) NSNumber *bigTitleId;
/*
 **题目id
 */
@property (nonatomic, strong) NSNumber *questionId;
/*
 **题目类型（单选题）  字母表示
 */
@property (nonatomic, copy) NSString *questionType;
/*
 **用户选择是否正确
 */
@property (nonatomic, strong) NSNumber *questionCorrect;
/*
 **题目标题
 */
@property (nonatomic, copy) NSString *questionText;
/*
 **用户的答案
 */
@property (nonatomic, copy) NSString *questionAnswer;
/*
 **用户选择的选项id
 */
@property (nonatomic, copy) NSString *chopIds;

/*
 **选项数组（选择题包含的选项）
 */
@property (nonatomic, strong) NSMutableArray *questionOptions;
/*
 **题目内容
 */
@property (nonatomic, copy) NSString *questionHtml;
/**
 *专家观点
 */
@property (nonatomic, copy) NSString *viewPoint;
/**
 *用户回答的答案
 */
@property (nonatomic, copy) NSString *userAnswerText;
/**
 *将各个选项id拼接成一个字符串
 */
@property (nonatomic, copy) NSString *optionTotalString;
/**
 *该题在大题中的序号
 */
@property (nonatomic, assign) NSInteger titleIndex;


/**
 *解析时，给该题自定义答案key
 */
@property (nonatomic, copy) NSString *answerKey;
/**
 *解析时，给该题自定义答案value
 */
@property (nonatomic, copy) NSString *answerValue;
//填空题    用户填写的答案
@property (nonatomic, strong) NSMutableArray *dataArr;
@end
