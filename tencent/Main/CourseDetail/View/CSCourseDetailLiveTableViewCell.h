//
//  CSCourseDetailLiveTableViewCell.h
//  tencent
//
//  Created by bill on 16/5/3.
//  Copyright © 2016年 cyh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CSCourseResourceModel.h"

@interface CSCourseDetailLiveTableViewCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UIButton *playBtn;


- (void)setResourceCell:(CSCourseResourceModel *)model;
//课前课后按钮
@property (strong, nonatomic)  UIButton *precourseBtn;

@end
