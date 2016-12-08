//
//  CSStudyCaseCell.m
//  tencent
//
//  Created by admin on 16/5/12.
//  Copyright © 2016年 cyh. All rights reserved.
//

#import "CSStudyCaseCell.h"
#import "UIView+SDAutoLayout.h"
#import "CSColorConfig.h"
#import "CSFrameConfig.h"
#import "CSFontConfig.h"
#import "UIImageView+AFNetworking.h"
@implementation CSStudyCaseCell

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
    self.backView = [[UIView alloc]init];
    self.backView.backgroundColor = [UIColor whiteColor];
    [self.contentView addSubview:self.backView];
    
    self.catalogNameImg = [[UIImageView alloc]init];
    self.catalogNameImg.image = [UIImage imageNamed:@"img_lable"];
    [self.contentView addSubview:self.catalogNameImg];
    
    self.catalogNameLabel= [UILabel new];
    self.catalogNameLabel.font = kCaseCatalogNameFont;
    self.catalogNameLabel.textColor = [UIColor whiteColor];
    [self.contentView addSubview:self.catalogNameLabel];
    
    self.caseImg = [[UIImageView alloc]init];
    [self.contentView addSubview:self.caseImg];
    
    self.caseNameLabel = [[UILabel alloc]init];
    self.caseNameLabel.font = kMainTitleFont;
    self.caseNameLabel.textColor = kTitleColor;
    [self.contentView addSubview:self.caseNameLabel];
    
    self.modifiedDateLabel = [[UILabel alloc]init];
    self.modifiedDateLabel.font = kZanFont;
    self.modifiedDateLabel.textColor = kPraiseContent;
    [self.contentView addSubview:self.modifiedDateLabel];
    
    //添加约束
    self.backView.sd_layout
    .leftSpaceToView(self.contentView,10)
    .rightSpaceToView(self.contentView,10)
    .topSpaceToView(self.contentView,10)
    .bottomSpaceToView(self.contentView,0);
    
    self.catalogNameLabel.sd_layout
    .topSpaceToView(self.contentView,17)
    .leftSpaceToView(self.contentView,15)
    .heightIs(20);
    [self.catalogNameLabel setSingleLineAutoResizeWithMaxWidth:200];
    
    
    self.caseImg.sd_layout
    .topSpaceToView(self.catalogNameLabel,10)
    .leftSpaceToView(self.contentView,12)
    .widthIs(self.frame.size.width - 24)
    .heightIs(147 * (kCSScreenWidth - 24) / 297);
    
    self.caseNameLabel.sd_layout
    .topSpaceToView(self.caseImg,10)
    .leftSpaceToView(self.contentView,15)
    .rightSpaceToView(self.contentView,15)
    .autoHeightRatio(0);
    
    self.modifiedDateLabel.sd_layout
    .topSpaceToView(self.caseNameLabel,10)
    .leftEqualToView(self.caseNameLabel)
    .widthIs(200)
    .heightIs(20);
    [self setupAutoHeightWithBottomViewsArray:@[self.modifiedDateLabel]  bottomMargin:10];
}

-(void)setStudyCaseModel:(CSStudyCaseModel *)studyCaseModel{
    _studyCaseModel = studyCaseModel;
    self.catalogNameLabel.text =[NSString stringWithFormat:@" %@",studyCaseModel.catalogName];
    if (studyCaseModel.catalogName.length > 0) {
        self.catalogNameImg.sd_layout
        .topSpaceToView(self.contentView,10)
        .leftSpaceToView(self.contentView,5)
        .widthIs(self.catalogNameLabel.width + 20)
        .heightIs(25);
    }else{
        self.catalogNameImg.sd_layout
        .topSpaceToView(self.contentView,10)
        .leftSpaceToView(self.contentView,5)
        .widthIs(0)
        .heightIs(0);
    }

    if (studyCaseModel.caseImg.length==0) {
        self.caseImg.sd_layout
        .topSpaceToView(self.catalogNameImg,10)
        .leftSpaceToView(self.contentView,12)
        .widthIs(self.frame.size.width - 24)
        .heightIs(0);
    }else{
        self.caseImg.sd_layout
        .topSpaceToView(self.catalogNameImg,10)
        .leftSpaceToView(self.contentView,12)
        .widthIs(self.frame.size.width - 24)
        .heightIs(147 * (kCSScreenWidth - 24) / 297);
    }
    [self.caseImg setImageWithURL:[NSURL URLWithString:studyCaseModel.caseImg] placeholderImage:[UIImage imageNamed:@"catalog_default"]];
    self.caseNameLabel.text = studyCaseModel.caseName;
    self.modifiedDateLabel.text = studyCaseModel.modifiedDate;
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
