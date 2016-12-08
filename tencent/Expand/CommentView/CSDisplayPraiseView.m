//
//  CSDisplayPraiseView.m
//  tencent
//
//  Created by admin on 16/5/10.
//  Copyright © 2016年 cyh. All rights reserved.
//

#import "CSDisplayPraiseView.h"

@implementation CSDisplayPraiseView

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

-(void)initUI{
    self.praiseView = [[CSToolButtonView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width/2, self.frame.size.height)];
    self.praiseView.titleLabel.text = @"赞一个";
    self.praiseView.iconIV.image = [UIImage imageNamed:@"icon_zan_white2"];
    [self addSubview:self.praiseView];
    
    self.gapIV = [[UIImageView alloc] initWithFrame:CGRectMake(self.praiseView.frame.origin.x + self.praiseView.frame.size.width-1, 5, 2, self.frame.size.height - 10)];
    self.gapIV.backgroundColor = [UIColor whiteColor];
    [self addSubview:self.gapIV];
    
    self.replyView = [[CSToolButtonView alloc] initWithFrame:CGRectMake(self.gapIV.frame.origin.x + self.gapIV.frame.size.width, 0, self.frame.size.width/2, self.frame.size.height)];
    self.replyView.titleLabel.text = @"回复";
    self.replyView.iconIV.image = [UIImage imageNamed:@"icon_zan_white2"];
    [self addSubview:self.replyView];
    
    self.praiseView.tag = 1000;
    self.replyView.tag = 1001;
}

-(void)layoutSubviews{
    [super layoutSubviews];
    self.praiseView.frame = CGRectMake(0, 0, self.frame.size.width/2, self.frame.size.height);
    self.gapIV.frame = CGRectMake(self.praiseView.frame.origin.x + self.praiseView.frame.size.width-1, 5, 2, self.frame.size.height - 10);
    self.replyView.frame = CGRectMake(self.gapIV.frame.origin.x + self.gapIV.frame.size.width, 0, self.frame.size.width/2, self.frame.size.height);
}
@end
