//
//  JQNavTabBarTagCell.h
//  JQNavTabBarController
//
//  Created by Evan on 16/4/25.
//  Copyright © 2016年 Evan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JQNavTabBarTagCell : UICollectionViewCell
/*
 **标题
 */
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
/*
 **下面滑动的线
 */
@property (weak, nonatomic) IBOutlet UIImageView *lineIV;

@end
