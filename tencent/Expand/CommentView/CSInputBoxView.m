//
//  CSInputBoxView.m
//  tencent
//
//  Created by admin on 16/5/9.
//  Copyright © 2016年 cyh. All rights reserved.
//

#import "CSInputBoxView.h"

#import "CSColorConfig.h"
#import "CSFrameConfig.h"
#import "CSFontConfig.h"
#import "CSConfig.h"
@interface CSInputBoxView ()<UITextFieldDelegate>
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

@end
@implementation CSInputBoxView


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
    UIImageView *leftIV = [[UIImageView alloc] initWithFrame:CGRectMake(0, 9, 20, 20)];
    leftIV.image = [UIImage imageNamed:@"icon_input"];
    self.inputTF.leftView = leftIV;
    self.inputTF.leftViewMode = UITextFieldViewModeAlways;
    [self addSubview:self.inputTF];
    
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
    self.textFieldBg.frame = CGRectMake(10, 5, self.frame.size.width - 20, self.frame.size.height - 10);
    self.inputTF.frame = CGRectMake(25, 5, self.frame.size.width - 10, self.frame.size.height - 10);
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
