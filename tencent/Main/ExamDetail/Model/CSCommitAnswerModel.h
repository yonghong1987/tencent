//
//  CSCommitAnswerModel.h
//  tencent
//
//  Created by cyh on 16/8/22.
//  Copyright © 2016年 cyh. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CSGlobalMacro.h"
#import "CSExaminationPaperModel.h"
@interface CSCommitAnswerModel : NSObject
+ (NSMutableDictionary *)getCommitAnswerDictionaryWithExaminationPaper:(CSExaminationPaperModel *)examinationPaperModel;
+ (void)removeDicKey;
@end
