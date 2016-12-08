//
//  CSCourseDetailArticleTableViewCell.h
//  tencent
//
//  Created by bill on 16/5/3.
//  Copyright © 2016年 cyh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CSCourseResourceModel.h"

@interface CSCourseDetailArticleTableViewCell : UITableViewCell


@property (strong, nonatomic) IBOutlet UIButton *readArticleBtn;

- (void)setResourceCell:(CSCourseResourceModel *)model;

//阅读文章按钮
@property (strong, nonatomic)  UIButton *redBtn;

@end
