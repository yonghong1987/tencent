//
//  CSCourseModel.m
//  tencent
//
//  Created by sunon002 on 16/4/27.
//  Copyright © 2016年 cyh. All rights reserved.
//

#import "CSCourseModel.h"
#import "NSDictionary+convenience.h"
@implementation CSCourseModel


-(instancetype)initWithDictionary:(NSDictionary *)dict error:(NSError *__autoreleasing *)err{
    if (self = [super initWithDictionary:dict error:err]) {
        
    }
    return self;
}

//- (instancetype)initWithDictionary:(NSDictionary *)dictionary{
//    if (self = [super init]) {
//        self.courseid = [NSString stringWithFormat:@"%d",[dictionary intForKey:@"id"]];
//        self.courseName = [dictionary stringForKey:@"name"];
//        self.courseRescode = [dictionary stringForKey:@"rescode"];
//    }
//    return self;
//}
@end
