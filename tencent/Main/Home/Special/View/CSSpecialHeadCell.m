//
//  CSSpecialHeadCell.m
//  tencent
//
//  Created by admin on 16/5/5.
//  Copyright © 2016年 cyh. All rights reserved.
//

#import "CSSpecialHeadCell.h"
#import "UIView+SDAutoLayout.h"
#import "CSColorConfig.h"
#import "CSFrameConfig.h"
#import "CSFontConfig.h"
@implementation CSSpecialHeadCell

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

-(void) initUI{
    
    self.backgroundColor = kBGColor;
    self.backView = [[UIView alloc]init];
    self.backView.backgroundColor = [UIColor whiteColor];
    [self.contentView addSubview:self.backView];
    
    self.iconIV = [[UIImageView alloc]init];
    self.iconIV.image = [UIImage imageNamed:@"icon_article"];
    [self.contentView addSubview:self.iconIV];
    
    self.titleLabel = [[UILabel alloc]init];
    self.titleLabel.font = kMainTitleFont;
    self.titleLabel.textColor = kTitleColor;
    [self.contentView addSubview:self.titleLabel];

    self.gapIV = [UIImageView new];
    self.gapIV.image = [UIImage imageNamed:@"line_dotted"];
    [self.contentView addSubview:self.gapIV];
    
    self.timeLabel = [UILabel new];
    self.timeLabel.font = kTimeFont;
    self.timeLabel.textColor = kTimeColor;
    [self.contentView addSubview:self.timeLabel];
    
   //添加约束
    self.backView.sd_layout
    .leftSpaceToView(self.contentView,0)
    .rightSpaceToView(self.contentView,0)
    .topSpaceToView(self.contentView,10)
    .bottomSpaceToView(self.contentView,0);

    self.iconIV.sd_layout
    .topSpaceToView(self.contentView,20)
    .leftSpaceToView(self.contentView,10)
    .widthIs(30)
    .heightIs(27);
    
    self.titleLabel.sd_layout
    .topSpaceToView(self.contentView,25)
    .leftSpaceToView(self.iconIV,10)
    .rightSpaceToView(self.contentView,10)
    .autoHeightRatio(0);

    self.gapIV.sd_layout
    .topSpaceToView(self.titleLabel,10)
    .leftSpaceToView(self.contentView,10)
    .rightSpaceToView(self.contentView,10)
    .heightIs(1);

    self.timeLabel.sd_layout
    .topSpaceToView(self.gapIV,10)
    .leftEqualToView(self.gapIV)
    .widthIs(200)
    .heightIs(20);
    
    [self setupAutoHeightWithBottomViewsArray:@[self.timeLabel]  bottomMargin:10];
}


-(void)setSpecialListModel:(CSSpecialListModel *)specialListModel{
    _specialListModel = specialListModel;
    self.titleLabel.text =specialListModel.name;
    self.timeLabel.text = self.specialListModel.modifieddate;
    
}

//- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
//    [super setSelected:selected animated:animated];
//
//    // Configure the view for the selected state
//}



@end
