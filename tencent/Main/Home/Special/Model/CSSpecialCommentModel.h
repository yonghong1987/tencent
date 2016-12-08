//
//  CSSpecialCommentModel.h
//  tencent
//
//  Created by admin on 16/5/7.
//  Copyright © 2016年 cyh. All rights reserved.
//

#import "CSBaseModel.h"
#import "CSUserModel.h"
#import "CSCommentSourceModel.h"
@interface CSSpecialCommentModel : CSBaseModel
/*
 **评论者名字
 */
@property (nonatomic, copy) NSString *commentUserName;
/*
 **评论者名字
 */
@property (nonatomic, strong) NSNumber *commentUserId;
/*
 **评论id
 */
@property (nonatomic, strong) NSNumber *commentId;
/*
 **评论内容
 */
@property (nonatomic, copy) NSString *content;
/*
 **评论时间
 */
@property (nonatomic, copy) NSString *createDate;
/*
 **评论的点赞数
 */
@property (nonatomic, strong) NSNumber *praiseCount;
/**
 *评论者的信息
 */
@property (nonatomic, strong) CSUserModel *userModel;
/**
 *评论是否已赞
 */
@property (nonatomic, strong) NSNumber *alreadyZan;
/**
 *评论是否置顶
 */
@property (nonatomic, strong) NSNumber *isTop;
/**
 *评论的赞id
 */
@property (nonatomic, strong) NSNumber *praiseId;
/**
 *评论的parent类型
 */
@property (nonatomic, copy) NSString *targetType;
/**
 *评论的parentid
 */
@property (nonatomic, strong) NSNumber *targetId;
/*
 **评论的回复数组
 */
@property (nonatomic, strong) NSMutableArray *replyComments;

//评论资源类型对象
@property (nonatomic, strong) CSCommentSourceModel *sourceModel;
@end
