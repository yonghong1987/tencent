//
//  CSParserExamDataModel.h
//  tencent
//
//  Created by cyh on 16/8/16.
//  Copyright © 2016年 cyh. All rights reserved.
//

#import "CSBaseModel.h"
#import "CSExaminationPaperModel.h"
@interface CSParserExamDataModel : CSBaseModel

+ (CSExaminationPaperModel *)parserExamPaperDataWithDictionary:(NSDictionary *)dictionary;

+ (NSNumber *)getCanAnswerDataWithDictionary:(NSDictionary *)dictionary;
+ (NSNumber *)getDisplayAnswerDataWithDictionary:(NSDictionary *)dictionary;
@end
