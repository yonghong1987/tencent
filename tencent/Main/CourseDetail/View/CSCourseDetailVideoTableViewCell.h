//
//  CSCourseDetailVideoTableViewCell.h
//  tencent
//
//  Created by bill on 16/5/3.
//  Copyright © 2016年 cyh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CSCourseResourceModel.h"
#import "UAProgressView.h"
#import "TYDownLoadModel.h"

@class CSCourseDetailVideoTableViewCell;

@protocol CourseDetailCellDelegate <NSObject>

-(void)downResource:(CSCourseResourceModel *)resourceModel cell:(CSCourseDetailVideoTableViewCell *)cell;

@end

@interface CSCourseDetailVideoTableViewCell : UITableViewCell

@property (strong, nonatomic) UIImageView *playIV;


@property (nonatomic, strong) CSCourseResourceModel *resourceModel;

@property(nonatomic,assign)id<CourseDetailCellDelegate> delegate;
/**
 *是否可以学习
 */
@property (nonatomic, assign) NSInteger studyFlag;

#pragma mark - duck
@property (nonatomic) float progress;//0~1之间的数

@property (nonatomic) TYDownloadState state;

//课前课后按钮
@property (strong, nonatomic)  UIButton *precourseBtn;
@end
