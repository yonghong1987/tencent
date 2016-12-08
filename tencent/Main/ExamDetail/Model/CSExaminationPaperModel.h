//
//  CSExaminationPaperModel.h
//  tencent
//
//  Created by admin on 16/5/17.
//  Copyright © 2016年 cyh. All rights reserved.
//

#import "CSBaseModel.h"
#import "CSExamResultModel.h"

@interface CSExaminationPaperModel : CSBaseModel
/**
 *考试成绩对象
 */
@property (nonatomic, strong) CSExamResultModel *examResultModel;
/**
 *大题对象数组
 */
@property (nonatomic, strong) NSMutableArray *bigTitleModelArray;
/**
 *大题id拼接成的字符串
 */
@property (nonatomic, copy) NSString *bigTitleIdString;
//所有的试题对象数组
@property (nonatomic, strong) NSMutableArray *allTitleArray;

//大题中的小题拼接而成的id
//单选题拼成的id字符串
@property (nonatomic, copy) NSString *smallSingleIdString;
//多选题拼成的id字符串
@property (nonatomic, copy) NSString *smallMultiseIdString;
//不定项选题拼成的id字符串
@property (nonatomic, copy) NSString *smallNoItemIdString;
//判断题拼成的id字符串
@property (nonatomic, copy) NSString *smallJudgeIdString;
//问答题拼成的id字符串
@property (nonatomic, copy) NSString *smallQuestionIdString;
//填空题拼成的id字符串
@property (nonatomic, copy) NSString *smallFillIdString;
@end
