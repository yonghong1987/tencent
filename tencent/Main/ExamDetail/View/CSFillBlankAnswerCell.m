//
//  CSFillBlankAnswerCell.m
//  tencent
//
//  Created by cyh on 16/8/24.
//  Copyright © 2016年 cyh. All rights reserved.
//

#import "CSFillBlankAnswerCell.h"
#import "UIView+SDAutoLayout.h"
#import "CSColorConfig.h"
#import "CSFontConfig.h"

@interface CSFillBlankAnswerCell ()
@property (nonatomic, strong) UIView *backView;
@end

@implementation CSFillBlankAnswerCell

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
    
    self.contentLabel = [UILabel new];
    self.contentLabel.textColor = kTitleColor;
    self.contentLabel.font = kContentFont;
//    self.contentLabel.textAlignment = NSTextAlignmentCenter;
    [self.contentView addSubview:self.contentLabel];
    
    self.fillPromptLabel.sd_layout
    .topSpaceToView(self.contentView,5)
    .leftSpaceToView(self.contentView,10)
    .widthIs(60)
    .heightIs(40);
    
    self.contentLabel.sd_layout
    .topSpaceToView(self.contentView,15)
    .leftSpaceToView(self.fillPromptLabel,10)
    .rightSpaceToView(self.contentView,20)
    .autoHeightRatio(0);
    
    CGFloat height = self.contentLabel.height + 40;
    self.backView.sd_layout
    .topSpaceToView(self.contentView,5)
    .leftSpaceToView(self.contentView,10)
    .rightSpaceToView(self.contentView,10)
    .heightIs(height);
    
    [self setupAutoHeightWithBottomViewsArray:@[self.backView] bottomMargin:10];
}

-(void)setRadioModel:(CSOptionModel *)radioModel{
         _radioModel = radioModel;
        self.contentLabel.text = radioModel.chopUserAnswer;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
