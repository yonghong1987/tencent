//
//  CSMultiselectAnswerCell.m
//  tencent
//
//  Created by cyh on 16/7/27.
//  Copyright © 2016年 cyh. All rights reserved.
//

#import "CSMultiselectAnswerCell.h"
#import "CSColorConfig.h"
#import "CSFrameConfig.h"
#import "CSFontConfig.h"
#import "UIView+SDAutoLayout.h"
#import "CSColorConfig.h"
@implementation CSMultiselectAnswerCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self initUI];
    }
    return self;
}

- (void)initUI{
    self.backgroundColor = kBGColor;
    self.backView = [[UIView alloc] init];
    self.backView.backgroundColor = [UIColor whiteColor];
    [self.contentView addSubview:self.backView];
    
    self.optionImg = [[UIImageView alloc] init];
    self.optionImg.image = [UIImage imageNamed:@"rounded-rectangle"];
    [self.contentView addSubview:self.optionImg];
    
    self.optionTextLabel = [[UILabel alloc] init];
    self.optionTextLabel.textColor = kTitleColor;
    self.optionTextLabel.font = kMainTitleFont;
    [self.contentView addSubview:self.optionTextLabel];
    
    self.percentImg = [UIImageView new];
    self.percentImg.layer.cornerRadius = 5;
    self.percentImg.layer.masksToBounds = YES;
    self.percentImg.backgroundColor = kCSThemeColor;
    [self.contentView addSubview:self.percentImg];
    
    self.percentLabel = [UILabel new];
    self.percentLabel.textColor = kTimeColor;
    self.percentLabel.font = kTimeFont;
    [self.contentView addSubview:self.percentLabel];
    //添加约束
    self.backView.sd_layout
    .leftSpaceToView(self.contentView,10)
    .rightSpaceToView(self.contentView,10)
    .topSpaceToView(self.contentView,10)
    .bottomSpaceToView(self.contentView,0);
    
    self.optionImg.sd_layout
    .topSpaceToView(self.contentView,25)
    .leftSpaceToView(self.contentView,20)
    .widthIs(21)
    .heightIs(20);
    
    self.optionTextLabel.sd_layout
    .topEqualToView(self.optionImg)
    .leftSpaceToView(self.optionImg,10)
    .rightSpaceToView(self.contentView,20)
    .autoHeightRatio(0);
    
    self.percentImg.sd_layout
    .topSpaceToView(self.optionTextLabel,10)
    .leftSpaceToView(self.optionImg,10)
    .widthIs(0.1)
    .heightIs(10);
    
    self.percentLabel.sd_layout
    .topSpaceToView(self.optionTextLabel,5)
    .leftSpaceToView(self.percentImg,10)
    .widthIs(80)
    .heightIs(20);
    
    [self setupAutoHeightWithBottomViewsArray:@[self.percentLabel]  bottomMargin:10];
}

-(void)setOptionModel:(CSOptionModel *)optionModel{
    _optionModel = optionModel;
    self.optionTextLabel.text = [NSString stringWithFormat:@"%@ : %@",optionModel.chopLabel,optionModel.chopText];
    if ([optionModel.chopCorrect integerValue] > 0) {
        self.optionTextLabel.textColor = kCSThemeColor;
        self.optionImg.image = [UIImage imageNamed:@"rounded-rectangle_check"];
    }else{
        if ([optionModel.isChecked integerValue] > 0) {
            self.optionTextLabel.textColor = [[UIColor redColor]colorWithAlphaComponent:0.5];
        }
    }
    
    if ([optionModel.chopRatio floatValue] == 0) {
        [self.percentLabel setHidden:YES];
        [self.percentImg setHidden:YES];
    }else{
        [self.percentLabel setHidden:NO];
        [self.optionImg setHidden:NO];
        CGFloat percentWidth =[optionModel.chopRatio floatValue] *  (kCSScreenWidth - 160) / 100;
        self.percentImg.sd_layout
        .topSpaceToView(self.optionTextLabel,10)
        .leftSpaceToView(self.optionImg,10)
        .widthIs(percentWidth)
        .heightIs(10);
        NSString *textString = [NSString stringWithFormat:@"%.1f",[optionModel.chopRatio floatValue]];
        self.percentLabel.text = [NSString stringWithFormat:@"%@ %%",textString];
    }

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
