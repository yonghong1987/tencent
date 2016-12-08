//
//  JQNavTabBarController.m
//  JQNavTabBarController
//
//  Created by Evan on 16/4/22.
//  Copyright © 2016年 Evan. All rights reserved.
//

#import "JQNavTabBarController.h"
#import "JQNavTabBar.h"

@interface JQNavTabBarController () <UICollectionViewDataSource,UICollectionViewDelegate, JQNavTabBarDelegate>
/*
 **切换到的当前位置
 */
@property (nonatomic, assign) NSInteger currentIndex;

@property (nonatomic, weak) UICollectionView *collectionView;

@property (nonatomic, weak) JQNavTabBar *navTabBar;


@end

@implementation JQNavTabBarController

- (instancetype)init
{
    if (self = [super init])
    {
        _bounces = NO;
        _scrollEnabled = YES;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.automaticallyAdjustsScrollViewInsets = NO;

    if (self.preferredContentSize.width && self.preferredContentSize.height) {
        self.view.frame = CGRectMake(0, 0, self.preferredContentSize.width, self.preferredContentSize.height);
    }
        [self reloadView];
}

- (void)setViewControllers:(NSMutableArray *)viewControllers
{
    _viewControllers = viewControllers;
    
    for (UIViewController *vc in viewControllers) {
        [self addChildViewController:vc];
    }
}

- (void)reloadView
{
    [self.collectionView reloadData];
    
    self.navTabBar.tagsList = [self.viewControllers valueForKey:@"title"];
}

#pragma mark - UICollectionViewDelegate
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.viewControllers.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kItemIdentifier forIndexPath:indexPath];
    for (UIView *v in cell.contentView.subviews) {
        [v removeFromSuperview];
    }
    
    UIViewController *viewController = self.viewControllers[indexPath.row];
    viewController.preferredContentSize = cell.bounds.size;
    [cell.contentView addSubview:viewController.view];
    return cell;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    _currentIndex = (scrollView.contentOffset.x + self.collectionView.frame.size.width * 0.5)  / self.collectionView.frame.size.width;
    
    if( _currentIndex != self.navTabBar.currentItemIndex )
    {
        [self.navTabBar selectItemAtIndex:_currentIndex scrollAnimated:NO];
    }
}

- (void)navTabBar:(JQNavTabBar *)navTabBar didSelectedItemWithIndex:(NSInteger)index animated:(BOOL)animated
{
    [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:index inSection:0] atScrollPosition:UICollectionViewScrollPositionLeft animated:animated];
}

#pragma mark - Setter/Getter
static NSString * const kItemIdentifier = @"ItemCell";
- (UICollectionView *)collectionView
{
    if (!_collectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0,44, self.view.frame.size.width, self.view.frame.size.height - 44) collectionViewLayout:layout];
        collectionView.dataSource = self;
        collectionView.delegate = self;
        collectionView.pagingEnabled = YES;
        collectionView.bounces = self.bounces;
        collectionView.scrollEnabled = self.scrollEnabled;
        collectionView.showsHorizontalScrollIndicator = NO;
        collectionView.backgroundColor = [UIColor whiteColor];
        [collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:kItemIdentifier];
        
        layout.minimumLineSpacing = 0;
        layout.minimumInteritemSpacing = 0;
        layout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        layout.itemSize = collectionView.frame.size;
        [self.view addSubview:collectionView];
        _collectionView = collectionView;
    }
    return _collectionView;
}

- (JQNavTabBar *)navTabBar
{
    if (!_navTabBar)
    {
        JQNavTabBar *navTabBar = [[JQNavTabBar alloc] init];
        navTabBar.frame = CGRectMake(0, 0, self.view.frame.size.width, 44);
        navTabBar.delegate = self;
        
        [self.view addSubview:navTabBar];
        _navTabBar = navTabBar;
    }
    return _navTabBar;
}

@end
