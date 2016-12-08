//
//  CSToolBtn.h
//  tencent
//
//  Created by cyh on 16/8/20.
//  Copyright © 2016年 cyh. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CSToolBtn : UIView

@property (nonatomic, strong) UIImageView *iconIV;
@property (nonatomic, strong) UILabel *titleLabel;

@property (nonatomic, copy) void (^passToolBtn)(CSToolBtn *toolBtn);
@end
