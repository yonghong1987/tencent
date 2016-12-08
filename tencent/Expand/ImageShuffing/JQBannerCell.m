//
//  JQBannerCell.m
//  XCar
//
//  Created by Evan on 15/10/10.
//  Copyright © 2015年 Evan. All rights reserved.
//

#import "JQBannerCell.h"
#import "UIImageView+WebCache.h"

@interface JQBannerCell ()

@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@end

@implementation JQBannerCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setImageUrl:(NSString *)imageUrl
{
    _imageUrl = imageUrl;
    [self.imageView sd_setImageWithURL:[NSURL URLWithString:imageUrl] placeholderImage:[UIImage imageNamed:@"loadingtencent750"]];
}

@end
