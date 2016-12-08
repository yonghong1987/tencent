//
//  CSCourseDetailModel.h
//  tencent
//
//  Created by bill on 16/5/3.
//  Copyright © 2016年 cyh. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CSDownLoadCourseModel.h"
#import "CSBaseModel.h"

@protocol CSCourseResourceModel
@end



@interface CSCourseDetailModel : CSBaseModel

/**
 *  课程Id
 */
@property (nonatomic, strong) NSNumber *courseId;
/**
 *关卡id
 */
@property (nonatomic, strong) NSNumber *tollgateId;
/**
 *  课程名
 */
@property (nonatomic, strong) NSString *name;

/**
 *  课程描述
 */
@property (nonatomic, strong) NSString *describe;

/**
 *  专题名
 */

@property (nonatomic, strong) NSString *specialName;

/**
 *  更新日期
 */
@property (nonatomic, strong) NSString *modifiedDate;

/**
 *  课程封面图片
 */
@property (nonatomic, strong) NSString *img;

/**
 *  是否必修课程（0：否，1：是）
 */
@property (nonatomic, strong) NSNumber *compulsory;

///**
// *  课程点评数
// */
//@property (nonatomic, strong) NSString *courseCommentAmmount;
//
///**
// *  课程点赞数
// */
//@property (nonatomic, strong) NSString *courseSupportAmmount;

/**
 *  点赞状态 大于0:已点赞  0:未点赞
 */
@property (nonatomic, strong) NSNumber *praiseId;

/**
 *  收藏状态 大于0:已收藏  0:未收藏
 */
@property (nonatomic, strong) NSNumber *collectId;

/**
 *  是否允许下载 1可以下载 0不能下载
 */
@property (nonatomic, strong) NSNumber *allowDown;

/**
 *  是否允许学习  1可以学习  0不能学习
 */
@property (nonatomic, assign) NSInteger studyFlag;


/**
 *  是否允许课后考试  1可以测试  0不能测试
 */
@property (nonatomic, assign) NSInteger testFlag;

@property (nonatomic, strong) NSArray<CSCourseResourceModel> * contentList;



///**
// *  判断是否有考试 ，大于0时有考试
// */
//@property (nonatomic, strong) NSNumber *examId;

///**
// *  试卷类型（PRECOURSE，课前测验；AFCOURSE， 课后测验）
// */
//@property (nonatomic, strong) NSString *examType;
//
///**
// *  课程资源总数
// */
//@property (nonatomic, assign) NSInteger courseResourceCount;

 
- (id)initWithDownCourseModel:(CSDownLoadCourseModel *)downCourseModel;

@end
