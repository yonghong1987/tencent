//
//  CSCourseListModel.m
//  tencent
//
//  Created by bill on 16/4/27.
//  Copyright © 2016年 cyh. All rights reserved.
//

#import "CSCourseListModel.h"
#import "CSImagePath.h"

@implementation CSCourseListModel

-(instancetype)initWithDictionary:(NSDictionary *)dict error:(NSError *__autoreleasing *)err{
    self = [super initWithDictionary:dict error:err];
    if (self) {
        
        self.thumbnail = [CSImagePath getImageUrl:[dict objectForKey:@"thumbnail"]];
    }
    return self;
}


@end
