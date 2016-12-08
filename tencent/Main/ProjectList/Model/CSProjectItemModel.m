//
//  CSProjectItemModel.m
//  tencent
//
//  Created by bill on 16/7/29.
//  Copyright © 2016年 cyh. All rights reserved.
//

#import "CSProjectItemModel.h"
#import "CSImagePath.h"

@implementation CSProjectItemModel

-(instancetype)initWithDictionary:(NSDictionary *)dict error:(NSError *__autoreleasing *)err{
    if (self = [super initWithDictionary:dict error:err]) {
        self.img = [CSImagePath noEncodeingImageUrl:dict[@"img"]];
    }
    return self;
}
@end
