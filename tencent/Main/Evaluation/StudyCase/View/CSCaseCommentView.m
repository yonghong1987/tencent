//
//  CSCaseCommentView.m
//  tencent
//
//  Created by cyh on 16/7/27.
//  Copyright © 2016年 cyh. All rights reserved.
//

#import "CSCaseCommentView.h"
#import "CSReplyTextView.h"
#import "CSColorConfig.h"
#import "CSFrameConfig.h"
#import "CSFontConfig.h"
#import "CSConfig.h"

@interface CSCaseCommentView ()<UITextFieldDelegate>
/*
 **整个背景图片
 */
@property (nonatomic, strong) UIImageView *backGroundView;
/*
 **输入框背景图片
 */
@property (nonatomic, strong) UIImageView *textFieldBg;
/*
 **输入框
 */
@property (nonatomic, strong) UITextField *inputTF;
/*
 **评论的回复视图
 */
@property (nonatomic, strong) CSReplyTextView *replyTextView;

@end
@implementation CSCaseCommentView


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

#pragma  mark controlInit
- (void)initUI{
    self.backGroundView = [[UIImageView alloc] initWithFrame:self.bounds];
    self.backGroundView.backgroundColor = CSColorFromRGB(255.0, 255.0, 255.0);
    [self addSubview:self.backGroundView];
    
    self.textFieldBg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"评论框"]];
    self.textFieldBg.frame = CGRectZero;
    [self addSubview:self.textFieldBg];
    
    self.inputTF = [[UITextField alloc] init];
    self.inputTF.font = kContentFont;
    self.inputTF.delegate = self;
    UIImageView *leftIV = [[UIImageView alloc] initWithFrame:CGRectMake(0, 8, 20, 20)];
    leftIV.image = [UIImage imageNamed:@"icon_input"];
    self.inputTF.leftView = leftIV;
    self.inputTF.leftViewMode = UITextFieldViewModeAlways;
    [self addSubview:self.inputTF];
    
    self.countBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.countBtn.frame = CGRectZero;
    self.countBtn.titleLabel.font = [UIFont systemFontOfSize:12.0];
    [self.countBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [self.countBtn addTarget:self action:@selector(didAction) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.countBtn];
    
    _replyTextView = [[CSReplyTextView alloc] init];
    __weak __typeof(self)weakSelf = self;
    [_replyTextView setDidSelectedSureBlock:^(NSString *content) {
        if (weakSelf.didEndInputBlock) {
            weakSelf.didEndInputBlock(YES,content);
        }
    }];
    [_replyTextView setDidSelectedCancelBlock:^{
        if (weakSelf.didEndInputBlock) {
            weakSelf.didEndInputBlock(NO,nil);
        }
    }];
}

-(void)didAction{
    if (self.didCommentVC) {
        self.didCommentVC();
    }
}
- (void)setPlaceholder:(NSString *)placeholder
{
    _placeholder = placeholder;
    
    self.inputTF.placeholder = placeholder;
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    [self.replyTextView show];
    return NO;
}

-(void)layoutSubviews{
    [super layoutSubviews];
    self.backGroundView.frame = self.bounds;
    self.textFieldBg.frame = CGRectMake(10, 5, self.frame.size.width - 80, self.frame.size.height - 10);
    self.inputTF.frame = CGRectMake(25, 5, self.frame.size.width - 80, self.frame.size.height - 10);
    self.countBtn.frame = CGRectMake(self.frame.size.width - 80, 0, 80, 50);
}

-(void)setCountString:(NSString *)countString{
    _countString = countString;
    [self.countBtn setTitle:countString forState:UIControlStateNormal];
}
@end
