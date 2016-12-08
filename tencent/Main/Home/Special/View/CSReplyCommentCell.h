//
//  CSReplyCommentCell.h
//  tencent
//
//  Created by admin on 16/5/7.
//  Copyright © 2016年 cyh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CSReplyCommentModel.h"
#import "CSToolButtonView.h"
#import "CSCommentCell.h"
@interface CSReplyCommentCell : UITableViewCell

@property (nonatomic, assign) CSCommentType commentType;
/*
 **背景图片
 */
@property (nonatomic, strong) UIImageView *backImg;
/*
 **评论者
 */
@property (nonatomic, strong) UILabel *nameLabel;
/*
 ***点赞按钮
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
 **评论的回复对象
 */
@property (nonatomic, strong) CSReplyCommentModel *replyCommentModel;
/*
 **弹出的回复视图
 */
@property (nonatomic, strong) CSToolButtonView* cellReplyView;
/*
 **记住本cell的位置
 */
@property (nonatomic, strong) NSIndexPath *indexPath;
/*
 **点击回复的block
 */
@property (nonatomic, copy) void(^didSelectReplyComment)();
/*
 **锁定屏幕的视图
 */
@property (nonatomic, strong) UIView *maskView;
@property (nonatomic, weak) UIViewController *controller;
- (CGFloat)getCellHeight;


@end
