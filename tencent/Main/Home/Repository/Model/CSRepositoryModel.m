//
//  CSRepositoryModel.m
//  tencent
//
//  Created by bill on 16/4/27.
//  Copyright © 2016年 cyh. All rights reserved.
//

#import "CSRepositoryModel.h"
#import "CSImagePath.h"

@implementation CSRepositoryModel


- (instancetype)initWithDictionary:(NSDictionary *)dict error:(NSError *__autoreleasing *)err{
    self = [super initWithDictionary:dict error:err];
    _img = [CSImagePath noEncodeingImageUrl:[dict objectForKey:@"img"]];
    return self;
}
@end
