//
//  CSPostCommentCell.h
//  tencent
//
//  Created by cyh on 16/7/26.
//  Copyright © 2016年 cyh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CSSpecialCommentModel.h"
@interface CSPostCommentCell : UITableViewCell

/**
 *背景视图
 */
@property (nonatomic, strong)UIView *backView;
/*
 **评论者
 */
@property (nonatomic, strong) UILabel *nameLabel;
/**
 *是否显示置顶
 */
@property (nonatomic, strong) UILabel *topLabel;
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
/*
 **评论对象
 */
@property (nonatomic, strong) CSSpecialCommentModel* commentModel;
/**
 *评论者角色标示
 */
@property (nonatomic, strong) UIImageView *roleIV;
/**
 *评论者角色
 */
@property (nonatomic, strong) UILabel *roleLabel;

@end
