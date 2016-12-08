//
//  CSStudySkillCell.h
//  tencent
//
//  Created by admin on 16/5/16.
//  Copyright © 2016年 cyh. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "CSStudySkillModel.h"
@interface CSStudySkillCell : UITableViewCell

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
 *  考试状态名称
 */
@property (nonatomic, strong) UILabel *examStatusLabel;
/**
 *  考试标题
 */
@property (nonatomic, strong) UILabel *examTitleLabel;
/**
 *  考试起止时间
 */
@property (nonatomic, strong) UILabel *startToEndLabel;
/**
 *  考试对象
 */
@property (nonatomic, strong) CSStudySkillModel *studySkillModel;
@end
