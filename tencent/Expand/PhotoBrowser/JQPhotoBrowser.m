//
//  JQPhotoBrowser.m
//  JQPhotoBrowser
//
//  Created by Evan on 15/9/24.
//  Copyright (c) 2015年 Evan. All rights reserved.
//

#import "JQPhotoBrowser.h"
#import "JQPhotoImageCell.h"
#import "JQPhotoItem.h"
#import "JQPhotoBrowserConfig.h"

@interface JQPhotoBrowser () <UICollectionViewDataSource,UICollectionViewDelegate>

@property (nonatomic, weak) UICollectionView *collectionView;

@property (nonatomic, strong) NSMutableArray *photoItemsArray;

@property (nonatomic, weak) UILabel *indexLabel;

@property (nonatomic, weak) UIButton *saveButton;

@property (nonatomic, strong) UITapGestureRecognizer *tapGuesture;

@end

@implementation JQPhotoBrowser

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor blackColor];
        self.tapGuesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(photoClick)];
    }
    return self;
}

#pragma makr - 懒加载控件
- (UICollectionView *)collectionView
{
    if (!_collectionView)
    {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        layout.itemSize = self.bounds.size;
        layout.minimumInteritemSpacing = 0;
        layout.minimumLineSpacing = 0;
        layout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
        
        UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:self.bounds collectionViewLayout:layout];
        collectionView.dataSource = self;
        collectionView.delegate = self;
        collectionView.pagingEnabled = YES;
        collectionView.bounces = NO;
        collectionView.allowsSelection = YES;
        collectionView.showsHorizontalScrollIndicator = NO;
        [collectionView registerClass:[JQPhotoImageCell class] forCellWithReuseIdentifier:@"PhotoImageCell"];
        
        [self addSubview:collectionView];
        
        _collectionView = collectionView;
    }
    return _collectionView;
}

- (NSMutableArray *)photoItemsArray
{
    if( !_photoItemsArray )
    {
        _photoItemsArray = [NSMutableArray array];
        for( int i = 0; i < self.imageCount; i ++ )
        {
            JQPhotoItem *photoItem = [[JQPhotoItem alloc] init];
            photoItem.imageIndex = i;
            UIImageView *imageView = [self.delegate photoBrowser:self imageViewForIndex:i];
            photoItem.placeholderImage = imageView.image;
            photoItem.contentMode = imageView.contentMode;
            photoItem.originImageFrame = [imageView.superview convertRect:imageView.frame toView:self];
            photoItem.highQualityImageURL = [self.delegate photoBrowser:self highQualityImageURLForIndex:i];
            [_photoItemsArray addObject:photoItem];
        }
    }
    return _photoItemsArray;
}

- (void)setupToolbars
{
    // 1. 序标
    UILabel *indexLabel = [[UILabel alloc] init];
    indexLabel.bounds = CGRectMake(0, 0, 80, 30);
    indexLabel.center = CGPointMake(self.bounds.size.width * 0.5, 30);
    indexLabel.textAlignment = NSTextAlignmentCenter;
    indexLabel.textColor = [UIColor whiteColor];
    indexLabel.font = [UIFont boldSystemFontOfSize:20];
    indexLabel.backgroundColor = [UIColor clearColor];
    if (self.imageCount > 1) {
        indexLabel.text = [NSString stringWithFormat:@"%ld/%ld",self.firstImageIndex+1,(long)self.imageCount];
    }
    _indexLabel = indexLabel;
    [self addSubview:indexLabel];
    
    // 2.保存按钮
    UIButton *saveButton = [[UIButton alloc] init];
    [saveButton setTitle:@"保存" forState:UIControlStateNormal];
    [saveButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    saveButton.backgroundColor = [UIColor colorWithRed:0.1f green:0.1f blue:0.1f alpha:0.90f];
    saveButton.frame = CGRectMake(30, self.bounds.size.height - 55, 50, 25);
    saveButton.layer.cornerRadius = 5;
    saveButton.clipsToBounds = YES;
    [saveButton addTarget:self action:@selector(saveImage) forControlEvents:UIControlEventTouchUpInside];
    [saveButton setHidden:YES];
    _saveButton = saveButton;
    [self addSubview:saveButton];
}

#pragma mark - 加载子视图
- (void)setupSubviews
{
    [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:self.firstImageIndex inSection:0] atScrollPosition:UICollectionViewScrollPositionLeft animated:NO];
    
    [self setupToolbars];
}

- (void)show
{
    UIWindow *window = [[UIApplication sharedApplication].windows lastObject];
    self.frame = window.bounds;
    self.hidden = YES;
    
    [window addSubview:self];
    
    [self addGestureRecognizer:self.tapGuesture];
    [self photoItemsArray];
    self.hidden = NO;
    
    [self showFirstImage];
}

- (void)hide
{
    [self removeGestureRecognizer:self.tapGuesture];
    self.collectionView.hidden = YES;
    self.saveButton.hidden = YES;
    self.indexLabel.hidden = YES;
}

#pragma mark - 第一张图片放大显示动画
- (void)showFirstImage
{
    _currentImageIndex = self.firstImageIndex;
    UIImageView *firstImageView = [self.delegate photoBrowser:self imageViewForIndex:self.firstImageIndex];
    
    UIImageView *imageView = [[UIImageView alloc] init];;
    imageView.frame = [firstImageView.superview convertRect:firstImageView.frame toView:self];
    imageView.image = firstImageView.image;
    imageView.contentMode = firstImageView.contentMode;
    CGSize imageSize = firstImageView.image.size;
    [self addSubview:imageView];

    CGFloat imageH;
    if( imageView.contentMode == UIViewContentModeScaleAspectFit )
    {
        imageH = self.frame.size.width * imageSize.height / imageSize.width;
    }
    else
    {
        imageH = self.frame.size.width * firstImageView.frame.size.height / firstImageView.frame.size.width;
    }
    [UIView animateWithDuration:JQPhotoBrowserShowImageAnimationDuration animations:^{
        imageView.frame = CGRectMake(self.center.x - self.frame.size.width * 0.5, self.center.y - imageH * 0.5, self.frame.size.width, imageH);
    } completion:^(BOOL finished) {
        [imageView removeFromSuperview];
        [self setupSubviews];
    }];
}

#pragma mark - 图片点击事件
- (void)photoClick
{
    NSLog(@"photoClick %ld",_currentImageIndex);
    NSUInteger currentImageIndex = self.currentImageIndex;
    
    // 隐藏
    [self hide];
    
    JQPhotoImageCell *cell = (JQPhotoImageCell *)[self.collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForRow:currentImageIndex inSection:0]];
    CGRect imageViewFrame = [cell.imageView.superview convertRect:cell.imageView.frame toView:self];
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:imageViewFrame];
    imageView.image = cell.imageView.image;
    imageView.contentMode = cell.imageView.contentMode;
    [self addSubview:imageView];
    
    self.backgroundColor = [UIColor clearColor];
    CGRect frame = cell.photoItem.originImageFrame;
    [UIView animateWithDuration:JQPhotoBrowserHideImageAnimationDuration animations:^{
        imageView.frame = frame;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

#pragma mark - UICollectionViewDelegate
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.photoItemsArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    JQPhotoImageCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"PhotoImageCell" forIndexPath:indexPath];
    cell.photoItem = self.photoItemsArray[indexPath.row];
    return cell;
}

#pragma mark - 更新序标
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    NSInteger currentIndex = (scrollView.contentOffset.x + scrollView.frame.size.width*0.5) / scrollView.frame.size.width;
    if (_currentImageIndex != currentIndex) {
        _currentImageIndex = currentIndex;
        self.indexLabel.text = [NSString stringWithFormat:@"%ld/%ld", currentIndex+1,(long)self.imageCount];
    }
}

#pragma mark - 保存图片
- (void)saveImage
{
    JQPhotoItem *photoItem = self.photoItemsArray[[self currentImageIndex]];
    UIImageWriteToSavedPhotosAlbum(photoItem.highQualityImage, self, @selector(imageSavedToPhotosAlbum:didFinishSavingWithError:contextInfo:), nil);
}

- (void)imageSavedToPhotosAlbum:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo
{
    NSString *message = @"呵呵";
    if (!error) {
        message = JQPhotoBrowserSaveImageSuccessText;
    }else
    {
        message = [error description];
    }
    NSLog(@"message is %@",message);
    NSLog(@"%@",contextInfo);
}


@end
