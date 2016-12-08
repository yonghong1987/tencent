//
//  CSTitleTagChooseView.m
//  tencent
//
//  Created by cyh on 16/8/16.
//  Copyright © 2016年 cyh. All rights reserved.
//

#import "CSTitleTagChooseView.h"
#import "CSFrameConfig.h"
#import "UIColor+HEX.h"
@implementation CSTitleTagChooseView

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

- (void)initUI{
    self.backgroundColor = [UIColor colorWithHexString:@"#f8f8f8"];
    CGFloat btnWidth = kCSScreenWidth / 3;
    for (int i = 0; i < 3; i++) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        
        button.frame = CGRectMake(i * btnWidth, 0, btnWidth, 50);
        [self addSubview:button];
        if (i == 0) {
            [button setTitle:@"" forState:UIControlStateNormal];
            [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            self.leftBtn = button;
            UILabel *gapLabel = [[UILabel alloc]initWithFrame:CGRectMake(button.frame.origin.x+button.frame.size.width, 10, 1, 30)];
            gapLabel.backgroundColor = [[UIColor grayColor]colorWithAlphaComponent:0.4];
            [self addSubview:gapLabel];
        }else if (i == 1){
            [button setTitleColor:[[UIColor blackColor] colorWithAlphaComponent:0.5] forState:UIControlStateNormal];
            self.indexBtn = button;
            UILabel *gapLabel = [[UILabel alloc]initWithFrame:CGRectMake(button.frame.origin.x+button.frame.size.width, 10, 1, 30)];
            gapLabel.backgroundColor = [[UIColor grayColor]colorWithAlphaComponent:0.4];
            [self addSubview:gapLabel];
        }else if (i == 2){
            [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            self.rightBtn = button;
            [button setTitle:@"下一题" forState:UIControlStateNormal];
        }
    }
  
}

@end
