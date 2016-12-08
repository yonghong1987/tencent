//
//  CSHotCourseListModel.m
//  tencent
//
//  Created by bill on 16/4/28.
//  Copyright © 2016年 cyh. All rights reserved.
//

#import "CSHotCourseListModel.h"
#import "CSImagePath.h"

@implementation CSHotCourseListModel

-(instancetype)initWithDictionary:(NSDictionary *)dict error:(NSError *__autoreleasing *)err{
    self = [super initWithDictionary:dict error:err];
    if (self) {
        
        self.thumbnail = [CSImagePath getImageUrl:[dict objectForKey:@"thumbnail"]];
    }
    return self;
}

@end
