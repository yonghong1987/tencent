//
//  CSReadArticleViewController.m
//  tencent
//
//  Created by bill on 16/5/9.
//  Copyright © 2016年 cyh. All rights reserved.
//

#import "CSReadArticleViewController.h"
#import "CSFrameConfig.h"
#import "MBProgressHUD+CYH.h"
#import "CSNotificationConfig.h"
#import "NSDictionary+convenience.h"

@interface CSReadArticleViewController ()<UIWebViewDelegate>

@property (nonatomic, strong) UIWebView *contentWeb;

@end

@implementation CSReadArticleViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    if ( self.resourceTitle && [self.resourceTitle isKindOfClass:[NSString class]] ) {
        self.title = self.resourceTitle;
    }
    
    [self.view addSubview:self.contentWeb];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark UIWebView DelegateMethod
- (void)webViewDidStartLoad:(UIWebView *)webView{
    [MBProgressHUD showMessage:@"加载中..." toView:self.view];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView{
    [MBProgressHUD hideHUDForView:self.view];
    [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_VIDEOORARTICAL_PLAY object:self.resourceId];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
    [MBProgressHUD hideHUDForView:self.view];
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
    
//    if ( navigationType == UIWebViewNavigationTypeLinkClicked ) {
//        NSString *originStr = request.URL.relativeString;
//        NSArray* array = [originStr componentsSeparatedByString:@"?"];
//        NSString *subStr = [array lastObject];
//        NSArray  * arrParam =[subStr componentsSeparatedByString:@"&"];
//        NSMutableDictionary *dicParam = [[NSMutableDictionary alloc] initWithCapacity:arrParam.count];
//        for( NSString *param in arrParam ) {
//            NSMutableArray *oneParam = (NSMutableArray *)[param componentsSeparatedByString:@"="];
//            if( [oneParam containsObject:@""] )
//                [oneParam removeObject:@""];
//            [dicParam setValue:[oneParam lastObject] forKey:[oneParam firstObject]];
//        }
//        NSString *typeValue = [dicParam stringForKey:OpenURLType];
//        if( typeValue.length == 0 ) {
//            return YES;
//        }
//    }
    return YES;
}


- (UIWebView *)contentWeb{
    if ( !_contentWeb ) {
        _contentWeb = [[UIWebView alloc] initWithFrame:CGRectMake( 0, 0, kCSScreenWidth, kCSScreenHeight - 64)];
        _contentWeb.delegate = self;
    }
    if ( self.resourceContent && [self.resourceContent isKindOfClass:[NSString class]] ) {
        [_contentWeb loadHTMLString:self.resourceContent baseURL:nil];
    }
    return _contentWeb;
}
@end
