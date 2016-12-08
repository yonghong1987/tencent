//
//  CSCommitCaseAnswerView.m
//  tencent
//
//  Created by cyh on 16/7/27.
//  Copyright © 2016年 cyh. All rights reserved.
//

#import "CSCommitCaseAnswerView.h"
#import "CSFrameConfig.h"
#import "UIColor+HEX.h"
@implementation CSCommitCaseAnswerView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

-(instancetype)init{
    if ([super init]) {
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
    self.commitCaseBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    self.commitCaseBtn.frame = CGRectMake(10, 5, self.frame.size.width - 20, 46);
    self.commitCaseBtn.backgroundColor = [UIColor colorWithHexString:@"#e66444"];
    [self.commitCaseBtn setTitleColor: [UIColor whiteColor] forState:UIControlStateNormal];
    [self.commitCaseBtn setTitle:@"提交" forState:UIControlStateNormal];
    [self.commitCaseBtn addTarget:self action:@selector(commit) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.commitCaseBtn];
}

-(void)layoutSubviews{
    [super layoutSubviews];
    self.commitCaseBtn.frame = CGRectMake(10, (self.frame.size.height - 46) / 2, self.frame.size.width - 20, 46);
}
-(void)commit{
    if (self.commitAction) {
        self.commitAction();
    }
}
@end
