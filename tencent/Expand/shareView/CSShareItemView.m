//
//  CSShareItemView.m
//  tencent
//
//  Created by admin on 16/5/6.
//  Copyright © 2016年 cyh. All rights reserved.
//

#import "CSShareItemView.h"
#import "CSFontConfig.h"
@implementation CSShareItemView


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
    self.iocnIV = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.width)];
    [self addSubview:self.iocnIV];
    
    self.titlLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, self.iocnIV.frame.origin.y + self.iocnIV.frame.size.height, self.frame.size.width, 20)];
    self.titlLabel.textAlignment = NSTextAlignmentCenter;
    self.titlLabel.textColor = [UIColor whiteColor];
    self.titlLabel.font = [UIFont systemFontOfSize:11.0];
    [self addSubview:self.titlLabel];
}

-(void)layoutSubviews{
    [super layoutSubviews];
    self.iocnIV.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.width);
    self.titlLabel.frame = CGRectMake(0, self.iocnIV.frame.origin.y + self.iocnIV.frame.size.height, self.frame.size.width, 20);
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
