//
//  CSSpecialListModel.m
//  tencent
//
//  Created by admin on 16/5/3.
//  Copyright © 2016年 cyh. All rights reserved.
//

#import "CSSpecialListModel.h"
#import "NSDictionary+convenience.h"
#import "CSImagePath.h"
@implementation CSSpecialListModel


-(instancetype)initWithDictionary:(NSDictionary *)dict error:(NSError *__autoreleasing *)err{
    if (self = [super initWithDictionary:dict error:err]) {
        self.thumbnail = [CSImagePath noEncodeingImageUrl:[dict stringForKey:@"thumbnail"]];
    }
    return self;
}
@end
