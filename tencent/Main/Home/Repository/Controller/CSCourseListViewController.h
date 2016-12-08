//
//  CSCourseListViewController.h
//  tencent
//
//  Created by bill on 16/4/27.
//  Copyright © 2016年 cyh. All rights reserved.
//

#import "CSBaseViewController.h"
typedef NS_ENUM(NSInteger, CSCourseListType) {
       CSCourseListRepositoryType = 100,
};
@interface CSCourseListViewController : CSBaseViewController

/**
 *  初始化获取课程列表参数
 *
 *  @param categoryId   目录Id
 *  @param categoryName 课程名
 *  @param courseType   课程类别
 *
 *  @return 初始化
 */
- (id)initWithCategory:(NSNumber *)categoryId
          CategoryName:(NSString *)categoryName
            CourseType:(NSString *)courseType;

@property (nonatomic, assign) CSCourseListType courseListType;
@end
