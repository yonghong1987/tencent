//
//  CSSpecialHeadCell.h
//  tencent
//
//  Created by admin on 16/5/5.
//  Copyright © 2016年 cyh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CSSpecialListModel.h"
@interface CSSpecialHeadCell : UITableViewCell
/*
 **背景视图
 */
@property (nonatomic, strong) UIView *backView;
/*
 **图标
 */
@property (nonatomic, strong) UIImageView *iconIV;
/*
 **图标
 */
@property (nonatomic, strong) UILabel *titleLabel;
/*
 **虚线分割线
 */
@property (nonatomic, strong) UIImageView *gapIV;
/*
 **时间
 */
@property (nonatomic, strong) UILabel *timeLabel;

@property (nonatomic, strong) CSSpecialListModel *specialListModel;
@end
