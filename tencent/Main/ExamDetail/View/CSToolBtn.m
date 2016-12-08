//
//  CSToolBtn.m
//  tencent
//
//  Created by cyh on 16/8/20.
//  Copyright © 2016年 cyh. All rights reserved.
//

#import "CSToolBtn.h"

@implementation CSToolBtn

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/


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
    
    self.iconIV = [[UIImageView alloc]init];
    self.iconIV.layer.cornerRadius = self.frame.size.width / 2;
    self.iconIV.layer.masksToBounds = YES;
    [self addSubview:self.iconIV];
    
    self.titleLabel = [UILabel new];
    self.titleLabel.font = [UIFont systemFontOfSize:11.0];
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:self.titleLabel];
    
    self.userInteractionEnabled = YES;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(clickSelf:)];
    [self addGestureRecognizer:tap];
    
}

-(void)layoutSubviews{
    [super layoutSubviews];
    self.iconIV.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.width);
    self.iconIV.layer.cornerRadius = self.frame.size.width / 2;
    self.iconIV.layer.masksToBounds = YES;
    self.titleLabel.frame = CGRectMake(0, self.iconIV.frame.origin.y + self.iconIV.frame.size.height, self.iconIV.frame.size.width, 20);
}

-(void)clickSelf:(UITapGestureRecognizer *)sender{
    if (self.passToolBtn) {
        self.passToolBtn(self);
    }
}


@end
