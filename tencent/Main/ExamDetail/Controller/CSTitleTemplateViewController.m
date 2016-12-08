//
//  CSTitleTemplateViewController.m
//  tencent
//
//  Created by cyh on 16/8/16.
//  Copyright © 2016年 cyh. All rights reserved.
//

#import "CSTitleTemplateViewController.h"

@interface CSTitleTemplateViewController ()

@end

@implementation CSTitleTemplateViewController
static NSString * const kItemIdentifier = @"ItemCell";
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
    self.automaticallyAdjustsScrollViewInsets = NO;
    if (self.preferredContentSize.width && self.preferredContentSize.height) {
        self.view.frame = CGRectMake(0, 0, self.preferredContentSize.width, self.preferredContentSize.height);
    }
    [self.collectionView reloadData];
    // Do any additional setup after loading the view.
}

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.viewControllers.count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kItemIdentifier forIndexPath:indexPath];
    for (UIView *view in cell.contentView.subviews) {
        [view removeFromSuperview];
    }
    UIViewController *viewController = self.viewControllers[indexPath.row];
    viewController.preferredContentSize = cell.bounds.size;
    [cell.contentView addSubview:viewController.view];
    return cell;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    _currentIndex = (scrollView.contentOffset.x + self.collectionView.frame.size.width * 0.5)  / self.collectionView.frame.size.width;
    if (self.delega && [self.delega respondsToSelector:@selector(passCollectionViewScrollWhichIndex:)]) {
        [self.delega passCollectionViewScrollWhichIndex:_currentIndex];
    }
}

-(void)setViewControllers:(NSMutableArray *)viewControllers{
    _viewControllers = viewControllers;
    for (UIViewController *vc in viewControllers) {
        [self addChildViewController:vc];
    }
}

-(UICollectionView *)collectionView{
    if (!_collectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0,0, self.view.frame.size.width, self.view.frame.size.height) collectionViewLayout:layout];
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

@end
