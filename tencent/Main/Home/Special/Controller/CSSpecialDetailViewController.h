//
//  CSSpecialDetailViewController.h
//  tencent
//
//  Created by admin on 16/5/4.
//  Copyright © 2016年 cyh. All rights reserved.
//

#import "CSBaseViewController.h"
#import "SMBaseTableView.h"
#import "IMYWebView.h"
@interface CSSpecialDetailViewController : CSBaseViewController<UITableViewDelegate,UITableViewDataSource,UIWebViewDelegate,UIScrollViewDelegate>
/*
 **专题id
 */
@property (nonatomic, strong) NSNumber *specialid;
@property (nonatomic, strong) SMBaseTableView *detailTable;
/*
 **用于显示专题内容
 */
@property (nonatomic, strong) UIWebView *detailWebView;
/*
 **保存WebView高度
 */
@property (nonatomic, assign) CGFloat webViewHeight;
@end
