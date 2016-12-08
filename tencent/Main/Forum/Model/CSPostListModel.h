//
//  CSPostListModel.h
//  tencent
//
//  Created by admin on 16/5/23.
//  Copyright © 2016年 cyh. All rights reserved.
//

#import "CSBaseModel.h"

@interface CSPostListModel : CSBaseModel
/*
 **帖子创建人
 */
@property (nonatomic, copy) NSString *creatorName;
/*
 **帖子是否置顶
 */
@property (nonatomic, copy) NSString *top;
/*
 **帖子回复数
 */
@property (nonatomic, strong) NSNumber *commentCount;
/*
 **帖子内容
 */
@property (nonatomic, copy) NSString *content;
/*
 **帖子发布时间
 */
@property (nonatomic, copy) NSString *createDate;
/*
 **帖子id
 */
@property (nonatomic, strong) NSNumber *forumId;
/*
 **图片数组
 */
@property (nonatomic, strong) NSMutableArray *images;

@end

