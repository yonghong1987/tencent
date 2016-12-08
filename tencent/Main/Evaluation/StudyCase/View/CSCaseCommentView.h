//
//  CSCaseCommentView.h
//  tencent
//
//  Created by cyh on 16/7/27.
//  Copyright © 2016年 cyh. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CSCaseCommentView : UIView
/*
 **提示语
 */
@property (nonatomic, copy) NSString *placeholder;
/*
 **背景图片
 */
@property (nonatomic, strong) UIImage *backgroundImage;
@property (nonatomic, strong) UIButton *countBtn;
@property (nonatomic, copy) void(^didEndInputBlock)(BOOL succ,NSString *content);

@property (nonatomic, copy) void (^didCommentVC)();
@property (nonatomic, copy) NSString *countString;
@end
