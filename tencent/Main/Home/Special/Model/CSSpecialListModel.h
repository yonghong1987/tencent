//
//  CSSpecialListModel.h
//  tencent
//
//  Created by admin on 16/5/3.
//  Copyright © 2016年 cyh. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CSBaseModel.h"
@interface CSSpecialListModel : CSBaseModel
/*
 **专题id
 */
@property (nonatomic, strong) NSNumber *courseId;
/*
 **专题name
 */
@property (nonatomic, copy) NSString *name;
/*
 **点赞数
 */
@property (nonatomic, strong) NSNumber *praiseCount;
/*
 **评论数
 */
@property (nonatomic, strong) NSNumber *commentCount;
/*
 **浏览数
*/
@property (nonatomic, strong) NSNumber *viewAmount;
/*
 **专题描述
 */
@property (nonatomic, copy) NSString *describe;
/*
 **专题缩略图
 */
@property (nonatomic, copy) NSString *thumbnail;
/**
 *赞id
 */
@property (nonatomic, strong) NSNumber *praiseId;
/**
 *收藏id
 */
@property (nonatomic, strong) NSNumber *collectId;


/*
 **是否已赞
 */
@property (nonatomic, assign) BOOL isPraise;
/*
 ***是否已收藏
 */
@property (nonatomic, assign) BOOL isCollect;
/*
 **专题内容
 */
@property (nonatomic, copy) NSString *content;
/*
 **专题创建时间
 */
@property (nonatomic, copy) NSString *modifieddate;
/*
 **专题编号
 */
@property (nonatomic, strong) NSNumber *activityId;


@end
