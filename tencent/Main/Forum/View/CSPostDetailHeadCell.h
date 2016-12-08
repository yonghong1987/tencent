//
//  CSPostDetailHeadCell.h
//  tencent
//
//  Created by cyh on 16/7/26.
//  Copyright © 2016年 cyh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SMPhotoContainerView.h"
#import "CSPostDetailModel.h"
@interface CSPostDetailHeadCell : UITableViewCell
/*
 *发帖人名称
 **/
@property (nonatomic, strong) UILabel *namelLabel;
/*
 *发帖人角色
 **/
@property (nonatomic, strong) UILabel *roleLabel;
/**
 *  评论数btn
 */
@property (nonatomic, strong) UIButton *commentTotalBtn;
/**
 *分割线
 */
@property (nonatomic, strong) UIImageView *gapIV;
/**
 *  帖子内容
 */
@property (nonatomic, strong) UILabel *contentLabel;
/**
 *帖子的图片
 */
@property (nonatomic ,strong) SMPhotoContainerView * photoContainerView;
/**
 *发帖时间
 */
@property (nonatomic, strong) UILabel *timeLabel;
@property (nonatomic, strong) UIImageView *triangleIV;
/**
 *帖子详情对象
 */
@property (nonatomic, strong) CSPostDetailModel *postDetailModel;

@end
