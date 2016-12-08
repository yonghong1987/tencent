//
//  CSTotalScoreVIew.m
//  tencent
//
//  Created by cyh on 16/10/28.
//  Copyright © 2016年 cyh. All rights reserved.
//

#import "CSTotalScoreVIew.h"
#import "UIView+SDAutoLayout.h"
#import "CSColorConfig.h"
#import "CSFrameConfig.h"
@implementation CSTotalScoreVIew

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
    self.totlaScoreLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 5, 80, 20)];
    self.totlaScoreLabel.textColor = CSColorFromRGB(183.0, 183.0, 183.0);
    self.totlaScoreLabel.font = [UIFont systemFontOfSize:13.0];
    [self addSubview:self.totlaScoreLabel];
    
    self.qualifiedLabel = [[UILabel alloc]initWithFrame:CGRectMake(140, 5, 100, 20)];
    self.qualifiedLabel.textColor = CSColorFromRGB(183.0, 183.0, 183.0);
    self.qualifiedLabel.font = [UIFont systemFontOfSize:13.0];
    [self addSubview:self.qualifiedLabel];
    
    self.gapLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 29, kCSScreenWidth, 1)];
    self.gapLabel.backgroundColor = [[UIColor grayColor]colorWithAlphaComponent:0.4];
    [self addSubview:self.gapLabel];
    
    self.trueIV = [[UIImageView alloc]initWithFrame:CGRectMake(10, 35, 15, 15)];
    [self addSubview:self.trueIV];
    
    self.gapLabel2 = [[UILabel alloc]initWithFrame:CGRectMake(self.trueIV.frame.origin.x + self.trueIV.frame.size.width+10, 30, 1, 20)];
    [self addSubview:self.gapLabel2];
    
    self.promptLabel = [[UILabel alloc]initWithFrame:CGRectMake(self.gapLabel2.frame.origin.x + self.gapLabel2.frame.size.width + 5, self.gapLabel2.frame.origin.y, kCSScreenWidth - 60, 20)];
    self.promptLabel.textColor = CSColorFromRGB(183.0, 183.0, 183.0);
    self.promptLabel.font = [UIFont systemFontOfSize:13.0];
    [self addSubview:self.promptLabel];
}

-(void)layoutSubviews{
    [super layoutSubviews];
    self.totlaScoreLabel.text = [NSString stringWithFormat:@"总分：%ld分",[self.examResultModel.score integerValue]];
    self.qualifiedLabel.text = [NSString stringWithFormat:@"合格：%ld分",[self.examResultModel.passingScore integerValue]];
    if ([self.examResultModel.canAnswer boolValue]) {
        if (self.examResultModel.examResultType == CSExamPassType) {
//            self.gapLabel2.backgroundColor = [[UIColor grayColor]colorWithAlphaComponent:0.7];
//            
//            self.trueIV.image = [UIImage imageNamed:@"icon_right_gray"];
        }else if (self.examResultModel.examResultType == CSExamNoPassType){
//            self.gapLabel2.backgroundColor = [[UIColor grayColor]colorWithAlphaComponent:0.7];
//            
//            self.trueIV.image = [UIImage imageNamed:@"icon_right_gray"];
        }else{
//            self.trueIV.image = [UIImage imageNamed:@"icon_right_gray"];
        }
    }else{
        if (self.examResultModel.examResultType == CSExamPassType) {
            self.gapLabel2.backgroundColor = [[UIColor grayColor]colorWithAlphaComponent:0.7];
            
            self.trueIV.image = [UIImage imageNamed:@"icon_ok"];
             self.promptLabel.text = @"答案已截止，请直接参考答案！";
        }else if (self.examResultModel.examResultType == CSExamNoPassType){
            self.gapLabel2.backgroundColor = [[UIColor grayColor]colorWithAlphaComponent:0.7];
            
            self.trueIV.image = [UIImage imageNamed:@"icon_ok"];
             self.promptLabel.text = @"答案已截止，请直接参考答案！";
        }else{
            self.trueIV.image = [UIImage imageNamed:@"icon_ok"];
        }

    }
}
@end
