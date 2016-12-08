//
//  CSSpecialDetailCell.h
//  tencent
//
//  Created by admin on 16/5/5.
//  Copyright © 2016年 cyh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CSSpecialListModel.h"

#import "HZPhotoBrowser.h"
#import "WebViewURLViewController.h"
#import "IMYWebView.h"
@interface CSSpecialDetailCell : UITableViewCell<UIWebViewDelegate,HZPhotoBrowserDelegate>

/*
 ***用于显示专题详情
 */
@property (nonatomic, strong) UIWebView *detailWebView;
@property (nonatomic, strong) CSSpecialListModel *specialListModel;
@property(nonatomic, assign)CGFloat webviewHight;//记录webview的高度
@property(nonatomic, strong)NSMutableArray *imageArray;//HTML中的图片个数
@property (nonatomic, weak) UIViewController *viewController;

@end
