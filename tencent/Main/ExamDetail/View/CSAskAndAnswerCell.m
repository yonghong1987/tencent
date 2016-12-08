//
//  CSAskAndAnswerCell.m
//  tencent
//
//  Created by cyh on 16/7/27.
//  Copyright © 2016年 cyh. All rights reserved.
//

#import "CSAskAndAnswerCell.h"
#import "CSColorConfig.h"
@interface CSAskAndAnswerCell ()<UITextViewDelegate>
@property (nonatomic, strong) UIView *backView;
@end


@implementation CSAskAndAnswerCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])
    {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self initUI];
    }
    return self;
}

- (void)initUI{
    self.backgroundColor = kBGColor;
    self.textView = [[XHMessageTextView alloc]initWithFrame:CGRectMake(10, 10, self.frame.size.width - 20, 200)];
    self.textView.delegate = self;
    self.textView.placeHolder = @"请输入你的观点";
    [self.contentView addSubview:self.textView];
}

-(void)initBackView{
    self.backView = [[UIView alloc]initWithFrame:self.superview.bounds];
    self.backView.backgroundColor = [UIColor clearColor];
    [self.superview insertSubview:self.backView aboveSubview:self];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(hideBackView)];
    [self.backView addGestureRecognizer:tap];
}

-(void)setRadioModel:(CSRadioModel *)radioModel{
    _radioModel = radioModel;
    if ([self.canAnswer integerValue] > 0) {
        self.textView.text = radioModel.userAnswerText;
    }
}
-(void)hideBackView{
    [self.backView removeFromSuperview];
    [self.textView resignFirstResponder];
    
}

-(void)setTextString:(NSString *)textString{
    _textString = textString;
    self.textView.text = textString;
}

-(void)textViewDidChange:(UITextView *)textView{
    NSLog(@"textView.text:%@",textView.text);
}

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView{
//    [self initBackView];
    
    return YES;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
