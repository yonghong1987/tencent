//
//  JQBannerView.m
//  XCar
//
//  Created by Evan on 15/10/10.
//  Copyright © 2015年 Evan. All rights reserved.
//

#import "JQBannerView.h"
#import "JQBannerCell.h"

@interface JQBannerView ()<UICollectionViewDataSource,UICollectionViewDelegate>

@property (weak, nonatomic) UICollectionView *collectionView;
@property (weak, nonatomic) UIPageControl *pageControl;

@end

@implementation JQBannerView

#pragma mark controlInit
- (UIPageControl *)pageControl
{
    if (!_pageControl) {
        UIPageControl *pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(self.frame.size.width*0.5 - 60, self.frame.size.height - 37, 120, 37)];
        pageControl.currentPageIndicatorTintColor = [UIColor colorWithRed:70/255.0 green:188/255.0 blue:98/255.0 alpha:1];
        pageControl.pageIndicatorTintColor = [UIColor lightGrayColor];
        pageControl.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        [self addSubview:pageControl];
        
        _pageControl = pageControl;
    }
    return _pageControl;
}


static NSString * const kItemIdentifier = @"BannerCell";

- (UICollectionView *)collectionView
{
    if (!_collectionView)
    {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        layout.itemSize = self.bounds.size;
        layout.sectionInset = UIEdgeInsetsZero;
        layout.minimumLineSpacing = 0;
        
        UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:self.bounds collectionViewLayout:layout];
        collectionView.dataSource = self;
        collectionView.delegate = self;
        collectionView.pagingEnabled = YES;
        collectionView.bounces = NO;
        collectionView.showsHorizontalScrollIndicator = NO;
        
        [collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([JQBannerCell class]) bundle:nil] forCellWithReuseIdentifier:kItemIdentifier];
        
        [self addSubview:collectionView];
        [self sendSubviewToBack:collectionView];
        
        _collectionView = collectionView;
    }
    return _collectionView;
}

- (void)setBannerArray:(NSArray *)bannerArray
{
    [self removeTimer];
    NSMutableArray *tempArray  = [NSMutableArray array];
    if (bannerArray.count >= 2)
    {
        [tempArray addObject:bannerArray.lastObject];
        [tempArray addObjectsFromArray:bannerArray];
        [tempArray addObject:bannerArray.firstObject];
        
        _bannerArray = tempArray;
        
        [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0] atScrollPosition:UICollectionViewScrollPositionLeft animated:NO];
    }
    else if( bannerArray.count == 1 )
    {
        [tempArray addObjectsFromArray:bannerArray];
        _bannerArray = tempArray;
        [self.collectionView reloadData];
    }
    self.pageControl.numberOfPages = bannerArray.count;
    [self addTimer];
}

- (void)setCurrentPageIndicatorTintColor:(UIColor *)currentPageIndicatorTintColor
{
    _currentPageIndicatorTintColor = currentPageIndicatorTintColor;
    
    self.pageControl.currentPageIndicatorTintColor = currentPageIndicatorTintColor;
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.bannerArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    JQBannerCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kItemIdentifier forIndexPath:indexPath];
    
    cell.imageUrl = self.bannerArray[indexPath.row];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.didSelectItemAtIndex) {
        self.didSelectItemAtIndex((indexPath.row - 1 + self.bannerArray.count)%self.bannerArray.count);
    }
}

#pragma mark - 定时器方法
- (void)addTimer
{
    self.timer = [NSTimer scheduledTimerWithTimeInterval:2 target:self selector:@selector(autoScroll) userInfo:nil repeats:YES];
    
    [[NSRunLoop currentRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
}

- (void)removeTimer
{
    // 当定时器调用了invalidate就无法重新再启动
    [self.timer invalidate];
    self.timer = nil;
}

- (void)dealloc
{
    [self.timer invalidate];
    self.timer = nil;
}

#pragma mark - 辅助逻辑代码
- (void)autoScroll
{
    if (self.bannerArray.count < 2) {
        [self removeTimer];
        return;
    }
    
    NSInteger index = self.pageControl.currentPage + 2;
    // 确定下一页页数
    [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:index inSection:0] atScrollPosition:UICollectionViewScrollPositionLeft animated:YES];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    NSInteger index = (scrollView.contentOffset.x + scrollView.frame.size.width*0.5) / scrollView.frame.size.width;

    NSInteger numberOfItem = self.pageControl.numberOfPages;
    if (numberOfItem) {
        self.pageControl.currentPage = (index - 1 + numberOfItem) % numberOfItem;
        
        if (scrollView.contentOffset.x == 0) {
            [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:self.pageControl.currentPage+1 inSection:0] atScrollPosition:UICollectionViewScrollPositionLeft animated:NO];
        }
        else if( scrollView.contentOffset.x >= scrollView.frame.size.width * (numberOfItem + 1) )
        {
            [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:self.pageControl.currentPage+1 inSection:0] atScrollPosition:UICollectionViewScrollPositionLeft animated:NO];
        }
    }
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self removeTimer];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    [self addTimer];
}

@end
