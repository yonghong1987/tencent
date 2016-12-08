//
//  CSDownLoadCourseModel+CoreDataProperties.h
//  tencent
//
//  Created by bill on 16/5/24.
//  Copyright © 2016年 cyh. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "CSDownLoadCourseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface CSDownLoadCourseModel (CoreDataProperties)

@property (nullable, nonatomic, retain) NSNumber *canDownLoad;
@property (nullable, nonatomic, retain) NSNumber *canLearning;
@property (nullable, nonatomic, retain) NSNumber *collectionStatus;
@property (nullable, nonatomic, retain) NSString *courseCommentAmmount;
@property (nullable, nonatomic, retain) NSString *courseCreateDate;
@property (nullable, nonatomic, retain) NSString *courseDescription;
@property (nullable, nonatomic, retain) NSNumber *courseId;
@property (nullable, nonatomic, retain) NSString *courseImg;
@property (nullable, nonatomic, retain) NSString *courseName;
@property (nullable, nonatomic, retain) NSString *courseSpecialName;
@property (nullable, nonatomic, retain) NSString *courseSupportAmmount;
@property (nullable, nonatomic, retain) NSNumber *examId;
@property (nullable, nonatomic, retain) NSString *examType;
@property (nullable, nonatomic, retain) NSNumber *projectId;
@property (nullable, nonatomic, retain) NSNumber *supportStatus;
@property (nullable, nonatomic, retain) NSNumber *courseResourceCount;
@property (nullable, nonatomic, retain) NSNumber *mapId;
@property (nullable, nonatomic, retain) NSString *courseType;
@property (nullable, nonatomic, retain) NSSet<CSDownLoadResourceModel *> *resourceship;

@end

@interface CSDownLoadCourseModel (CoreDataGeneratedAccessors)

- (void)addResourceshipObject:(CSDownLoadResourceModel *)value;
- (void)removeResourceshipObject:(CSDownLoadResourceModel *)value;
- (void)addResourceship:(NSSet<CSDownLoadResourceModel *> *)values;
- (void)removeResourceship:(NSSet<CSDownLoadResourceModel *> *)values;

@end

NS_ASSUME_NONNULL_END
