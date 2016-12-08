//
//  CSTrueAndFalseView.m
//  tencent
//
//  Created by cyh on 16/8/22.
//  Copyright © 2016年 cyh. All rights reserved.
//

#import "CSTrueAndFalseView.h"
#import "CSColorConfig.h"
#import "UIColor+HEX.h"
@interface CSTrueAndFalseView ()
@property (nonatomic, strong) UILabel *greenLabel;
@property (nonatomic, strong) UILabel *trueLabel;
@property (nonatomic, strong) UILabel *grayLabel;
@property (nonatomic, strong) UILabel *falseLabel;
@end

@implementation CSTrueAndFalseView


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
    
    self.greenLabel = [UILabel new];
    self.greenLabel.backgroundColor = kCSThemeColor;
    [self addSubview:self.greenLabel];
    self.trueLabel = [UILabel new];
    self.trueLabel.text = @"正确";
    [self addSubview:self.trueLabel];
    self.grayLabel = [UILabel new];
    self.grayLabel.backgroundColor = [UIColor grayColor];
    [self addSubview:self.grayLabel];
    self.falseLabel = [UILabel new];
    self.falseLabel.text = @"错误";
    [self addSubview:self.falseLabel];
}


- (void)layoutSubviews{
    [super layoutSubviews];
    self.greenLabel.frame = CGRectMake(10, 10, 30, 30);
    self.trueLabel.frame = CGRectMake(self.greenLabel.frame.origin.x + self.greenLabel.frame.size.width + 10, 15, 60, 20);
    self.grayLabel.frame = CGRectMake(self.trueLabel.frame.origin.x + self.trueLabel.frame.size.width + 10, 10, 30, 30);
    self.falseLabel.frame = CGRectMake(self.grayLabel.frame.origin.x + self.grayLabel.frame.size.width + 10, 15, 60, 20);
}
@end
