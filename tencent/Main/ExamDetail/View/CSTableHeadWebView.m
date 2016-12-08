//
//  CSTableHeadWebView.m
//  tencent
//
//  Created by admin on 16/5/19.
//  Copyright © 2016年 cyh. All rights reserved.
//

#import "CSTableHeadWebView.h"
#import "CSFrameConfig.h"
#import "MBProgressHUD+CYH.h"
#import "CSFrameConfig.h"
#import "MBProgressHUD+SMHUD.h"


#define isiOS8 __IPHONE_OS_VERSION_MAX_ALLOWED>=__IPHONE_8_0

@implementation CSTableHeadWebView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

-(instancetype)init{
    if (self = [super init]) {
        [self iniWebView];
    }
    return self;
}

-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self iniWebView];
    }
    return self;
}

- (void)dealloc{
    NSLog(@"释放webView");
}

- (void)iniWebView{
    self.topicBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.topicBtn.frame = CGRectMake(kCSScreenWidth - 80, 0, 80, 25);
    self.topicBtn.titleLabel.font = [UIFont systemFontOfSize:14.0];
    [self.topicBtn setBackgroundImage:[UIImage imageNamed:@"icon_testlable"] forState:UIControlStateNormal];
    self.topicBtn.userInteractionEnabled = NO;
    [self addSubview:self.topicBtn];
    
    // 高度必须提前赋一个值 >0
    double version = [[UIDevice currentDevice].systemVersion doubleValue];
//    if ( version >=8.0 ) {
//        self.headWebView = [[WKWebView alloc] initWithFrame:CGRectMake(0, 20, [[UIScreen mainScreen] bounds].size.width , 10)];
//        self.headWebView.backgroundColor = [UIColor clearColor];
//        self.headWebView.opaque = NO;
//        self.headWebView.navigationDelegate = self;
//        self.headWebView.userInteractionEnabled = NO;
//        [self addSubview:self.headWebView];
//    }else{
    self.uiWebView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 20, [[UIScreen mainScreen] bounds].size.width , 10)];
    self.uiWebView.backgroundColor = [UIColor clearColor];
    self.uiWebView.opaque = NO;
    self.uiWebView.userInteractionEnabled = NO;
    self.uiWebView.scrollView.bounces = NO;
    self.uiWebView.delegate = self;
    self.uiWebView.scalesPageToFit = NO;
    self.uiWebView.paginationBreakingMode = UIWebPaginationBreakingModePage;
    [self addSubview:self.uiWebView];
//    }
    [self bringSubviewToFront:self.topicBtn];
}

#pragma mark - UIWebViewDelegate
-(void)webViewDidStartLoad:(UIWebView *)webView{
    [MBProgressHUD showMessage:@"加载中..." toView:self.parentVC.view delay:2.0];
}

-(void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    [MBProgressHUD hideHUDForView:self.parentVC.view];

    if ( self.passWebViewHeightBlock ) {
        self.passWebViewHeightBlock(10);
    }
}


- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [MBProgressHUD hideHUDForView:self.parentVC.view];
    CGFloat offsetHeight = [[webView stringByEvaluatingJavaScriptFromString:@"document.body.offsetHeight"] floatValue];
    offsetHeight += 40.0;
    self.uiWebView.frame = CGRectMake( 0, 20, [[UIScreen mainScreen] bounds].size.width, offsetHeight);
    if ( self.passWebViewHeightBlock ) {
        self.passWebViewHeightBlock(offsetHeight);
    }
}

- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation{

}

- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation{
    
    [self.headWebView evaluateJavaScript:@"document.body.offsetHeight" completionHandler:^(id _Nullable result, NSError * _Nullable error) {
        self.offsetHeight = [result doubleValue];
        self.offsetHeight += 40.0;
        self.headWebView.frame = CGRectMake( 0, 20, [[UIScreen mainScreen] bounds].size.width, self.offsetHeight);
        
        if ( self.passWebViewHeightBlock ) {
            self.passWebViewHeightBlock(self.offsetHeight);
        }

    }];
}

- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(WKNavigation *)navigation{
    if ( self.passWebViewHeightBlock ) {
        self.passWebViewHeightBlock(10);
    }
}
- (void)setHtmlString:(NSString *)htmlString{
    _htmlString = htmlString;
    
//     NSURLRequest *quest = [NSURLRequest requestWithURL:[NSURL URLWithString:htmlString] cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData timeoutInterval:20];
    
    NSURLRequest *quest = [NSURLRequest requestWithURL:[NSURL URLWithString:htmlString]];
    double version = [[UIDevice currentDevice].systemVersion doubleValue];
//    if (version >= 8.0) {
//        [self.headWebView loadRequest:quest];
//        [self.headWebView loadHTMLString:htmlString baseURL:nil];
//    }else{
//        [self.uiWebView loadRequest:quest];
        [self.uiWebView loadHTMLString:htmlString baseURL:nil];
//    }
}

-(void)setTopicTitle:(NSString *)topicTitle{
    _topicTitle = topicTitle;
    [self.topicBtn setTitle:topicTitle forState:UIControlStateNormal];
}

@end
