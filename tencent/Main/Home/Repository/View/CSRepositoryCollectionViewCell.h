//
//  CSRepositoryCollectionViewCell.h
//  tencent
//
//  Created by bill on 16/4/27.
//  Copyright © 2016年 cyh. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "CSRepositoryModel.h"

@interface CSRepositoryCollectionViewCell : UICollectionViewCell

@property (strong, nonatomic)  UIButton *selectedBtn;
@property (nonatomic, strong) CSRepositoryModel *model;
@property (strong, nonatomic)  UIImageView *unreadMarkImg;
@end
