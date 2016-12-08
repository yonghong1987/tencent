//
//  CSStudySkillModel.m
//  tencent
//
//  Created by admin on 16/5/16.
//  Copyright © 2016年 cyh. All rights reserved.
//

#import "CSStudySkillModel.h"
#import "NSDictionary+convenience.h"
@implementation CSStudySkillModel

#pragma mark  重写父类的方法
- (instancetype)initWithDictionary:(NSDictionary *)dict error:(NSError *__autoreleasing *)err
{
    self = [super initWithDictionary:dict error:err];
    if (self) {
        NSString *courseTypeStr = [dict objectForKey:@"type"];
        if ([courseTypeStr isEqualToString:@"PRECOURSE"]) {
            self.courseExamType = CSPrecourseExamType;
        }else if ([courseTypeStr isEqualToString:@"AFCOURSE"]){
            self.courseExamType = CSAftercourseExamType;
        }
    }
    return self;
}


@end
