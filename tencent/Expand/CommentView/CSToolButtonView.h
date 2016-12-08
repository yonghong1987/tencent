//
//  CSToolButtonView.h
//  tencent
//
//  Created by admin on 16/5/10.
//  Copyright © 2016年 cyh. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CSToolButtonView : UIView

/**
 *  文字
 */
@property (nonatomic, strong) UILabel *titleLabel;
/**
 *  图片
 */
@property (nonatomic, strong) UIImageView *iconIV;

@property (nonatomic, copy) void(^didSelectedBlock)(CSToolButtonView *);
@end
