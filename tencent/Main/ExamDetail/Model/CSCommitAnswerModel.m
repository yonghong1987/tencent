//
//  CSCommitAnswerModel.m
//  tencent
//
//  Created by cyh on 16/8/22.
//  Copyright © 2016年 cyh. All rights reserved.
//

#import "CSCommitAnswerModel.h"

@implementation CSCommitAnswerModel

+ (NSMutableDictionary *)getCommitAnswerDictionaryWithExaminationPaper:(CSExaminationPaperModel *)examinationPaperModel{
    NSMutableDictionary *answerDic = [NSMutableDictionary dictionary];
    //得到单选题
     NSString *singleFilePath = [NSHomeDirectory() stringByAppendingPathComponent:kSingleArrayPathType];
    NSArray *singleArray = [NSMutableArray arrayWithContentsOfFile:singleFilePath];
    for (NSDictionary *singleDic in singleArray) {
        [answerDic setValue:singleDic.allValues[0] forKey:singleDic.allKeys[0]];
    }
    
    //得到多选题
    NSString *multiFilePath = [NSHomeDirectory() stringByAppendingPathComponent:kMultiArrayPathType];
    NSArray *multiArray = [NSMutableArray arrayWithContentsOfFile:multiFilePath];
    for (NSDictionary *multiDic in multiArray) {
        [answerDic setValue:multiDic.allValues[0] forKey:multiDic.allKeys[0]];
    }
    
    //得到不定项选题
    NSString *noItemFilePath = [NSHomeDirectory() stringByAppendingPathComponent:kNoItemArrayPathType];
    NSArray *noItemArray = [NSMutableArray arrayWithContentsOfFile:noItemFilePath];
    for (NSDictionary *noitemDic in noItemArray) {
        [answerDic setValue:noitemDic.allValues[0] forKey:noitemDic.allKeys[0]];
    }
    //得到判断题
    NSString *judgeFilePath = [NSHomeDirectory() stringByAppendingPathComponent:kJudgeArrayPathType];
    NSArray *judgeArray = [NSMutableArray arrayWithContentsOfFile:judgeFilePath];
    for (NSDictionary *judgeDic in judgeArray) {
        [answerDic setValue:judgeDic.allValues[0] forKey:judgeDic.allKeys[0]];
    }
    //得到问答题
    NSString *questionFilePath = [NSHomeDirectory() stringByAppendingPathComponent:kQuestionArrayPathType];
    NSArray *questionArray = [NSMutableArray arrayWithContentsOfFile:questionFilePath];
    for (NSDictionary *questionDic in questionArray) {
        [answerDic setValue:questionDic.allValues[0] forKey:questionDic.allKeys[0]];
    }
    //得到填空题
    NSString *fillFilePath = [NSHomeDirectory() stringByAppendingPathComponent:kFillArrayPathType];
    NSArray *fillArray = [NSMutableArray arrayWithContentsOfFile:fillFilePath];
    for (NSDictionary *fillDic in fillArray) {
        [answerDic setValue:fillDic.allValues[0] forKey:fillDic.allKeys[0]];
    }
    //将试卷信息加入到字典中
    [answerDic setValue:examinationPaperModel.bigTitleIdString forKey:@"categoryIds"];
    [answerDic setValue:examinationPaperModel.smallSingleIdString forKey:@"singleSelectInputs"];
    [answerDic setValue:examinationPaperModel.smallMultiseIdString forKey:@"multiSelectInputs"];
    [answerDic setValue:examinationPaperModel.smallNoItemIdString forKey:@"unmuSelectInputs"];
    [answerDic setValue:examinationPaperModel.smallFillIdString forKey:@"fillBlankInputs"];
    [answerDic setValue:examinationPaperModel.smallQuestionIdString forKey:@"wordInputs"];
    [answerDic setValue:examinationPaperModel.smallJudgeIdString forKey:@"jurgeInputs"];
    return answerDic;
}


+ (void)removeDicKey{
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *fillFilePath = [NSHomeDirectory() stringByAppendingPathComponent:kQuestionPath];
    
    if ([fileManager fileExistsAtPath:fillFilePath]) {
        NSError *error;
        [fileManager removeItemAtPath:fillFilePath error:&error];
    }
    
     NSString *fillFilePath2 = [NSHomeDirectory() stringByAppendingPathComponent:kFillPath];
    if ([fileManager fileExistsAtPath:fillFilePath2]) {
        NSError *error;
        [fileManager removeItemAtPath:fillFilePath2 error:&error];
    }
}
@end
