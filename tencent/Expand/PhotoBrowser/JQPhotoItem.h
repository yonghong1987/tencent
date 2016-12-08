//
//  JQPhotoItem.h
//  JQPhotoBrowser
//
//  Created by Evan on 15/9/26.
//  Copyright © 2015年 Evan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface JQPhotoItem : NSObject

@property (nonatomic        ) NSInteger         imageIndex;

@property (nonatomic, strong) UIImage           *placeholderImage;

@property (nonatomic, strong) UIImage           *highQualityImage;

@property (nonatomic, strong) NSURL             *highQualityImageURL;

@property (nonatomic        ) CGRect            originImageFrame;

@property (nonatomic        ) UIViewContentMode contentMode;

@end
