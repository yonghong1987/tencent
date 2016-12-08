//
//  CSMyCommentCell.h
//  tencent
//
//  Created by cyh on 16/8/25.
//  Copyright © 2016年 cyh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CSSpecialCommentModel.h"
@interface CSMyCommentCell : UITableViewCell

@property (nonatomic, strong) UIView *backView;
/*
 **评论者
 */
@property (nonatomic, strong) UILabel *nameLabel;
/*
 **点赞按钮
 */
@property (nonatomic, strong) UIButton *praiseBtn;
/*
 **评论内容
 */
@property (nonatomic, strong) UILabel *contentLabel;
/*
 **评论时间
 */
@property (nonatomic, strong) UILabel *timeLabel;
/*
 **分割线
 */
@property (nonatomic, strong) UIImageView *gapIV;
/**
 *flag
 */
@property (nonatomic, strong) UILabel *flagLabel;
/**
 *资源来源名称
 */
@property (nonatomic, strong) UILabel *sourceNameLabel;

@property (nonatomic, strong) CSSpecialCommentModel *commentModel;

@property (nonatomic, copy) void (^clickSelectionAction)();
@end
