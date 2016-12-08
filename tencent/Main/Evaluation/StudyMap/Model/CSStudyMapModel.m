//
//  CSStudyMapModel.m
//  tencent
//
//  Created by admin on 16/5/16.
//  Copyright © 2016年 cyh. All rights reserved.
//

#import "CSStudyMapModel.h"

#import "CSImagePath.h"
#import "NSDictionary+convenience.h"
@implementation CSStudyMapModel


#pragma mark  重写父类的方法
- (instancetype)initWithDictionary:(NSDictionary *)dict error:(NSError *__autoreleasing *)err
{
    self = [super initWithDictionary:dict error:err];
    if (self) {
        self.img = [CSImagePath getImageUrl:[dict stringForKey:@"img"]];
        self.cartoon = [CSImagePath getImageUrl:[dict stringForKey:@"cartoon"]];
    }
    return self;
}

@end
