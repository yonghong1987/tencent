//
//  JQPhotoImageCell.m
//  JQPhotoBrowser
//
//  Created by Evan on 15/9/25.
//  Copyright (c) 2015年 Evan. All rights reserved.
//

#import "JQPhotoImageCell.h"
#import "UIImageView+WebCache.h"

@interface JQPhotoImageCell () <UIScrollViewDelegate>

@property (nonatomic, weak) UIScrollView *scrollView;

@end

@implementation JQPhotoImageCell

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
    }
    return self;
}

- (UIScrollView *)scrollView
{
    if( !_scrollView )
    {
        UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:self.bounds];
        scrollView.delegate = self;
        scrollView.maximumZoomScale = 2.0;
        scrollView.minimumZoomScale = 1.0;
        scrollView.bounces = NO;
        scrollView.showsVerticalScrollIndicator = NO;
        scrollView.showsHorizontalScrollIndicator = NO;
        [self addSubview:scrollView];
        _scrollView = scrollView;
    }
    return _scrollView;
}

- (UIImageView *)imageView
{
    if( !_imageView )
    {
        UIImageView *imageView = [[UIImageView alloc] init];
        [self.scrollView addSubview:imageView];

        _imageView = imageView;
    }
    return _imageView;
}

- (void)setPhotoItem:(JQPhotoItem *)photoItem
{
    _photoItem = photoItem;
    
    self.imageView.contentMode = photoItem.contentMode;
    [self.imageView sd_setImageWithURL:photoItem.highQualityImageURL placeholderImage:photoItem.placeholderImage options:SDWebImageCacheMemoryOnly progress:^(NSInteger receivedSize, NSInteger expectedSize) {

    } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        
        if( error )
        {
            self.imageView.image = photoItem.placeholderImage;
        }
        
        self.scrollView.zoomScale = 1.0;
        
        CGFloat imageW = self.scrollView.frame.size.width;
        CGFloat imageH;
        if( photoItem.contentMode == UIViewContentModeScaleAspectFit )
        {
            imageH = imageW * image.size.height / image.size.width;
        }
        else
        {
            imageH = self.scrollView.frame.size.width * photoItem.originImageFrame.size.height / photoItem.originImageFrame.size.width;
        }
        
        self.imageView.frame = CGRectMake(0, 0, imageW, imageH);
        if( imageH < self.scrollView.frame.size.height )
        {
            // 图片高度小于屏幕高度
            self.imageView.center = self.scrollView.center;
        }
        else
        {
            // 图片高度大于屏幕高度 把图片滚动到屏幕中央
            self.scrollView.contentSize = CGSizeMake(imageW, imageH);
            self.scrollView.contentOffset = CGPointMake(0, self.scrollView.contentSize.height*0.5 - self.frame.size.height * 0.5);
        }
        self.photoItem.highQualityImage = image;
    }];
}

//告诉scrollview要缩放的是哪个子控件
- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return self.imageView;
}

- (void)scrollViewDidZoom:(UIScrollView *)scrollView
{
    [self updataImageViewCenter];
}

- (void)updataImageViewCenter
{
    CGFloat offsetX = (self.scrollView.bounds.size.width > self.scrollView.contentSize.width)?(self.scrollView.bounds.size.width - self.scrollView.contentSize.width)/2 : 0.0;
    
    CGFloat offsetY = (self.scrollView.bounds.size.height > self.scrollView.contentSize.height)?(self.scrollView.bounds.size.height - self.scrollView.contentSize.height)/2 : 0.0;
    
    self.imageView.center = CGPointMake(self.scrollView.contentSize.width/2 + offsetX,self.scrollView.contentSize.height/2 + offsetY);
}

@end
