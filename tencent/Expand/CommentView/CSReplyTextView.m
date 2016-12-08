//
//  CSReplyTextView.m
//  tencent
//
//  Created by admin on 16/5/9.
//  Copyright © 2016年 cyh. All rights reserved.
//

#import "CSReplyTextView.h"
#import "Masonry.h"
#import "MBProgressHUD+CYH.h"
#import "CSFrameConfig.h"
#import "CSColorConfig.h"
#import "CSFontConfig.h"
#import "CSToolButtonView.h"
#import "UIColor+HEX.h"
#define TEXT_LENGTH 250
@interface CSReplyTextView ()
@property (nonatomic, strong) UILabel *titleLabel;//标题
@property (nonatomic, strong) UIButton *cancelBtn;//取消按钮
@property (nonatomic, strong) UIButton *sureBtn;//确定按钮

@property (nonatomic, strong) UIView *maskView;//蒙板
@property (nonatomic, strong) UILabel *counterLabel;//输入的字符长度
@end

@implementation CSReplyTextView

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
    self.backgroundColor = [[UIColor colorWithHexString:@"#f8f8f8"] colorWithAlphaComponent:0.9];
    self.titleLabel = [[UILabel alloc] init];
    self.titleLabel.font = kMainTitleFont;
    [self addSubview:self.titleLabel];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.height.equalTo(@44);
        make.top.equalTo(self);
    }];
    
    self.sureBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.sureBtn setImage:[UIImage imageNamed:@"icon_ok"] forState:UIControlStateNormal];
    [self.sureBtn addTarget:self action:@selector(sure) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.sureBtn];
    [self.sureBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self).offset(-10);
        make.centerY.equalTo(self.titleLabel);
        make.width.and.height.equalTo(@40);
    }];
    
    self.cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.cancelBtn setImage:[UIImage imageNamed:@"icon_cancle"] forState:UIControlStateNormal];
    [self.cancelBtn addTarget:self action:@selector(cancel) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.cancelBtn];
    [self.cancelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(10);
        make.centerY.equalTo(self.titleLabel);
        make.width.and.height.equalTo(@40);
    }];
    
    self.textView = [[XHMessageTextView alloc] init];
    self.textView.delegate = self;
    self.textView.font = kContentFont;
    [self addSubview:self.textView];
    [self.textView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(10);
        make.right.equalTo(self).offset(-10);
        make.top.equalTo(self.titleLabel.mas_bottom);
        make.bottom.equalTo(self).offset(-10);
    }];
   
    self.counterLabel=[[UILabel alloc]init];
    self.counterLabel.text=@"250";
    self.counterLabel.textAlignment = NSTextAlignmentCenter;
    self.counterLabel.font=[UIFont systemFontOfSize:12.0];
    [self addSubview:self.counterLabel];
    [self.counterLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.sureBtn.mas_left);
        make.bottom.equalTo(self).offset(-15);
        make.width.equalTo(@40);
        make.height.equalTo(@15);
    }];
    
    self.maskView = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.maskView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
    UITapGestureRecognizer *tapGes = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(cancel)];
    [self.maskView addGestureRecognizer:tapGes];
}
-(void)textViewDidChange:(UITextView *)textView{
    if (textView.markedTextRange==nil&&textView.text.length>TEXT_LENGTH) {
        textView.text=[textView.text substringToIndex:TEXT_LENGTH];
    }
    int length=TEXT_LENGTH-textView.text.length;
    self.counterLabel.text=[NSString stringWithFormat:@"%d",length<0?0:length];
}
-(void)setTitle:(NSString *)title{
    self.titleLabel.text = title;
}

//确定
- (void)sure{
    if (!self.textView.text.length) {
        [MBProgressHUD showError:@"评论内容不能为空"];
        return;
    }
    if (self.textView.text.length > 250) {
        [MBProgressHUD showError:@"评论内容长度不能超过250个字符"];
        return;
    }
    if (self.didSelectedSureBlock) {
        self.didSelectedSureBlock(self.textView.text);
    }
    [self hide];
}
//取消
- (void)cancel{
    if (self.didSelectedCancelBlock) {
        self.didSelectedCancelBlock();
    }
    [self hide];
}

- (void)show{
    UIWindow *window = [[UIApplication sharedApplication].windows lastObject];
    [window addSubview:self.maskView];
    self.frame = CGRectMake(0, window.frame.size.height, window.frame.size.width, 200);
    self.titleLabel.text = @"写评论";
    self.textView.placeHolder = @"添加评论...";
    [window addSubview:self];
    //监听键盘
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(KeyboardWillChangeFrame:) name:UIKeyboardWillChangeFrameNotification object:nil];
    [self.textView becomeFirstResponder];
}
- (void)hide
{
    [self.textView resignFirstResponder];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [self.maskView removeFromSuperview];
}
- (void)KeyboardWillChangeFrame:(NSNotification *)note
{
    CGFloat duration = [note.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    
    CGRect endKeyboardFrame = [note.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    CGFloat transformY = endKeyboardFrame.origin.y - [UIScreen mainScreen].bounds.size.height;
    
    if (transformY < 0) {
        transformY -= self.frame.size.height;
    }
    
    [UIView animateWithDuration:duration animations:^{
        self.transform = CGAffineTransformMakeTranslation(0, transformY);
    }];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
