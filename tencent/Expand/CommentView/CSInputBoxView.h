//
//  CSInputBoxView.h
//  tencent
//
//  Created by admin on 16/5/9.
//  Copyright © 2016年 cyh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CSReplyTextView.h"
@interface CSInputBoxView : UIView
/*
 **提示语
 */
@property (nonatomic, copy) NSString *placeholder;
/*
 **背景图片
 */
@property (nonatomic, strong) UIImage *backgroundImage;

@property (nonatomic, copy) void(^didEndInputBlock)(BOOL succ,NSString *content);
/*
 **评论的回复视图
 */
@property (nonatomic, strong) CSReplyTextView *replyTextView;
@end
