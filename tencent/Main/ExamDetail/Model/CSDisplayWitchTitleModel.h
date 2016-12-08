//
//  CSDisplayWitchTitleModel.h
//  tencent
//
//  Created by cyh on 16/8/10.
//  Copyright © 2016年 cyh. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CSStudyCaseDetailModel.h"
#import "CSGlobalMacro.h"
@interface CSDisplayWitchTitleModel : NSObject

+ (NSString *)passTitleWithCaseDetailModel:(CSStudyCaseDetailModel *)caseDetailModel;
@end
