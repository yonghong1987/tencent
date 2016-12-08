//
//  CSPhotosView.m
//  tencent
//
//  Created by admin on 16/5/23.
//  Copyright © 2016年 cyh. All rights reserved.
//

#import "CSPhotosView.h"
#import "UIImageView+AFNetworking.h"
#import "JQPhotoBrowser.h"

#define kQuesColumnCount 3
@interface CSPhotosView () <JQPhotoBrowserDelegate>
{
    CGSize _photoViewSize;  //单图Size
    UIEdgeInsets _photoViewEdge;  //单图的Edge
}
@property (nonatomic, strong) NSMutableArray *addPhotos;
@end


@implementation CSPhotosView


- (id)initWithFrame:(CGRect)frame photoViewSize:(CGSize)size UIEdgeInset:(UIEdgeInsets)edg{
    self = [super initWithFrame:frame];
    if ( self ) {
        _photoViewEdge = edg;
        _photoViewSize = size;
        self.addPhotos = [NSMutableArray array];
    }
    return self;
}

- (void)setPhotosAry:(NSMutableArray *)inImg{
    _photosAry = inImg;
    CGFloat imageW = _photoViewSize.width;
    CGFloat imageH = _photoViewSize.height;
    for (NSInteger i = 0; i < inImg.count; i ++) {
        if (i >= self.addPhotos.count ) {
//            [self createPhotoViewAtIndex:i];
            UIImageView *imageView = [[UIImageView alloc] init];
            imageView.frame = CGRectMake(i % kQuesColumnCount * imageW + i % 3 * 10  , i / kQuesColumnCount * imageH + i / 3 * 10, imageW, imageH);
            imageView.tag = i;
            imageView.userInteractionEnabled = YES;
            [imageView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageClick:)]];
            imageView.backgroundColor = [UIColor clearColor];
            [self addSubview:imageView];
            [self.addPhotos addObject:imageView];

            
        }
        UIImageView *imageView = self.addPhotos[i];
        imageView.hidden = NO;
        [imageView setImageWithURL:[NSURL URLWithString:inImg[i]] placeholderImage:[UIImage imageNamed:@"catalog_default"]];
    }
    if (inImg.count < self.addPhotos.count) {
        for (NSInteger i = self.addPhotos.count; i > inImg.count; i--) {
            UIImageView *imageView = self.addPhotos[i-1];
            imageView.hidden = YES;
            [self.addPhotos removeObjectAtIndex:(i-1)];
        }
    }
}

#pragma mark - 创建单个图片视图
- (void)createPhotoViewAtIndex:(NSInteger)index{
    NSInteger x = index % kQuesColumnCount;
    NSInteger y = index / kQuesColumnCount;
    CGFloat imageW = _photoViewSize.width;
    CGFloat imageH = _photoViewSize.height;
//    CGFloat imageX = x * (imageW + _photoViewEdge.right);
//    CGFloat imageY = y * (imageH + _photoViewEdge.bottom);
    CGFloat imageX = x * (imageW + _photoViewEdge.right);
    CGFloat imageY = y * (imageH + _photoViewEdge.bottom);
    UIImageView *imageView = [[UIImageView alloc] init];
    imageView.frame = CGRectMake(imageX, imageY, imageW, imageH);
    imageView.tag = index;
    imageView.userInteractionEnabled = YES;
    [imageView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageClick:)]];
    imageView.backgroundColor = [UIColor clearColor];
    [self addSubview:imageView];
    [self.addPhotos addObject:imageView];
}

#pragma mark - 手势单击，图片浏览大图
- (void)imageClick:(UITapGestureRecognizer *)tap {
    JQPhotoBrowser *brower = [[JQPhotoBrowser alloc] init];
    brower.imageCount = _addPhotos.count;
    brower.firstImageIndex = tap.view.tag;
    brower.delegate = self;
    [brower show];
}

#pragma mark - JQPhotoBrowserDelegate
- (UIImageView *)photoBrowser:(JQPhotoBrowser *)browser imageViewForIndex:(NSInteger)index{
    return self.addPhotos[index];
}

- (NSURL *)photoBrowser:(JQPhotoBrowser *)browser highQualityImageURLForIndex:(NSInteger)index{
    return nil;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
