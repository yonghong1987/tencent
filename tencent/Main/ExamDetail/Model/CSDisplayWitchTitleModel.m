//
//  CSDisplayWitchTitleModel.m
//  tencent
//
//  Created by cyh on 16/8/10.
//  Copyright © 2016年 cyh. All rights reserved.
//

#import "CSDisplayWitchTitleModel.h"

@implementation CSDisplayWitchTitleModel


+ (NSString *)passTitleWithCaseDetailModel:(CSStudyCaseDetailModel *)caseDetailModel{
    NSString *string = @"";
    if ([caseDetailModel.caseQuestionType isEqualToString:kTopicQuestionType]) {
        string = @"问答题";
    }else if ([caseDetailModel.caseQuestionType isEqualToString:kTopicSingleType]){
        string = @"单选题";
    }else if ([caseDetailModel.caseQuestionType isEqualToString:kTopicNoItemType]){
        string = @"不定项题";
    }else if ([caseDetailModel.caseQuestionType isEqualToString:kTopicMultiSelectType]){
        string = @"多选题";
    }else if ([caseDetailModel.caseQuestionType isEqualToString:kTopicJudgeType]){
        string = @"判断题";
    }else if ([caseDetailModel.caseQuestionType isEqualToString:kTopicFillType]){
        string = @"判断题";
    }
    return string;
}
@end
