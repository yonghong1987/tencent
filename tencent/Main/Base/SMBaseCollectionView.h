//
//  SMBaseCollectionView.h
//  sunMobile
//
//  Created by duck on 16/7/11.
//  Copyright © 2016年 www.sunontalent.com. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^RefreshComponentHeaderRefreshingBlock)(void);
typedef void(^RefreshComponentFooterRefreshingBlock)(void);

typedef NS_ENUM(NSInteger , SMBaseTableViewRefreshState) {
    /**
     *  下刷
     */
    SMBaseTableViewRefreshStateHeader,
    /**
     *  上刷
     */
    SMBaseTableViewRefreshStateFooter
    
};

@interface SMBaseCollectionView : UICollectionView
/**
 *  ofSection - 以第几个 section  为目标 page
 */
@property (nonatomic ,assign) NSInteger ofSection;
/**
 *  分页
 */
@property (nonatomic ,assign) NSInteger page;

/**
 *  刷新模式
 */
@property (nonatomic ,assign) SMBaseTableViewRefreshState refreshState;

/**
 *  设置刷新
 *
 *  @param componentHeaderRefreshingBlock 下刷成功回调
 *  @param componentFooterRefreshingBlock 上刷成功回调
 */
- (void)refreshHeaderRefresh:(RefreshComponentHeaderRefreshingBlock)componentHeaderRefreshingBlock  withFooterRefreshingBlock:(RefreshComponentFooterRefreshingBlock)componentFooterRefreshingBlock;


/**
 *  主动刷新
 */
- (void)beginRefreshing;
/**
 *  结束刷新<结束下刷控件>
 */
- (void)endRefreshing;

/**
 *  刷新数据 <需要刷新数据的时候调用>
 */
- (void)endReload;

@end
