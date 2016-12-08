//
//  CSStudyCaseCell.h
//  tencent
//
//  Created by admin on 16/5/12.
//  Copyright © 2016年 cyh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CSStudyCaseModel.h"
@interface CSStudyCaseCell : UITableViewCell
/**
 *  案列对象
 */
@property (nonatomic, strong) CSStudyCaseModel *studyCaseModel;
/**
 *  背景图片(颜色)
 */
@property (nonatomic, strong) UIView *backView;
/**
 *  标签图片
 */
@property (nonatomic, strong) UIImageView *catalogNameImg;
/**
 *  标签名称
 */
@property (nonatomic, strong) UILabel *catalogNameLabel;
/**
 *  案列图片
 */
@property (nonatomic, strong) UIImageView *caseImg;
/**
 *  案列名称
 */
@property (nonatomic, strong) UILabel *caseNameLabel;
/**
 *  案列修改日期
 */
@property (nonatomic, strong) UILabel *modifiedDateLabel;
@end
