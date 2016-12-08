//
//  JQPhotoImageCell.h
//  JQPhotoBrowser
//
//  Created by Evan on 15/9/25.
//  Copyright (c) 2015年 Evan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JQPhotoItem.h"

@interface JQPhotoImageCell : UICollectionViewCell

@property (nonatomic, strong) JQPhotoItem *photoItem;

@property (nonatomic, weak) UIImageView *imageView;

@end
