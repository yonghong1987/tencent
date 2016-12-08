//
//  JQNavTabBar.m
//  JQNavTabBarController
//
//  Created by Evan on 16/4/22.
//  Copyright © 2016年 Evan. All rights reserved.
//

#import "JQNavTabBar.h"
#import "JQNavTabBarTagCell.h"
#import "CSFrameConfig.h"
#import "CSColorConfig.h"
#define kLastBtnWidth 44
#define kSectionPadding 0

@interface JQNavTabBar () <UICollectionViewDataSource,UICollectionViewDelegate>

@property (nonatomic, weak) UICollectionView *collectionView;
/*
 **切换到最后个menu的按钮
 */
@property (nonatomic, weak) UIButton *lastBtn;
/*
 **跟着滑动的线
 */
@property (nonatomic, weak) UIView *underline;
/*
 **内容的宽度
 */
@property (assign, nonatomic) CGFloat contentWidth;

@end

@implementation JQNavTabBar

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        self.backgroundColor = [UIColor whiteColor];
//        self.itemSelectedColor = [UIColor colorWithRed:59/255.0 green:164/255.0 blue:210/255.0 alpha:1];
        self.itemSelectedColor = kCSThemeColor;
        self.itemNormalColor = [UIColor blackColor];
        _maxColunm = 4;
    }
    return self;
}

- (void)setTagsList:(NSArray *)tagsList
{
    _tagsList = tagsList;
    
    if (tagsList.count >= _maxColunm) {
        [self lastBtn];
        self.contentWidth = kCSScreenWidth - kLastBtnWidth;
    }else{
        self.contentWidth = kCSScreenWidth;
    }
    [self.collectionView reloadData];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self underline];
    });
}

- (void)selectItemAtIndex:(NSInteger)selectIndex scrollAnimated:(BOOL)animated
{
    JQNavTabBarTagCell *deselectedCell = (JQNavTabBarTagCell *)[self.collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForRow:self.currentItemIndex inSection:0]];
    [deselectedCell.titleLabel setTextColor:self.itemNormalColor];
    
    JQNavTabBarTagCell *selectedCell = (JQNavTabBarTagCell *)[self.collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForRow:selectIndex inSection:0]];
//    [selectedCell.titleLabel setTextColor:self.itemSelectedColor];
    [selectedCell.titleLabel setTextColor:self.itemNormalColor];

    self.currentItemIndex = selectIndex;
    
    [UIView animateWithDuration:0.3 animations:^{
        self.underline.frame = CGRectMake(selectedCell.frame.origin.x, self.underline.frame.origin.y, selectedCell.frame.size.width, self.underline.frame.size.height);
    }];

    [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:selectIndex inSection:0] atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:YES];
    
}

- (void)scrollToLastAction
{
    NSInteger index = self.tagsList.count - 1;
    if ([self.delegate respondsToSelector:@selector(navTabBar:didSelectedItemWithIndex:animated:)]) {
        [self.delegate navTabBar:self didSelectedItemWithIndex:index animated:NO];
    }
    CGFloat tageContentWidth = self.collectionView.contentSize.width;
    CGFloat tagWidth = self.contentWidth / _maxColunm;
    [UIView animateWithDuration:0.3 animations:^{
        self.underline.frame = CGRectMake(tageContentWidth - tagWidth, self.underline.frame.origin.y, tagWidth, self.underline.frame.size.height);
    }];
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.tagsList.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    JQNavTabBarTagCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kItemIdentifier forIndexPath:indexPath];
    cell.titleLabel.text = self.tagsList[indexPath.row];
    if (self.currentItemIndex == indexPath.row) {
//        [cell.titleLabel setTextColor:self.itemSelectedColor];
        [cell.titleLabel setTextColor:self.itemNormalColor];

    }else{
        [cell.titleLabel setTextColor:self.itemNormalColor];
    }
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if ([self.delegate respondsToSelector:@selector(navTabBar:didSelectedItemWithIndex:animated:)]) {
        [self.delegate navTabBar:self didSelectedItemWithIndex:indexPath.row animated:NO];
    }
}

#pragma mark - getter
static NSString * const kItemIdentifier = @"TagCell";
- (UICollectionView *)collectionView
{
    if (!_collectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.minimumLineSpacing = 0;
        layout.minimumInteritemSpacing = 0;
        layout.sectionInset = UIEdgeInsetsMake(0, kSectionPadding, 0, kSectionPadding);
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        if (self.tagsList.count > self.maxColunm) {
            layout.itemSize = CGSizeMake(self.contentWidth / _maxColunm, self.frame.size.height);
        }else{
         layout.itemSize = CGSizeMake(self.contentWidth / self.tagsList.count, self.frame.size.height);
        }
        UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, self.contentWidth - kSectionPadding , self.frame.size.height) collectionViewLayout:layout];
        collectionView.dataSource = self;
        collectionView.delegate = self;
        collectionView.pagingEnabled = YES;
        collectionView.bounces = NO;
        collectionView.scrollEnabled = YES;
        collectionView.showsHorizontalScrollIndicator = NO;
        collectionView.backgroundColor = [UIColor whiteColor];
        
        [collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([JQNavTabBarTagCell class]) bundle:nil] forCellWithReuseIdentifier:kItemIdentifier];
        
        [self addSubview:collectionView];
        _collectionView = collectionView;
    }
    return _collectionView;
}

- (UIButton *)lastBtn
{
    if (!_lastBtn) {
        UIButton *lastBtn = [[UIButton alloc] init];
        [lastBtn setImage:[UIImage imageNamed:@"icon_turnright"] forState:UIControlStateNormal];
        [lastBtn setImageEdgeInsets:UIEdgeInsetsMake(10, 15, 10, 15)];
        lastBtn.frame = CGRectMake(self.frame.size.width - kLastBtnWidth, 0, kLastBtnWidth, self.frame.size.height);
        [lastBtn addTarget:self action:@selector(scrollToLastAction) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:lastBtn];
        _lastBtn = lastBtn;
    }
    return _lastBtn;
}

- (UIView *)underline
{
    if (!_underline) {
        JQNavTabBarTagCell *currentCell = (JQNavTabBarTagCell *)[self.collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForRow:self.currentItemIndex inSection:0]];
        UIView *line = [[UIView alloc] init];
        line.frame = CGRectMake(currentCell.frame.origin.x, self.frame.size.height - 3, currentCell.frame.size.width, 3);
        line.backgroundColor = self.itemSelectedColor;
        [self.collectionView addSubview:line];
        _underline = line;
    }
    return _underline;
}

@end
