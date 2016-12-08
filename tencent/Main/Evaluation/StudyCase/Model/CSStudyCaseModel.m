//
//  CSStudyCaseModel.m
//  tencent
//
//  Created by admin on 16/5/12.
//  Copyright © 2016年 cyh. All rights reserved.
//

#import "CSStudyCaseModel.h"
#import "CSImagePath.h"
#import "NSDictionary+convenience.h"
@implementation CSStudyCaseModel


#pragma mark  重写父类的方法
- (instancetype)initWithDictionary:(NSDictionary *)dict error:(NSError *__autoreleasing *)err
{
    self = [super initWithDictionary:dict error:err];
    if (self) {
        self.caseImg = [CSImagePath getImageUrl:[dict stringForKey:@"caseImg"]];
    }
    return self;
}


@end
