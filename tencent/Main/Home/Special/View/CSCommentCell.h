//
//  CSCommentCell.h
//  tencent
//
//  Created by admin on 16/5/7.
//  Copyright © 2016年 cyh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CSSpecialCommentModel.h"
#import "CSReplyCommentModel.h"

typedef NS_ENUM(NSInteger, CSCommentType) {
    CSCommentStudyCaseType,
    CSCommentSpecialType,
};
@interface CSCommentCell : UITableViewCell


@property (nonatomic, assign) CSCommentType commentType;
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
/*
 **评论对象
 */
@property (nonatomic, strong) CSSpecialCommentModel* commentModel;
/*
 **评论的回复对象
 */
@property (nonatomic, strong) CSReplyCommentModel *replyCommentModel;
@property (nonatomic, strong) UIView *backView;
@property (nonatomic, assign) NSInteger section;
@property (nonatomic, strong) NSIndexPath *indexPath;
//点赞
@property (nonatomic, strong) void (^praiseActionBlock)(void);

@property(nonatomic, copy) void(^didSelectedReplyBlock)(NSIndexPath *);
- (CGFloat)getCellHeight;

@end
