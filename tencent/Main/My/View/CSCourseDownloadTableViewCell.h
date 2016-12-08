//
//  CSCourseDownloadTableViewCell.h
//  tencent
//
//  Created by bill on 16/4/27.
//  Copyright © 2016年 cyh. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "CSDownLoadCourseModel.h"
#import "CSCourseDetailModel.h"
@interface CSCourseDownloadTableViewCell : UITableViewCell

/**
 *  初始化课程列表
 *
 *  @param model 课程下载记录列表Model
 */

@property (nonnull ,strong) CSCourseDetailModel * courseModel;

@property (nonnull ,copy) NSNumber * notDownload;

@property (nonnull ,copy) NSNumber * downloading;

@property (nonnull ,copy) NSNumber * downloadComplete;

@end
