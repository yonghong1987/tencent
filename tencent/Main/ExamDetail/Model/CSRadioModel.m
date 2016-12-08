//
//  CSRadioModel.m
//  tencent
//
//  Created by admin on 16/5/17.
//  Copyright © 2016年 cyh. All rights reserved.
//

#import "CSRadioModel.h"
#import "NSDictionary+convenience.h"
@implementation CSRadioModel

-(instancetype)initWithDictionary:(NSDictionary *)dict error:(NSError *__autoreleasing *)err{
    self.dataArr = [NSMutableArray array];
    if (self = [super initWithDictionary:dict error:err]) {
        
    }
    return self;
}

@end
