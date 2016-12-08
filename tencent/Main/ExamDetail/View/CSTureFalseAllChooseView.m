//
//  CSTureFalseAllChooseView.m
//  tencent
//
//  Created by cyh on 16/8/23.
//  Copyright © 2016年 cyh. All rights reserved.
//

#import "CSTureFalseAllChooseView.h"
#import "CSFrameConfig.h"
#import "UIColor+HEX.h"
@implementation CSTureFalseAllChooseView

-(instancetype)init{
    if (self = [super init]) {
        [self initUI];
    }
    return self;
}

-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self initUI];
    }
    return self;
}

-(void)initUI{
    self.backgroundColor = [[UIColor colorWithHexString:@"#f8f8f8"]colorWithAlphaComponent:0.9];
    int btnCount = 3;
    CGFloat padding = 10;
    CGFloat btnWidth = (kCSScreenWidth - (btnCount + 1) * padding) / 3;
    for (int i = 0; i < 3; i ++) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(padding + padding * i + btnWidth * i, 10, btnWidth, 33);
        button.backgroundColor = [UIColor whiteColor];
        button.layer.cornerRadius = 5.0;
        button.layer.borderWidth = 1.0;
        button.layer.borderColor = [[UIColor grayColor]CGColor];
        button.layer.masksToBounds = YES;
        if (i == 0) {
            [button setTitle:@"显示正确" forState:UIControlStateNormal];
        }else if (i == 1){
            [button setTitle:@"显示错误" forState:UIControlStateNormal];
        }else if (i == 2){
            [button setTitle:@"显示全部" forState:UIControlStateNormal];
        }
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        button.tag = i;
        [button addTarget:self action:@selector(clickBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:button];
    }
}


-(void)clickBtnAction:(UIButton *)sender{
    switch (sender.tag) {
        case 0:
            if (self.clickTrueAction) {
                self.clickTrueAction();
            }
            break;
        case 1:
            if (self.clickFalseAction) {
                self.clickFalseAction();
            }
            break;
        case 2:
            if (self.clickAllAction) {
                self.clickAllAction();
            }
            break;
        default:
            break;
    }
}

@end
