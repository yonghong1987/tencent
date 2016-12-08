//
//  CSProjectModel.m
//  tencent
//
//  Created by sunon002 on 16/4/21.
//  Copyright © 2016年 cyh. All rights reserved.
//

#import "CSProjectModel.h"
#import "NSDictionary+convenience.h"
#import "CSImagePath.h"
#import "CSBannerModel.h"
#import "CSCourseModel.h"
@implementation CSProjectModel

-(instancetype)initWithDictionary:(NSDictionary *)dict error:(NSError *__autoreleasing *)err{
    self = [super initWithDictionary:dict error:err];
    if (self) {
        self.img = [CSImagePath getImageUrl:[dict stringForKey:@"img"]];
    }
    return self;
}

@end
