//
//  CSRadioAnswerCell.h
//  tencent
//
//  Created by cyh on 16/7/27.
//  Copyright © 2016年 cyh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CSOptionModel.h"
@interface CSRadioAnswerCell : UITableViewCell
/**
 *  背景图片
 */
@property (nonatomic, strong) UIView *backView;
/**
 *  是否勾选的图片
 */
@property (nonatomic, strong) UIImageView *optionImg;
/**
 *  选项的内容
 */
@property (nonatomic, strong) UILabel *optionTextLabel;
/**
 *  选项model
 */
@property (nonatomic, strong) CSOptionModel *optionModel;
/**
 *  选项百分比图片
 */
@property (nonatomic, strong) UIImageView *percentImg;
/**
 *  选项百分比
 */
@property (nonatomic, strong) UILabel *percentLabel;
@end
