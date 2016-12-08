//
//  CSAskAndAnswerModel.h
//  tencent
//
//  Created by cyh on 16/8/16.
//  Copyright © 2016年 cyh. All rights reserved.
//

#import "CSBaseModel.h"

@interface CSAskAndAnswerModel : CSBaseModel
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
 **题目内容
 */
@property (nonatomic, copy) NSString *questionHtml;
/**
 *用户回答的答案
 */
@property (nonatomic, copy) NSString *userAnswerText;
@end
