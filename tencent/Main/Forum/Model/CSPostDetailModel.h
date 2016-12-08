//
//  CSPostDetailModel.h
//  tencent
//
//  Created by cyh on 16/7/26.
//  Copyright © 2016年 cyh. All rights reserved.
//

#import "CSBaseModel.h"

@interface CSPostDetailModel : CSBaseModel
/**
 *帖子创建时间
 */
@property (nonatomic, copy) NSString *createDate;
/**
 *帖子内容
 */
@property (nonatomic, copy) NSString *content;
/**
 *帖子创建者
 */
@property (nonatomic, copy) NSString *creatorName;
/**
 *帖子创建者id
 */
@property (nonatomic, strong) NSNumber *creator;
/**
 *帖子的图片数组
 */
@property (nonatomic, strong) NSMutableArray *postImages;
/**
 *帖子的回复数
 */
@property (nonatomic, strong) NSNumber *replyCount;
/**
 *帖子的浏览数
 */
@property (nonatomic, strong) NSNumber *readCount;
/**
 *帖子的id
 */
@property (nonatomic, strong) NSNumber *forumId;
/**
 *帖子是否置顶
 */
@property (nonatomic, strong) NSNumber *isTop;
/**
 *帖子的评论数组
 */
@property (nonatomic, strong) NSMutableArray *commentArr;
/**
 *评论总数
 */
@property (nonatomic, strong) NSNumber *commentCount;
@end
