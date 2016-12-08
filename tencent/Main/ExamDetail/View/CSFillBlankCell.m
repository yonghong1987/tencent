//
//  CSFillBlankCell.m
//  tencent
//
//  Created by cyh on 16/7/27.
//  Copyright © 2016年 cyh. All rights reserved.
//

#import "CSFillBlankCell.h"
#import "UIView+SDAutoLayout.h"
#import "CSColorConfig.h"
#import "CSFontConfig.h"
@interface CSFillBlankCell ()
@property (nonatomic, strong) UIView *backView;
@end

@implementation CSFillBlankCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self initUI];
    }
    return self;
}

-(void)initUI{
    self.backgroundColor = kBGColor;
    self.backView = [UIView new];
    self.backView.backgroundColor = [UIColor whiteColor];
    [self.contentView addSubview:self.backView];
    
    self.fillPromptLabel = [UILabel new];
    self.fillPromptLabel.textColor = kTitleColor;
    self.fillPromptLabel.font = kContentFont;
    self.fillPromptLabel.textAlignment = NSTextAlignmentCenter;
    [self.contentView addSubview:self.fillPromptLabel];
    
    self.fillContentTextView = [XHMessageTextView new];
    self.fillContentTextView.font = kContentFont;
    self.fillContentTextView.delegate = self;
    self.fillContentTextView.layer.cornerRadius = 5.0;
    self.fillContentTextView.layer.borderColor = [[[UIColor grayColor]colorWithAlphaComponent:0.5]CGColor];
    self.fillContentTextView.layer.borderWidth = 0.3;
    [self.contentView addSubview:self.fillContentTextView];
    
    self.backView.sd_layout
    .topSpaceToView(self.contentView,5)
    .leftSpaceToView(self.contentView,10)
    .rightSpaceToView(self.contentView,10)
    .heightIs(70);
    
    self.fillPromptLabel.sd_layout
    .topSpaceToView(self.contentView,20)
    .leftSpaceToView(self.contentView,10)
    .widthIs(60)
    .heightIs(40);
    
    self.fillContentTextView.sd_layout
    .topSpaceToView(self.contentView,15)
    .leftSpaceToView(self.fillPromptLabel,10)
    .rightSpaceToView(self.contentView,20)
    .heightIs(50);
    
    [self setupAutoHeightWithBottomViewsArray:@[self.backView] bottomMargin:5];
}


-(void)setOptionModel:(CSOptionModel *)optionModel{
    _optionModel = optionModel;
    NSLog(@"chopUserAnswerchopUserAnswer:%@",optionModel.chopUserAnswer);
    if ([self.canAnswer integerValue] > 0) {
        self.fillContentTextView.text = optionModel.chopUserAnswer;
    }
}

-(BOOL)textViewShouldBeginEditing:(UITextView *)textView{
    if (self.passTextViewIndex) {
        self.passTextViewIndex();
    }
    return YES;
}

-(void)textViewDidChange:(UITextView *)textView{
    NSString *textString = textView.text;
    self.optionModel.chopUserAnswer = textString;
}
-(void)textViewDidEndEditing:(UITextView *)textView{
//NSLog(@"textView.text:%@",textView.text);
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
