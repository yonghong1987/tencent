//
//  TencentCourseDetail+CoreDataProperties.h
//  tencent
//
//  Created by duck on 2016/11/28.
//  Copyright © 2016年 cyh. All rights reserved.
//

#import "TencentCourseDetail+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface TencentCourseDetail (CoreDataProperties)

+ (NSFetchRequest<TencentCourseDetail *> *)fetchRequest;

@property (nonatomic) int64_t userId;
@property (nonatomic) int32_t courseId;
@property (nonatomic) int32_t projectId;
@property (nullable, nonatomic, retain) NSObject *jsonData;

@end

NS_ASSUME_NONNULL_END
