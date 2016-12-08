//
//  CSHomeMenuTableCell.h
//  tencent
//
//  Created by sunon002 on 16/4/27.
//  Copyright © 2016年 cyh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIView+SDAutoLayout.h"
@interface CSHomeMenuTableCell : UITableViewCell<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>
/*
 **条目数组
 */
@property (nonatomic, strong) NSArray *menuItems;
/*
 **图标数组
 */
@property (nonatomic, strong) NSArray *icons;
/*
 **背景颜色数组
 */
@property (nonatomic, strong) NSArray *colors;
@property (nonatomic, strong) UICollectionView *collectionView;
/*
 **模板
 */
@property (nonatomic, copy) NSString *model;
/**
 *未读专题数
 */
@property (nonatomic, assign) NSInteger seminarTotal;
/**
 *未读知识库
 */
@property (nonatomic, assign) NSInteger knowLedgeTotal;
@end
