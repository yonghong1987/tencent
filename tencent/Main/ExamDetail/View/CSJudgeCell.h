//
//  CSJudgeCell.h
//  tencent
//
//  Created by cyh on 16/7/25.
//  Copyright © 2016年 cyh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CSOptionModel.h"
@interface CSJudgeCell : UITableViewCell

/**
 *  背景图片
 */
@property (nonatomic, strong) UIView *backView;
/**
 *  是否勾选的按钮图片
 */
@property (nonatomic, strong) UIButton *optionImgBtn;
/**
 *  选项的内容
 */
@property (nonatomic, strong) UILabel *optionTextLabel;
/**
 *  选项model
 */
@property (nonatomic, strong) CSOptionModel *optionModel;

@property (nonatomic, assign) BOOL isSelected;
//是否可以作答
@property (nonatomic, strong) NSNumber *canAnswer;


@property (nonatomic, copy) void (^clickSelectedAction)();
- (void)didSelectCell;
@end
