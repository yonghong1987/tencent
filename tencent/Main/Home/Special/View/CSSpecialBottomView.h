//
//  CSSpecialBottomView.h
//  tencent
//
//  Created by admin on 16/5/6.
//  Copyright © 2016年 cyh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CSSpecialListModel.h"
#import "CSCourseDetailModel.h"

typedef NS_ENUM(NSUInteger, CSBottomViewType){
    CSSpecialDetailBottomView,
    CSNormalCourseDetailBottomView,
    CSMapCourseDetailBottomView
};


@interface CSSpecialBottomView : UIView


/*
 **专题model
*/
@property (nonatomic, strong) CSSpecialListModel *specialModel;
/**
 *课程详情model
 */
@property (nonatomic, strong) CSCourseDetailModel *detailModel;
/**
 *评论按钮
 */
@property (nonatomic, strong) UIButton *commentBtn;
/**
 *分享按钮
 */
@property (nonatomic, strong) UIButton *shareBtn;
/**
 *点赞按钮
 */
@property (nonatomic, strong) UIButton *praiseBtn;
/**
 *收藏按钮
 */
@property (nonatomic, strong) UIButton *collectBtn;
/**
 *延伸阅读按钮
 */
@property (nonatomic, strong) UIButton *readBtn;


/*
 **评论
*/
@property (nonatomic, strong) void (^commentActionBlock)(void);
/*
 **分享
*/
@property (nonatomic, strong) void (^shareActionBlock)(void);
/*
 **点赞
*/
@property (nonatomic, strong) void (^praiseActionBlock)(void);
/*
 *收藏
**/
@property (nonatomic, strong) void (^collectActionBlock)(void);
/*
 **延伸阅读
 */
@property (nonatomic, strong) void (^redActionBlock)(void);
/*
 **是哪一类型
 */
@property (nonatomic, assign) CSBottomViewType buttonViewType;

@end
