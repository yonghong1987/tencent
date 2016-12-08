//
//  CSCheckPointModel.m
//  tencent
//
//  Created by cyh on 16/8/3.
//  Copyright © 2016年 cyh. All rights reserved.
//

#import "CSCheckPointModel.h"
#import "CSImagePath.h"
#import "NSDictionary+convenience.h"
@implementation CSCheckPointModel

-(instancetype)initWithDictionary:(NSDictionary *)dict error:(NSError *__autoreleasing *)err{
    if (self = [super initWithDictionary:dict error:err]) {
        self.backgroundImg = [CSImagePath getImageUrl:[dict stringForKey:@"backgroundImg"]];
         self.fcartoon = [CSImagePath getImageUrl:[dict stringForKey:@"fcartoon"]];
         self.cartoon = [CSImagePath getImageUrl:[dict stringForKey:@"cartoon"]];
    }
    return self;
}
@end
