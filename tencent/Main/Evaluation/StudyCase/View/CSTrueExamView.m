//
//  CSTrueExamView.m
//  tencent
//
//  Created by cyh on 16/10/28.
//  Copyright © 2016年 cyh. All rights reserved.
//

#import "CSTrueExamView.h"
#import "CSColorConfig.h"
#import "CSFrameConfig.h"
@implementation CSTrueExamView

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
    self.trueIV = [[UIImageView alloc]initWithFrame:CGRectMake(10, 2, 15, 15)];
    [self addSubview:self.trueIV];
    
    self.gapLabel2 = [[UILabel alloc]initWithFrame:CGRectMake(self.trueIV.frame.origin.x + self.trueIV.frame.size.width+10, 0, 1, 20)];
    [self addSubview:self.gapLabel2];
    
    self.promptLabel = [[UILabel alloc]initWithFrame:CGRectMake(self.gapLabel2.frame.origin.x + self.gapLabel2.frame.size.width + 5, self.gapLabel2.frame.origin.y, kCSScreenWidth - 60, 20)];
    self.promptLabel.textColor = CSColorFromRGB(183.0, 183.0, 183.0);
    self.promptLabel.font = [UIFont systemFontOfSize:13.0];
    [self addSubview:self.promptLabel];
 
}

-(void)layoutSubviews{
    [super layoutSubviews];
    self.gapLabel2.backgroundColor = [[UIColor grayColor]colorWithAlphaComponent:0.7];
    
    self.trueIV.image = [UIImage imageNamed:@"icon_ok"];
    self.promptLabel.text = @"答案已截止，请直接参考答案！";
}

@end
