//
//  CSMultiselectCell.h
//  tencent
//
//  Created by admin on 16/5/17.
//  Copyright © 2016年 cyh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CSOptionModel.h"

@protocol CSGetMultiseStringDelegate <NSObject>

- (void)getChopIdString;

@end

@interface CSMultiselectCell : UITableViewCell

/**
 *  背景图片
 */
@property (nonatomic, strong) UIView *backView;
/**
 *  是否勾选的图片
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

/**
 *是否可以作答
 */
@property (nonatomic, strong) NSNumber *canAnswer;
/**
 *是否显示正确答案
 */
//@property (nonatomic, strong) NSNumber *displayAnswer;

- (void)didSelectCell;
@property (nonatomic, weak) id<CSGetMultiseStringDelegate> delega;
@end
