//
//  CSCheckPointCell.h
//  tencent
//
//  Created by cyh on 16/8/3.
//  Copyright © 2016年 cyh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CSCheckPointModel.h"
@interface CSCheckPointCell : UICollectionViewCell
/**
 *关卡图片
 */
@property (nonatomic, strong) UIImageView *checkPointIV;
/**
 *关卡锁定图片
 */
@property (nonatomic, strong) UIImageView *lockIV;
@property (nonatomic, strong) CSCheckPointModel *checkPointModel;
@end
