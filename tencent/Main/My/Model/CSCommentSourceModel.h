//
//  CSCommentSourceModel.h
//  tencent
//
//  Created by cyh on 16/8/25.
//  Copyright © 2016年 cyh. All rights reserved.
//

#import "CSBaseModel.h"
#import "CSUserModel.h"
typedef NS_ENUM(NSInteger ,CSCommentSourceType) {
    CSCommentSourceCourceType,//课程
    CSCommentSourceCaseType,//案例
    CSCommentSourceSpecialType,//专题
    CSCommentSourceForumType,//论坛
    CSCommentSourceMapType,//关卡
};
@interface CSCommentSourceModel : CSBaseModel
/**
 *评论资源id
 */
@property (nonatomic, strong) NSNumber *sourceId;
/**
 *评论资源类型
 */
@property (nonatomic, copy) NSString *type;
/**
 *评论资源名称
 */
@property (nonatomic, copy) NSString *content;
/**
 *关卡id
 */
@property (nonatomic, strong) NSNumber *tollgateId;
/**
 *关卡名称
 */
@property (nonatomic, copy) NSString *tollgateName;
/**
 *评论资源类型
 */
@property (nonatomic, assign) CSCommentSourceType commentSourceType;
@end
