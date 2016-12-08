//
//  CSMultiselectCell.m
//  tencent
//
//  Created by admin on 16/5/17.
//  Copyright © 2016年 cyh. All rights reserved.
//

#import "CSMultiselectCell.h"
#import "CSColorConfig.h"
#import "CSFrameConfig.h"
#import "CSFontConfig.h"
#import "UIView+SDAutoLayout.h"

@implementation CSMultiselectCell

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
    
    self.optionImgBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    [self.optionImgBtn setBackgroundImage:[UIImage imageNamed:@"rounded-rectangle"] forState:UIControlStateNormal];
    [self.optionImgBtn setBackgroundImage:[UIImage imageNamed:@"rounded-rectangle_check"] forState:UIControlStateSelected];
    [self.optionImgBtn addTarget:self action:@selector(cilckBtnImage) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:self.optionImgBtn];
    
    self.optionTextLabel = [[UILabel alloc] init];
    self.optionTextLabel.textColor = kTitleColor;
    self.optionTextLabel.font = kMainTitleFont;
    [self.contentView addSubview:self.optionTextLabel];
    
    //添加约束
    self.backView.sd_layout
    .leftSpaceToView(self.contentView,10)
    .rightSpaceToView(self.contentView,10)
    .topSpaceToView(self.contentView,10)
    .bottomSpaceToView(self.contentView,0);
    
    self.optionImgBtn.sd_layout
    .topSpaceToView(self.contentView,20)
    .leftSpaceToView(self.contentView,20)
    .widthIs(21)
    .heightIs(20);
    
    self.optionTextLabel.sd_layout
    .topEqualToView(self.optionImgBtn)
    .leftSpaceToView(self.optionImgBtn,10)
    .rightSpaceToView(self.contentView,20)
    .autoHeightRatio(0);
    
    [self setupAutoHeightWithBottomViewsArray:@[self.optionTextLabel]  bottomMargin:10];
}

-(void)setOptionModel:(CSOptionModel *)optionModel{
    _optionModel = optionModel;
    self.optionTextLabel.text = [NSString stringWithFormat:@"%@ : %@",optionModel.chopLabel,optionModel.chopText];
    self.optionImgBtn.selected = optionModel.isSelected;
    [self.optionImgBtn setBackgroundImage:[UIImage imageNamed:@"rounded-rectangle"] forState:UIControlStateNormal];
    //不能作答
    if ([self.canAnswer integerValue] == 0) {
        //可以显示正确答案
        if ([optionModel.displayAnswer boolValue] && [optionModel.chopCorrect boolValue]) {
            self.optionTextLabel.textColor = kCSThemeColor;
            [self.optionImgBtn setBackgroundImage:[UIImage imageNamed:@"rounded-rectangle_check"] forState:UIControlStateNormal];
        }
        //如果用户选择的是正确答案
        else if ([optionModel.chopChecked boolValue]){
            if ([optionModel.chopCorrect boolValue]) {
                self.optionTextLabel.textColor = kCSThemeColor;
                [self.optionImgBtn setBackgroundImage:[UIImage imageNamed:@"rounded-rectangle_check"] forState:UIControlStateNormal];
            }else{
                //用户所选为错误的
                self.optionTextLabel.textColor = [[UIColor redColor]colorWithAlphaComponent:0.5];;
            }
        }
        
        //可以作答
    }else{
        if (optionModel.isSelected == true) {
            [self.optionImgBtn setBackgroundImage:[UIImage imageNamed:@"rounded-rectangle_check"] forState:UIControlStateNormal];
        }else{
            [self.optionImgBtn setBackgroundImage:[UIImage imageNamed:@"rounded-rectangle"] forState:UIControlStateNormal];
        }
    }
}


- (void)didSelectCell{
    self.optionModel.isSelected = !self.optionModel.isSelected;
    self.optionImgBtn.selected = self.optionModel.isSelected;
}

-(void)cilckBtnImage{
    if ([self.canAnswer integerValue] > 0) {
        [self didSelectCell];
        if (self.delega && [self.delega respondsToSelector:@selector(getChopIdString)]) {
            [self.delega getChopIdString];
        }
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
