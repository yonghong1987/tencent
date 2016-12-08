//
//  CSCourseModel.h
//  tencent
//
//  Created by sunon002 on 16/4/27.
//  Copyright © 2016年 cyh. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CSBaseModel.h"
@interface CSCourseModel : CSBaseModel
@property (nonatomic ,assign) BOOL isAllowDown;//是否可以下载
@property (nonatomic ,assign) BOOL isAllowEnter;//是否可以进入
@property (nonatomic ,copy) NSString *collectTotal;//课程收藏总数
@property (nonatomic ,copy) NSString *commentTotal;//课程评论总数
@property (nonatomic ,copy) NSString *courseImg;//课程图片
@property (nonatomic ,copy) NSString *courseCreatDate;//课程创建日期
@property (nonatomic ,copy) NSString *courseDes;//课程简介
@property (nonatomic ,copy) NSString *courseId;//课程id
@property (nonatomic ,copy) NSString *name;//课程名称
@property (nonatomic ,copy) NSString *courseRescode;//课程类型

- (instancetype)initWithDictionary:(NSDictionary *)dictionary;
@end
