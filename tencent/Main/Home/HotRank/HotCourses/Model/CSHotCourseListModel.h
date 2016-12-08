//
//  CSHotCourseListModel.h
//  tencent
//
//  Created by bill on 16/4/28.
//  Copyright © 2016年 cyh. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CSBaseModel.h"
#import "JSONModel.h"

@interface CSHotCourseListModel : CSBaseModel

/**
 *  热门课程ID
 */
@property (nonatomic, strong) NSNumber *courseId;

/**
 *  热门课程名
 */
@property (nonatomic, strong) NSString *name;

/**
 *  热门课程描述
 */
@property (nonatomic, strong) NSString *describe;

/**
 *  热门课程缩略图
 */
@property (nonatomic, strong) NSString *thumbnail;

/**
 *  热门课程浏览数
 */
@property (nonatomic, strong) NSNumber *viewAmount;

/**
 *  热门课程点评数
 */
@property (nonatomic, strong) NSNumber *commentCount;

/**
 *  热门课程点赞数
 */
@property (nonatomic, strong) NSNumber *praiseCount;

  
@end
