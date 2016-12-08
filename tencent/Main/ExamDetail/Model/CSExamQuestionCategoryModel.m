//
//  CSExamQuestionCategoryModel.m
//  tencent
//
//  Created by bill on 16/5/23.
//  Copyright © 2016年 cyh. All rights reserved.
//

#import "CSExamQuestionCategoryModel.h"

@implementation CSExamQuestionCategoryModel

- (id)initWithDictionary:(NSDictionary *)dict error:(NSError *__autoreleasing *)err{
    self = [super initWithDictionary:dict error:err];
    if ( self ) {
        
        id questionList = [dict objectForKey:@"questionList"];
        self.questionList = [NSMutableArray array];
        
        for ( NSDictionary *questionDic in questionList ) {
            [self.questionList addObject:[[CSFillInBlankModel alloc] initWithDictionary:questionDic error:nil]];
        }
    }
    return self;
}

@end
