//
//  SMTableView.m
//  sunMobile
//
//  Created by duck on 16/3/22.
//  Copyright © 2016年 www.sunontalent.com. All rights reserved.
//

#import "SMBaseTableView.h"
#import "UIScrollView+EmptyDataSet.h"
#import "MJRefresh.h"
#import "ConstFile.h"
#import "UIColor+HEX.h"

@interface SMBaseTableView ()<DZNEmptyDataSetSource, DZNEmptyDataSetDelegate>

@end

@implementation SMBaseTableView
- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style
{
    self = [super initWithFrame:frame style:style];
    if (self) {
        [self clearTableFooterView];
        self.separatorColor = [UIColor colorWithHexString:@"#e5e5e5"];
    }
    return self;
}

- (void)awakeFromNib{
    
}


#pragma mark -- MJRefresh
- (void)refreshHeaderRefresh:(RefreshComponentHeaderRefreshingBlock)componentHeaderRefreshingBlock  withFooterRefreshingBlock:(RefreshComponentFooterRefreshingBlock)componentFooterRefreshingBlock{
    
    self.page = 1;
    
    MJRefreshNormalHeader * mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        self.page = 1;
        self.refreshState = SMBaseTableViewRefreshStateHeader;
        componentHeaderRefreshingBlock();
    }];
    mj_header.automaticallyChangeAlpha = YES;
    mj_header.lastUpdatedTimeLabel.textColor =  [UIColor colorWithWhite:0.498 alpha:0.500];
    mj_header.stateLabel.textColor = mj_header.lastUpdatedTimeLabel.textColor;
    self.mj_header = mj_header;
    
    
    MJRefreshAutoNormalFooter  * mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        self.refreshState = SMBaseTableViewRefreshStateFooter;
        componentFooterRefreshingBlock();
    }];
    mj_footer.stateLabel.textColor = mj_header.lastUpdatedTimeLabel.textColor;
    mj_footer.automaticallyHidden = YES;
    self.mj_footer = mj_footer;
}

- (void)beginRefreshing{
    [self.mj_header beginRefreshing];
}

- (void)endRefreshing{
    
    if (self.mj_header) {
        if ([self.mj_header isRefreshing]) {
            [self.mj_header endRefreshing];
        }
    }
    
    if (self.mj_footer) {
        if ([self.mj_footer isRefreshing]) {
            [self.mj_footer endRefreshing];
        }
    }
    
    NSInteger total = [self numberOfRowsInSection:self.ofSection];
    NSInteger rp = total%CONST_RP;
    if (rp!=0) {
        [self.mj_footer endRefreshingWithNoMoreData];
    }else{
        [self.mj_footer resetNoMoreData];

    }
    
}

#warning 以下测试为测试代码 具体等ui 界面图片
#pragma mark UIScrollView+EmptyDataSet

- (void)setEmptyDataSet{

    self.emptyDataSetSource = self;
    self.emptyDataSetDelegate = self;
    self.tableFooterView = [UIView new];
}

#pragma mark -  Data Source 实现方法
//返回单张图片
- (UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView
{
    return [UIImage imageNamed:@"empty_placeholder"];
}

//返回标题文字
- (NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView
{
    NSString *text = @"Please Allow Photo Access";
    NSDictionary *attributes = @{NSFontAttributeName: [UIFont boldSystemFontOfSize:18.0f], NSForegroundColorAttributeName: [UIColor darkGrayColor]};
    return [[NSAttributedString alloc] initWithString:text attributes:attributes];
}

//返回详情文字
- (NSAttributedString *)descriptionForEmptyDataSet:(UIScrollView *)scrollView{
    NSString *text = @"This allows you to share photos from your library and save photos to your camera roll.";
    NSMutableParagraphStyle *paragraph = [NSMutableParagraphStyle new];
    paragraph.lineBreakMode = NSLineBreakByWordWrapping;
    paragraph.alignment = NSTextAlignmentCenter;
    NSDictionary *attributes = @{NSFontAttributeName: [UIFont systemFontOfSize:14.0f], NSForegroundColorAttributeName: [UIColor lightGrayColor], NSParagraphStyleAttributeName: paragraph};
    return [[NSAttributedString alloc] initWithString:text attributes:attributes];
}


//返回可以点击的按钮 上面带文字
- (NSAttributedString *)buttonTitleForEmptyDataSet:(UIScrollView *)scrollView forState:(UIControlState)state{
    NSDictionary *attributes = @{NSFontAttributeName: [UIFont boldSystemFontOfSize:17.0f]};
    return [[NSAttributedString alloc] initWithString:@"Continue" attributes:attributes];
}

//返回可以点击的按钮 上面带图片
- (UIImage *)buttonImageForEmptyDataSet:(UIScrollView *)scrollView forState:(UIControlState)state{ return [UIImage imageNamed:@"button_image"];
}

//返回空白区域的颜色自定义
- (UIColor *)backgroundColorForEmptyDataSet:(UIScrollView *)scrollView{
    return [UIColor whiteColor];
}

//返回一个自定义的 view
- (UIView *)customViewForEmptyDataSet:(UIScrollView *)scrollView{
    UIActivityIndicatorView *activityView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    [activityView startAnimating];
    return activityView;
}

//此外,您还可以调整垂直对齐的内容视图(即:有用tableHeaderView时可见):返回间距离
- (CGFloat)verticalOffsetForEmptyDataSet:(UIScrollView *)scrollView{
    return -self.tableHeaderView.frame.size.height/2.0f;
}

#pragma mark - 委托实现
//要求知道空的状态应该渲染和显示 (Default is YES) :
- (BOOL)emptyDataSetShouldDisplay:(UIScrollView *)scrollView{
    return YES;
}

//是否允许点击 (默认是 YES) :
- (BOOL)emptyDataSetShouldAllowTouch:(UIScrollView *)scrollView{
    return YES;
}

//是否允许滚动 (默认是 NO):
- (BOOL)emptyDataSetShouldAllowScroll:(UIScrollView *)scrollView{
    return YES;
}

//空白区域点击响应:
- (void)emptyDataSetDidTapView:(UIScrollView *)scrollView{
    // Do something
}

//点击button 响应
- (void)emptyDataSetDidTapButton:(UIScrollView *)scrollView{
    // Do something
}

#pragma mark -  set tableView
- (void)clearTableFooterView{
    self.tableFooterView = [UIView new];
}

- (void)endReload{
    [self reloadData];
    [self endRefreshing];
    self.page ++;
}

-(UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event{
    id tView = [super hitTest:point withEvent:event];
//    if (![tView isKindOfClass:[UITextView class]] || ![tView isKindOfClass:[UITextField class]] || ![tView isKindOfClass:[XHMessageTextView class]]) {
//        NSLog(@"tvtvtv");
//        [self endEditing:YES];
//    }
    if (![tView isKindOfClass:[XHMessageTextView class]]) {
        if (self.saveQuestionAndFillValue) {
            self.saveQuestionAndFillValue();
        }
        [self endEditing:YES];
    }else
    if ([tView isKindOfClass:[XHMessageTextView class]]) {
//        if (self.saveQuestionAndFillValue) {
//            self.saveQuestionAndFillValue();
//        }
        XHMessageTextView *textView = (XHMessageTextView *)tView;
        [self endEditing:NO];
        if (self.clickInTextCallBack) {
            self.clickInTextCallBack(textView);
        }
    }
     return tView;
}


@end
