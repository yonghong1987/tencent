//
//  CSCourseDetailModel.m
//  tencent
//
//  Created by bill on 16/5/3.
//  Copyright © 2016年 cyh. All rights reserved.
//

#import "CSCourseDetailModel.h"
#import "CSImagePath.h"
#import "NSDictionary+convenience.h"

@implementation CSCourseDetailModel
 
- (instancetype)initWithDictionary:(NSDictionary *)dict error:(NSError *__autoreleasing *)err
{
    self = [super initWithDictionary:dict error:err];
    if (self) {
        self.img = [CSImagePath noEncodeingImageUrl:self.img];
     }
    return self;
}

- (id)initWithDownCourseModel:(CSDownLoadCourseModel *)downCourseModel{
    
    self = [super init];
    if ( self ) {
        
        _courseId = downCourseModel.courseId;
        
        _name =  downCourseModel.courseName;
        
        _describe = downCourseModel.courseDescription;
        
        _specialName = downCourseModel.courseSpecialName;
        
        _modifiedDate = downCourseModel.courseCreateDate;
        
        _img = [CSImagePath noEncodeingImageUrl:downCourseModel.courseImg];
        
//        _courseSupportAmmount = downCourseModel.courseSupportAmmount;
//        
//        _courseCommentAmmount = downCourseModel.courseCommentAmmount;
        
        _praiseId = downCourseModel.supportStatus;
        
        _collectId = downCourseModel.collectionStatus;
        
        _allowDown = downCourseModel.canDownLoad;
        
        _studyFlag = [downCourseModel.canLearning integerValue];
        
        _testFlag = [downCourseModel.examId integerValue];
//        
//        _examType = downCourseModel.examType;
//        
//        _courseResourceCount = [downCourseModel.courseResourceCount integerValue];
        
    }
    return self;
}
@end
