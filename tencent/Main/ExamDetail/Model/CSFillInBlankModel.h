//
//  CSFillInBlankModel.h
//  tencent
//
//  Created by bill on 16/5/20.
//  Copyright © 2016年 cyh. All rights reserved.
//

#import "CSBaseModel.h"

/*       *********** 选项答案相关信息 **************** */
@interface CSChoiceOptionTitleModel : CSBaseModel

/**
 *  用户填写的答案
 */
@property (nonatomic, strong) NSArray *choiceAnswer;

@end
/*       *********** ************* **************** */


/*       *********** 选项具体信息 **************** */
@interface CSChoiceOptionContentModel : CSBaseModel

/**
 *  选项Id
 */
@property (nonatomic, strong) NSNumber *chopId;

/**
 *  选项编号
 */
@property (nonatomic, strong) NSString *chopLabel;

/**
 *  正确答案 0:否 1:是  填空题返回为Null
 */
@property (nonatomic, strong) NSNumber *correct;

/**
 *  填空正确答案
 */
@property (nonatomic, strong) NSString *correctFill;

/**
 *  选项内容
 */
@property (nonatomic, strong) NSString *chopText;

@end
/*       *********** ************* **************** */


/*       *********** 试题信息 **************** */
@interface CSFillInBlankModel : CSBaseModel

/**
 *  题目Id
 */
@property (nonatomic, strong) NSNumber *questionId;

/**
 *  题目类型
 */
@property (nonatomic, strong) NSString *qtype;

/**
 *  题目分数
 */
@property (nonatomic, strong) NSNumber *score;

/**
 *  题目标题
 */
@property (nonatomic, strong) NSString *name;

/**
 *  题目内容
 */
@property (nonatomic, strong) NSString *text;

/**
 *  用户答案
 */
@property (nonatomic, strong) NSString *answer;

/**
 *  正确答案
 */
@property (nonatomic, strong) NSString *correct;

/**
 *  专家观点
 */
@property (nonatomic, strong) NSString *expertsOpinion;

/**
 *  选项信息
 */
@property (nonatomic, strong) NSMutableDictionary *choiceOptionDic;

@end
