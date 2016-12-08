//
//  JQPhotoBrowser.h
//  JQPhotoBrowser
//
//  Created by Evan on 15/9/24.
//  Copyright (c) 2015年 Evan. All rights reserved.
//

/*
 依赖SDWebImage库
 */

#import <UIKit/UIKit.h>

@class JQPhotoBrowser;

@protocol JQPhotoBrowserDelegate <NSObject>

//// 返回临时占位图片（即原来的小图）
//- (UIImage *)photoBrowser:(JQPhotoBrowser *)browser placeholderImageForIndex:(NSInteger)index;
//
//// 返回临时占位图片（即原来的小图）
//- (CGRect)photoBrowser:(JQPhotoBrowser *)browser frameImageForIndex:(NSInteger)index;

- (UIImageView *)photoBrowser:(JQPhotoBrowser *)browser imageViewForIndex:(NSInteger)index;

- (NSURL *)photoBrowser:(JQPhotoBrowser *)browser highQualityImageURLForIndex:(NSInteger)index;

@end

@interface JQPhotoBrowser : UIView

@property (nonatomic, assign) NSUInteger firstImageIndex;

@property (nonatomic, assign) NSInteger imageCount;

@property (nonatomic, weak) id<JQPhotoBrowserDelegate> delegate;

@property (nonatomic, readonly) NSUInteger currentImageIndex;

- (void)show;



@end
