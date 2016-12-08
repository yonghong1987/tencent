//
//  CSParserExamDataModel.m
//  tencent
//
//  Created by cyh on 16/8/16.
//  Copyright © 2016年 cyh. All rights reserved.
//

#import "CSParserExamDataModel.h"
#import "CSExamResultModel.h"
#import "CSBigTitleModel.h"
#import "CSRadioModel.h"
#import "CSOptionModel.h"
#import "CSBigTitleModel.h"
#import "CSGlobalMacro.h"
#import "CSOptionModel.h"
#import "CSAskAndAnswerModel.h"
#import "NSDictionary+convenience.h"
#import "CSSingleOrNoItemAnswerModel.h"
#import "CSFillOptionModel.h"
@implementation CSParserExamDataModel

-(instancetype)initWithDictionary:(NSDictionary *)dict error:(NSError *__autoreleasing *)err{
    if (self = [super initWithDictionary:dict error:err]) {
        
    }
    return self;
}

+ (NSNumber *)getCanAnswerDataWithDictionary:(NSDictionary *)dictionary{
    NSDictionary *entityDic = dictionary[@"examActivityEntity"];
    return entityDic[@"canAnswer"];
}

+ (NSNumber *)getDisplayAnswerDataWithDictionary:(NSDictionary *)dictionary{
    NSDictionary *entityDic = dictionary[@"examActivityEntity"];
    return entityDic[@"displayAnswer"];
}

+ (CSExaminationPaperModel *)parserExamPaperDataWithDictionary:(NSDictionary *)dictionary{
    
    //所有大题数组
    NSMutableArray *bigTitleArray = [NSMutableArray array];
    //所有大题id拼接成的字符串
    NSString *bigTitleIdString = @"";
    //解析试卷
    CSExaminationPaperModel *examinationPaperModel = [[CSExaminationPaperModel alloc]initWithDictionary:dictionary error:nil];
    //解析考试成绩对象
    CSExamResultModel *examResultModel = [[CSExamResultModel alloc]initWithDictionary:dictionary[@"examActivityEntity"] error:nil];
    examinationPaperModel.examResultModel = examResultModel;
    //所有的考试题目都加在该数组里面（只加上小题）
    NSMutableArray *examTitleArray = [NSMutableArray array];
    //解析大题对象
    NSArray *bigTitleArr = dictionary[@"catagoryList"];
    for (NSDictionary *bigTitleDic in bigTitleArr) {
        CSBigTitleModel *bigTitleModel = [[CSBigTitleModel alloc]initWithDictionary:bigTitleDic error:nil];
        [examinationPaperModel.bigTitleModelArray addObject:bigTitleModel];
        NSNumber *categoryId = [bigTitleDic numberForKey:@"categoryId"];
        bigTitleIdString = [bigTitleIdString stringByAppendingString:[NSString stringWithFormat:@"%ld~",[categoryId integerValue]]];
        
        //大题型分类
        NSString *bigTitleType = bigTitleDic[@"categoryType"];
        NSArray *smallTitleArr = bigTitleDic[@"questionList"];
        //如果是单选题、多选题、不定项选择
        if ([bigTitleType isEqualToString:kTopicSingleType] || [bigTitleType isEqualToString:kTopicNoItemType] || [bigTitleType isEqualToString:kTopicMultiSelectType]) {
            //如果是单选
            if ([bigTitleType isEqualToString:kTopicSingleType]) {
                NSMutableArray *singleArray = [NSMutableArray array];
                NSString *smallSingleIdString = @"";
                //创建数据库，将该题题号等相关信息保存到本地，修改答案或者提交时，直接取出
                NSString *filePath = [NSHomeDirectory() stringByAppendingPathComponent:kSingleArrayPathType];
                //用于保存每个单选题的答案数组
                 NSMutableArray *examSingleArr = [NSMutableArray array];
                for (NSDictionary *smallTitleDic in smallTitleArr) {
                    CSRadioModel *radioModel = [[CSRadioModel alloc]initWithDictionary:smallTitleDic error:nil];
                    NSInteger index = [smallTitleArr indexOfObject:smallTitleDic];
                    radioModel.titleIndex = index + 1;
                    radioModel.bigTitleId = categoryId;
                    smallSingleIdString = [smallSingleIdString stringByAppendingString:[NSString stringWithFormat:@"%ld~",[radioModel.questionId integerValue]]];
                    //解析各选项
                    NSString *optionTotalString = @"";
                    NSArray *optionModels = smallTitleDic[@"chopOptionList"];
                    radioModel.questionOptions = [NSMutableArray array];
                    for (NSDictionary *optionDic in optionModels) {
                        CSOptionModel *optionModel = [[CSOptionModel alloc]initWithDictionary:optionDic error:nil];
                        optionTotalString = [optionTotalString stringByAppendingString:[NSString stringWithFormat:@"%ld,",[optionModel.chopId integerValue]]];
                        [radioModel.questionOptions addObject:optionModel];
                        
                    }
                    if (optionTotalString.length > 0 ) {
                        optionTotalString = [optionTotalString substringWithRange:NSMakeRange(0, optionTotalString.length - 1)];
                    }
                    radioModel.optionTotalString = optionTotalString;
                    //将答案对象封装成字典
                    NSMutableDictionary *examSingleDic = [self getAnswerDicWithRaidoModel:radioModel titleType:kTopicSingleType];
                    [examSingleArr addObject:examSingleDic];
                    [examTitleArray addObject:radioModel];
                    [singleArray addObject:radioModel];
                }
                [bigTitleArray addObjectsFromArray:singleArray];
                if (smallSingleIdString.length > 0 ) {
                    smallSingleIdString = [smallSingleIdString substringWithRange:NSMakeRange(0, smallSingleIdString.length - 1)];
                }
                examinationPaperModel.smallSingleIdString = smallSingleIdString;
                //将数组写入本地数据库
                 [examSingleArr writeToFile:filePath atomically:YES];
            }else if ([bigTitleType isEqualToString:kTopicMultiSelectType]){
                NSString *smallMultiseIdString = @"";
                NSMutableArray *multiSelectArray = [NSMutableArray array];
                //创建数据库，将该题题号等相关信息保存到本地，修改答案或者提交时，直接取出
                NSString *filePath = [NSHomeDirectory() stringByAppendingPathComponent:kMultiArrayPathType];
                //用于保存每个多选题的答案数组
                NSMutableArray *examMultiArr = [NSMutableArray array];
                for (NSDictionary *smallTitleDic in smallTitleArr) {
                    CSRadioModel *radioModel = [[CSRadioModel alloc]initWithDictionary:smallTitleDic error:nil];
                    NSInteger index = [smallTitleArr indexOfObject:smallTitleDic];
                    radioModel.titleIndex = index + 1;
                    radioModel.bigTitleId = categoryId;
                     smallMultiseIdString = [smallMultiseIdString stringByAppendingString:[NSString stringWithFormat:@"%ld~",[radioModel.questionId integerValue]]];
                    radioModel.questionOptions = [NSMutableArray array];
                    //解析各选项
                    NSString *optionTotalString = @"";
                    NSArray *optionModels = smallTitleDic[@"chopOptionList"];
                    for (NSDictionary *optionDic in optionModels) {
                        CSOptionModel *optionModel = [[CSOptionModel alloc]initWithDictionary:optionDic error:nil];
                        optionTotalString = [optionTotalString stringByAppendingString:[NSString stringWithFormat:@"%ld,",[optionModel.chopId integerValue]]];
                        [radioModel.questionOptions addObject:optionModel];
                    }
                    if (optionTotalString.length > 0 ) {
                        optionTotalString = [optionTotalString substringWithRange:NSMakeRange(0, optionTotalString.length - 1)];
                    }
                    radioModel.optionTotalString = optionTotalString;
                    //将答案对象封装成字典
                    NSMutableDictionary *examMultileDic = [self getAnswerDicWithRaidoModel:radioModel titleType:kMultiArrayPathType];
                    [examMultiArr addObject:examMultileDic];
                    [examTitleArray addObject:radioModel];
                    [multiSelectArray addObject:radioModel];
                }
                [bigTitleArray addObjectsFromArray:multiSelectArray];
                if (smallMultiseIdString.length > 0 ) {
                    smallMultiseIdString = [smallMultiseIdString substringWithRange:NSMakeRange(0, smallMultiseIdString.length - 1)];
                }
                examinationPaperModel.smallMultiseIdString = smallMultiseIdString;
                //将数组写入本地数据库
                [examMultiArr writeToFile:filePath atomically:YES];
            }else if ([bigTitleType isEqualToString:kTopicNoItemType]){
                NSString *smallNoItemIdString = @"";
                NSMutableArray *noItemArray = [NSMutableArray array];
                //创建数据库，将该题题号等相关信息保存到本地，修改答案或者提交时，直接取出
                NSString *filePath = [NSHomeDirectory() stringByAppendingPathComponent:kNoItemArrayPathType];
                //用于保存每个多选题的答案数组
                NSMutableArray *examMultiArr = [NSMutableArray array];
                for (NSDictionary *smallTitleDic in smallTitleArr) {
                    CSRadioModel *radioModel = [[CSRadioModel alloc]initWithDictionary:smallTitleDic error:nil];
                    NSInteger index = [smallTitleArr indexOfObject:smallTitleDic];
                    radioModel.titleIndex = index + 1;
                    radioModel.bigTitleId = categoryId;
                     smallNoItemIdString = [smallNoItemIdString stringByAppendingString:[NSString stringWithFormat:@"%ld~",[radioModel.questionId integerValue]]];
                    radioModel.questionOptions = [NSMutableArray array];
                    //解析各选项
                    NSString *optionTotalString = @"";
                    NSArray *optionModels = smallTitleDic[@"chopOptionList"];
                    for (NSDictionary *optionDic in optionModels) {
                        CSOptionModel *optionModel = [[CSOptionModel alloc]initWithDictionary:optionDic error:nil];
                        optionTotalString = [optionTotalString stringByAppendingString:[NSString stringWithFormat:@"%ld,",[optionModel.chopId integerValue]]];
                        [radioModel.questionOptions addObject:optionModel];
                    }
                    if (optionTotalString.length > 0 ) {
                        optionTotalString = [optionTotalString substringWithRange:NSMakeRange(0, optionTotalString.length - 1)];
                    }
                     radioModel.optionTotalString = optionTotalString;
                    //将答案对象封装成字典
                    NSMutableDictionary *examMultileDic = [self getAnswerDicWithRaidoModel:radioModel titleType:kNoItemArrayPathType];
                    [examMultiArr addObject:examMultileDic];
                    [examTitleArray addObject:radioModel];
                    [noItemArray addObject:radioModel];
                }
                [bigTitleArray addObjectsFromArray:noItemArray];
                if (smallNoItemIdString.length > 0 ) {
                    smallNoItemIdString = [smallNoItemIdString substringWithRange:NSMakeRange(0, smallNoItemIdString.length - 1)];
                }
                examinationPaperModel.smallNoItemIdString = smallNoItemIdString;
                //将数组写入本地数据库
                [examMultiArr writeToFile:filePath atomically:YES];
            }
            //如果是填空题
        }else if ([bigTitleType isEqualToString:kTopicFillType]){
            NSMutableArray *fillArray = [NSMutableArray array];
             NSString *smallFillIdString = @"";
            //创建数据库，将该题题号等相关信息保存到本地，修改答案或者提交时，直接取出
            NSString *filePath = [NSHomeDirectory() stringByAppendingPathComponent:kFillArrayPathType];
            //用于保存每个多选题的答案数组
            NSMutableArray *examFillArr = [NSMutableArray array];
            for (NSDictionary *smallTitleDic in smallTitleArr) {
                CSRadioModel *radioModel = [[CSRadioModel alloc]initWithDictionary:smallTitleDic error:nil];
                NSInteger index = [smallTitleArr indexOfObject:smallTitleDic];
                radioModel.titleIndex = index + 1;
                radioModel.bigTitleId = categoryId;
                 smallFillIdString = [smallFillIdString stringByAppendingString:[NSString stringWithFormat:@"%ld~",[radioModel.questionId integerValue]]];
                radioModel.questionOptions = [NSMutableArray array];
                //解析各选项
                NSString *optionTotalString = @"";
                NSArray *optionModels = smallTitleDic[@"chopOptionList"];
                for (NSDictionary *optionDic in optionModels) {
                    CSOptionModel *optionModel = [[CSOptionModel alloc]initWithDictionary:optionDic error:nil];
                    optionTotalString = [optionTotalString stringByAppendingString:[NSString stringWithFormat:@"%ld,",[optionModel.chopId integerValue]]];
                    [radioModel.questionOptions addObject:optionModel];
                }
                if (optionTotalString.length > 0 ) {
                    optionTotalString = [optionTotalString substringWithRange:NSMakeRange(0, optionTotalString.length - 1)];
                }
                radioModel.optionTotalString = optionTotalString;
                [examTitleArray addObject:radioModel];
                [fillArray addObject:radioModel];
                
                NSMutableDictionary *examFillDic = [NSMutableDictionary dictionary];
                NSString *answerKey = [NSString stringWithFormat:@"fill_que_%ld_%ld",[radioModel.bigTitleId integerValue],[radioModel.questionId integerValue]];
                
                radioModel.answerKey = answerKey;
                
                //将每道题的每个空赋值为空字符串
                NSString *fillAnswerString = @"";
                for (int i = 0; i < radioModel.questionOptions.count; i ++) {
                    CSOptionModel *optionModel = radioModel.questionOptions[i];
                    fillAnswerString = [fillAnswerString stringByAppendingString:[NSString stringWithFormat:@"%ld@||",[optionModel.chopId integerValue]]];
                }
                if (fillAnswerString.length > 0) {
                    fillAnswerString = [fillAnswerString substringWithRange:NSMakeRange(0, fillAnswerString.length - 2)];
                }
                NSString *answerValue = [NSString stringWithFormat:@"%@~%@~%@",[NSString stringWithFormat:@"%ld",radioModel.titleIndex],radioModel.optionTotalString,fillAnswerString];
                radioModel.answerValue = answerValue;
                [examFillDic setValue:answerValue forKey:answerKey];
                 [examFillArr addObject:examFillDic];
                
            }
            [bigTitleArray addObjectsFromArray:fillArray];
            if (smallFillIdString.length > 0 ) {
                smallFillIdString = [smallFillIdString substringWithRange:NSMakeRange(0, smallFillIdString.length - 1)];
            }
            examinationPaperModel.smallFillIdString = smallFillIdString;
            //将数组写入本地数据库
            [examFillArr writeToFile:filePath atomically:YES];
            //如果是问答题
        }else if ([bigTitleType isEqualToString:kTopicQuestionType]){
            NSMutableArray *questionArray = [NSMutableArray array];
            NSString *smallQuestionIdString = @"";
            //创建数据库，将该题题号等相关信息保存到本地，修改答案或者提交时，直接取出
            NSString *filePath = [NSHomeDirectory() stringByAppendingPathComponent:kQuestionArrayPathType];
            //用于保存每个问答题的答案数组
            NSMutableArray *examQuestionArr = [NSMutableArray array];
            for (NSDictionary *smallTitleDic in smallTitleArr) {
                CSRadioModel *askAndAnswerModel = [[CSRadioModel alloc]initWithDictionary:smallTitleDic error:nil];
                NSInteger index = [smallTitleArr indexOfObject:smallTitleDic];
                askAndAnswerModel.titleIndex = index + 1;
                askAndAnswerModel.bigTitleId = categoryId;
                 smallQuestionIdString = [smallQuestionIdString stringByAppendingString:[NSString stringWithFormat:@"%ld~",[askAndAnswerModel.questionId integerValue]]];
                [examTitleArray addObject:askAndAnswerModel];
                [questionArray addObject:askAndAnswerModel];
                NSMutableDictionary *examQuestionDic = [NSMutableDictionary dictionary];
                NSString *answerKey = [NSString stringWithFormat:@"word_que_%ld_%ld",[askAndAnswerModel.bigTitleId integerValue],[askAndAnswerModel.questionId integerValue]];
                NSString *answerValue = [NSString stringWithFormat:@"%@~ ",[NSString stringWithFormat:@"%ld",askAndAnswerModel.titleIndex]];
                askAndAnswerModel.answerKey = answerKey;
                askAndAnswerModel.answerValue = answerValue;
                [examQuestionDic setValue:answerValue forKey:answerKey];
                [examQuestionArr addObject:examQuestionDic];
            }
          [bigTitleArray addObjectsFromArray:questionArray];
            if (smallQuestionIdString.length > 0 ) {
                smallQuestionIdString = [smallQuestionIdString substringWithRange:NSMakeRange(0, smallQuestionIdString.length - 1)];
            }
            examinationPaperModel.smallQuestionIdString = smallQuestionIdString;
            //将数组写入本地数据库
            [examQuestionArr writeToFile:filePath atomically:YES];
            //判断题
        }else if ([bigTitleType isEqualToString:kTopicJudgeType]){
            NSMutableArray *judgeArray = [NSMutableArray array];
            NSString *smallJudgeIdString = @"";
            //创建数据库，将该题题号等相关信息保存到本地，修改答案或者提交时，直接取出
            NSString *filePath = [NSHomeDirectory() stringByAppendingPathComponent:kJudgeArrayPathType];
            //用于保存每个单选题的答案数组
            NSMutableArray *examSingleArr = [NSMutableArray array];
            for (NSDictionary *smallTitleDic in smallTitleArr) {
                CSRadioModel *radioModel = [[CSRadioModel alloc]initWithDictionary:smallTitleDic error:nil];
                NSInteger index = [smallTitleArr indexOfObject:smallTitleDic];
                radioModel.titleIndex = index + 1;
                radioModel.bigTitleId = categoryId;
                 smallJudgeIdString = [smallJudgeIdString stringByAppendingString:[NSString stringWithFormat:@"%ld~",[radioModel.questionId integerValue]]];
                radioModel.questionOptions = [NSMutableArray array];
                //解析各选项
                 NSString *optionTotalString = @"";
                NSArray *optionModels = smallTitleDic[@"chopOptionList"];
                for (NSDictionary *optionDic in optionModels) {
                    CSOptionModel *optionModel = [[CSOptionModel alloc]initWithDictionary:optionDic error:nil];
                    optionTotalString = [optionTotalString stringByAppendingString:[NSString stringWithFormat:@"%ld,",[optionModel.chopId longValue]]];
                    [radioModel.questionOptions addObject:optionModel];
                }
                if (optionTotalString.length > 0 ) {
                    optionTotalString = [optionTotalString substringWithRange:NSMakeRange(0, optionTotalString.length - 1)];
                }
                 radioModel.optionTotalString = optionTotalString;
                //将答案对象封装成字典
                NSMutableDictionary *examSingleDic = [self getAnswerDicWithRaidoModel:radioModel titleType:kJudgeArrayPathType];
                [examSingleArr addObject:examSingleDic];
                [examTitleArray addObject:radioModel];
                [judgeArray addObject:radioModel];
            }
            [bigTitleArray addObjectsFromArray:judgeArray];
            if (smallJudgeIdString.length > 0 ) {
                smallJudgeIdString = [smallJudgeIdString substringWithRange:NSMakeRange(0, smallJudgeIdString.length - 1)];
            }
            examinationPaperModel.smallJudgeIdString = smallJudgeIdString;
            //将数组写入本地数据库
            [examSingleArr writeToFile:filePath atomically:YES];
        }
    }
    if (bigTitleIdString.length > 0 ) {
        bigTitleIdString = [bigTitleIdString substringWithRange:NSMakeRange(0, bigTitleIdString.length - 1)];
    }
    examinationPaperModel.bigTitleIdString = bigTitleIdString;
    examinationPaperModel.bigTitleModelArray = bigTitleArray;
    examinationPaperModel.allTitleArray = examTitleArray;
    return examinationPaperModel;
}


+(NSMutableDictionary *)getAnswerDicWithRaidoModel:(CSRadioModel *)radioModel titleType:(NSString *)type{
    NSMutableDictionary *examSingleDic = [NSMutableDictionary dictionary];
    NSString *answerKey = @"";
    if ([type isEqualToString:kTopicSingleType]) {
        answerKey = [NSString stringWithFormat:@"sin_que_%ld_%ld",[radioModel.bigTitleId integerValue],[radioModel.questionId integerValue]];
    }else if ([type isEqualToString:kMultiArrayPathType]){
    answerKey = [NSString stringWithFormat:@"multi_que_%ld_%ld",[radioModel.bigTitleId integerValue],[radioModel.questionId integerValue]];
    }else if ([type isEqualToString:kNoItemArrayPathType]){
        answerKey = [NSString stringWithFormat:@"unmu_que_%ld_%ld",[radioModel.bigTitleId integerValue],[radioModel.questionId integerValue]];
    }else if ([type isEqualToString:kJudgeArrayPathType]){
        answerKey = [NSString stringWithFormat:@"jurge_que_%ld_%ld",[radioModel.bigTitleId integerValue],[radioModel.questionId integerValue]];
    }
    
    radioModel.answerKey = answerKey;
    NSString *answerValue = [NSString stringWithFormat:@"%@~%@~",[NSString stringWithFormat:@"%ld",radioModel.titleIndex],radioModel.optionTotalString];
    radioModel.answerValue = answerValue;
    [examSingleDic setValue:answerValue forKey:answerKey];
    return examSingleDic;
}
@end
