//
//  CSTitleTemplateViewController.h
//  tencent
//
//  Created by cyh on 16/8/16.
//  Copyright © 2016年 cyh. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CSTitleTemplateDelegate <NSObject>

- (void)passCollectionViewScrollWhichIndex:(NSInteger)index;

@end

@interface CSTitleTemplateViewController : UIViewController<UICollectionViewDelegate,UICollectionViewDataSource>
/*
 **切换到的当前位置
 */
@property (nonatomic, assign) NSInteger currentIndex;
/**
 *控制器数组
 */
@property (nonatomic, strong) NSMutableArray *viewControllers;
@property (assign, nonatomic) BOOL bounces;
/**
 *  是否滚动
 */
@property(nonatomic,getter=isScrollEnabled) BOOL scrollEnabled;
@property (nonatomic, strong) UICollectionView *collectionView;

@property (nonatomic, weak) id<CSTitleTemplateDelegate> delega;
@end
