//
//  CSTableHeadWebView.h
//  tencent
//
//  Created by admin on 16/5/19.
//  Copyright © 2016年 cyh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZLCWebView.h"
@interface CSTableHeadWebView : UIView<UIWebViewDelegate,WKNavigationDelegate>

@property (nonatomic, strong) UIViewController *parentVC;

/*
 **试题内容
 */
@property (nonatomic, strong) WKWebView *headWebView;
/**
 *试题内容
 */
@property (nonatomic, strong) UIWebView *uiWebView;
/*
 **获取webView的高度
 */
@property (nonatomic, assign) CGFloat webViewHeight;
/*
 **webView加载的内容
 */
@property (nonatomic, copy) NSString *htmlString;

/*
 **传递webView的高度
 */
@property (nonatomic, strong) void (^passWebViewHeightBlock)(CGFloat height);
/**
 *用于显示题目的类型（单选、多选、不定项、填空）
 */
@property (nonatomic, strong) UIButton *topicBtn;
@property (nonatomic, copy) NSString *topicTitle;

@property (nonatomic, assign) CGFloat offsetHeight;
@end
