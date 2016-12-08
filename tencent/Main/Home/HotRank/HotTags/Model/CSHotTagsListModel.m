//
//  CSHotTagsListModel.m
//  tencent
//
//  Created by bill on 16/4/28.
//  Copyright © 2016年 cyh. All rights reserved.
//

#import "CSHotTagsListModel.h"
#import "CSImagePath.h"

@implementation CSHotTagsListModel

-(instancetype)initWithDictionary:(NSDictionary *)dict error:(NSError *__autoreleasing *)err{
    self = [super initWithDictionary:dict error:err];
    if (self) {
        self.img = [CSImagePath getImageUrl:[dict objectForKey:@"img"]];
    }
    return self;
}

@end
