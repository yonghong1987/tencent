//
//  CSPostListCell.h
//  tencent
//
//  Created by admin on 16/5/23.
//  Copyright © 2016年 cyh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CSPostListModel.h"
#import "CSPhotosView.h"
typedef NS_ENUM(NSUInteger, CSPostImageDisplayType) {
    CSPostListCellType,
    CSPostDetailType,
};

@interface CSPostListCell : UITableViewCell

/**
 *  背景图片(颜色)
 */
@property (nonatomic, strong) UIView *backView;
/**
 *  发帖人label
 */
@property (nonatomic, strong) UILabel *namelLabel;
/**
 *  是否置顶label
 */
@property (nonatomic, strong) UILabel *topLabel;
/**
 *  评论数btn
 */
@property (nonatomic, strong) UIButton *commentTotalBtn;
/**
 *  帖子内容
 */
@property (nonatomic, strong) UILabel *contentLabel;
/**
 *  发帖时间
 */
@property (nonatomic, strong) UILabel *timeLabel;
;
/*
 **用于放置图片
 */
@property (nonatomic, strong) CSPhotosView *photosView;
@property (nonatomic, strong) CSPostListModel *postListModel;
@property (nonatomic, assign) CSPostImageDisplayType postImageDisplayType;
- (CGFloat)getCellHeight;
- (CGFloat)getPostDetailCellHeight;

@end
