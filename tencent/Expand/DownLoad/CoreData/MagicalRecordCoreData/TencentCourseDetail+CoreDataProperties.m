//
//  TencentCourseDetail+CoreDataProperties.m
//  tencent
//
//  Created by duck on 2016/11/28.
//  Copyright © 2016年 cyh. All rights reserved.
//

#import "TencentCourseDetail+CoreDataProperties.h"

@implementation TencentCourseDetail (CoreDataProperties)

+ (NSFetchRequest<TencentCourseDetail *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"TencentCourseDetail"];
}

@dynamic userId;
@dynamic courseId;
@dynamic jsonData;
@dynamic projectId;
@end
