//
//  CSReplyTextView.h
//  tencent
//
//  Created by admin on 16/5/9.
//  Copyright © 2016年 cyh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XHMessageTextView.h"
@interface CSReplyTextView : UIView<UITextViewDelegate>
/*
 **标题文字 
 */
@property (nonatomic, copy) NSString *title;
/*
 **点击确认block
 */
@property (nonatomic, strong) XHMessageTextView *textView;//内容输入框
@property (nonatomic, copy) void(^didSelectedSureBlock) (NSString *content);
@property (nonatomic, copy) void(^didSelectedCancelBlock)();//点击取消block

- (void)show;
@end
