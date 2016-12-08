//
//  CSCourseListTableViewCell.h
//  tencent
//
//  Created by bill on 16/4/27.
//  Copyright © 2016年 cyh. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "CSCourseListModel.h"
#import "CSHotCourseListModel.h"
#import "CSSpecialListModel.h"
#import "CSStudyMapModel.h"
@interface CSCourseListTableViewCell : UITableViewCell

/**
 *  初始化课程列表
 *
 *  @param model 课程列表Model
 */
- (void)setCourseCell:(CSCourseListModel *)model;

/**
 *  初始化热门课程列表
 *
 *  @param model 热门课程列表Model
 */
- (void)setHotCourseCell:(CSHotCourseListModel *)model;

/**
 *  初始化专题列表
 *
 *  @param model 专题列表Model
 */
- (void)setSpecialCell:(CSSpecialListModel *)model;

/**
 *  初始化学习地图列表
 *
 *  @param model 地图列表Model
 */
- (void)setMapCell:(CSStudyMapModel *)model;
@end
