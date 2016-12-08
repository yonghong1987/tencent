//
//  CSExamResultModel.m
//  tencent
//
//  Created by cyh on 16/8/16.
//  Copyright © 2016年 cyh. All rights reserved.
//

#import "CSExamResultModel.h"

@implementation CSExamResultModel

-(instancetype)initWithDictionary:(NSDictionary *)dict error:(NSError *__autoreleasing *)err{
    if (self = [super initWithDictionary:dict error:err]) {
        NSString *passStatus = [dict objectForKey:@"status"];
        if ([passStatus isEqualToString:@"P"]) {
            self.examResultType = CSExamPassType;
        }else if ([passStatus isEqualToString:@"F"]){
        self.examResultType = CSExamNoPassType;
        }
    }
    return self;
}
@end
