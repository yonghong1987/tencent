//
//  CSShareView.h
//  tencent
//
//  Created by admin on 16/5/6.
//  Copyright © 2016年 cyh. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, CSShareScope) {
    /*
     **微信朋友圈
     */
    CSShareScopeWechatZone,
    /*
     **微信朋友圈
     */
    CSShareScopeWechatFriend
};

@interface CSShareView : UIView
/*
 **标题
 */
@property (nonatomic, copy) NSString *title;
/*
 **地址
 */
@property (nonatomic, copy) NSString *url;
/*
 **图片
 */
@property (nonatomic, strong) UIImage *img;
@property (nonatomic, assign) CSShareScope shareScope;
@property (nonatomic, weak) UIViewController *viewController;
/*
 ***显示本视图
 */
- (void)showShareView;
/*
 **隐藏本视图
 */
- (void)hide;
/*
 **隐藏本视图
 */
- (void)hide:(void(^)())completion;
@end
