//
//  CSToolButtonView.m
//  tencent
//
//  Created by admin on 16/5/10.
//  Copyright © 2016年 cyh. All rights reserved.
//

#import "CSToolButtonView.h"
#import "CSFontConfig.h"
#import "CSColorConfig.h"
@implementation CSToolButtonView


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
    self.iconIV = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 30, 30)];
    self.iconIV.contentMode = UIViewContentModeScaleAspectFit;
    [self addSubview:self.iconIV];
    
    self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.iconIV.frame.origin.x + self.iconIV.frame.size.width + 10, self.iconIV.frame.origin.y, 60, 30)];
    self.titleLabel.font = kTimeFont;
    self.titleLabel.textColor = [UIColor whiteColor];
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:self.titleLabel];
    self.userInteractionEnabled = YES;
    [self addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didSelectToolBtn:)]];
}

- (void)didSelectToolBtn:(UITapGestureRecognizer *)tapGuesture{
    
    if (self.didSelectedBlock) {
        self.didSelectedBlock(self);
    }
}
-(void)layoutSubviews{
    [super layoutSubviews];
    self.iconIV.frame = CGRectMake(10, 15, 20, 20);
    self.titleLabel.frame = CGRectMake(self.iconIV.frame.origin.x + self.iconIV.frame.size.width , self.iconIV.frame.origin.y, 60, 20);
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
