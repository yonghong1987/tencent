//
//  CSCourseListModel.h
//  tencent
//
//  Created by bill on 16/4/27.
//  Copyright © 2016年 cyh. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CSBaseModel.h"
#import "JSONModel.h"

@interface CSCourseListModel : CSBaseModel

/**
 *  课程Id
 */
@property (nonatomic, strong) NSNumber *courseId;

/**
 *  课程名
 */
@property (nonatomic, strong) NSString *name;

/**
 *  课程描述
 */
@property (nonatomic, strong) NSString *describe;

/**
 *  课程缩略图
 */
@property (nonatomic, strong) NSString *thumbnail;

/**
 *  点赞数
 */
@property (nonatomic, strong) NSNumber *praiseCount;

/**
 *  评论数
 */
@property (nonatomic, strong) NSNumber *commentCount;

/**
 *  浏览数
 */
@property (nonatomic, strong) NSNumber *viewAmount;



@end
