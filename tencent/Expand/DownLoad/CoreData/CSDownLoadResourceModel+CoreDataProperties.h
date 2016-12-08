//
//  CSDownLoadResourceModel+CoreDataProperties.h
//  tencent
//
//  Created by bill on 16/5/18.
//  Copyright © 2016年 cyh. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "CSDownLoadResourceModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface CSDownLoadResourceModel (CoreDataProperties)

@property (nullable, nonatomic, retain) NSNumber *download_type;
@property (nullable, nonatomic, retain) NSNumber *downLoadProgress;
@property (nullable, nonatomic, retain) NSString *endDate;
@property (nullable, nonatomic, retain) NSString *startDate;
@property (nullable, nonatomic, retain) NSString *resourceContent;
@property (nullable, nonatomic, retain) NSString *resourceDescription;
@property (nullable, nonatomic, retain) NSNumber *resourceId;
@property (nullable, nonatomic, retain) NSString *resName;
@property (nullable, nonatomic, retain) NSString *resourceType;
@property (nullable, nonatomic, retain) NSString *resourceUrl;
@property (nullable, nonatomic, retain) NSString *resourceViewAmount;
@property (nullable, nonatomic, retain) CSDownLoadCourseModel *courseship;
@property (nullable, nonatomic, retain) NSNumber *modId;
@property (nullable, nonatomic, retain) NSNumber *courseId;
@property (nullable, nonatomic, retain) NSNumber *resId;
@property (nullable, nonatomic, retain) NSNumber *allowDown;
@property (nullable, nonatomic, retain) NSString *resource;
@property (nullable, nonatomic, retain) NSString *resCode;
@property (nullable, nonatomic, retain) NSNumber *viewAmount;

@end

NS_ASSUME_NONNULL_END
