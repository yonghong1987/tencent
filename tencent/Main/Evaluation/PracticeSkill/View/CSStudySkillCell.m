//
//  CSStudySkillCell.m
//  tencent
//
//  Created by admin on 16/5/16.
//  Copyright © 2016年 cyh. All rights reserved.
//

#import "CSStudySkillCell.h"
#import "UIView+SDAutoLayout.h"
#import "CSColorConfig.h"
#import "CSFrameConfig.h"
#import "CSFontConfig.h"
@implementation CSStudySkillCell

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

- (void) initUI{
    self.backgroundColor = kBGColor;
    self.backView = [[UIView alloc]init];
    self.backView.backgroundColor = [UIColor whiteColor];
    [self.contentView addSubview:self.backView];
    
    self.catalogNameImg = [[UIImageView alloc]init];
    
    [self.contentView addSubview:self.catalogNameImg];
    
    self.catalogNameLabel = [[UILabel alloc]init];
    self.catalogNameLabel.font = kCaseCatalogNameFont;
    self.catalogNameLabel.textColor = [UIColor whiteColor];
    [self.contentView addSubview:self.catalogNameLabel];
    
    self.examStatusLabel = [[UILabel alloc]init];
    self.examStatusLabel.font = kZanFont;
    self.examStatusLabel.textColor = kPraiseContent;
    self.examStatusLabel.textAlignment = NSTextAlignmentRight;
    [self.contentView addSubview:self.examStatusLabel];

    self.examTitleLabel = [[UILabel alloc]init];
    self.examTitleLabel.font = kMainTitleFont;
    self.examTitleLabel.textColor = kTitleColor;
    [self.contentView addSubview:self.examTitleLabel];
    
    self.startToEndLabel = [[UILabel alloc]init];
    self.startToEndLabel.font = kZanFont;
    self.startToEndLabel.textColor = kPraiseContent;
    [self.contentView addSubview:self.startToEndLabel];
    
    
    //添加约束
    self.backView.sd_layout
    .leftSpaceToView(self.contentView,10)
    .rightSpaceToView(self.contentView,10)
    .topSpaceToView(self.contentView,10)
    .bottomSpaceToView(self.contentView,0);
    
    
    self.catalogNameImg.sd_layout
    .topSpaceToView(self.contentView,15)
    .leftSpaceToView(self.contentView,5)
    .widthIs(70)
    .heightIs(21);
    
    self.catalogNameLabel.sd_layout
    .topSpaceToView(self.contentView,17)
    .leftSpaceToView(self.contentView,15)
    .widthIs(100)
    .heightIs(20);
    
    self.examStatusLabel.sd_layout
    .topEqualToView(self.catalogNameLabel)
    .rightSpaceToView(self.contentView,20)
    .widthIs(100)
    .heightIs(20);
    
    self.examTitleLabel.sd_layout
    .topSpaceToView(self.contentView,45)
    .leftSpaceToView(self.contentView,15)
    .rightSpaceToView(self.contentView,15)
    .autoHeightRatio(0);
    
    self.startToEndLabel.sd_layout
    .topSpaceToView(self.examTitleLabel,10)
    .leftEqualToView(self.examTitleLabel)
    .widthIs(350)
    .heightIs(20);
    
    [self setupAutoHeightWithBottomViewsArray:@[self.startToEndLabel]  bottomMargin:10];
}

-(void)setStudySkillModel:(CSStudySkillModel *)studySkillModel{
    _studySkillModel = studySkillModel;
    self.examStatusLabel.text = studySkillModel.statusName;
    self.examTitleLabel.text = studySkillModel.examActivityName;
    
//    if (studySkillModel.examsdate.length > 0) {
        self.startToEndLabel.text = [NSString stringWithFormat:@"起止时间: %@ ~ %@",studySkillModel.startDate,studySkillModel.endDate];
//    }else{
//        self.startToEndLabel.text = @"起止时间: 无";
//    }
    
    if (studySkillModel.courseExamType == CSPrecourseExamType) {
        self.catalogNameLabel.text = @"课前测验";
        self.catalogNameImg.image = [UIImage imageNamed:@"img_lable"];
    }else if (studySkillModel.courseExamType == CSAftercourseExamType){
        self.catalogNameLabel.text = @"课后测验";
        self.catalogNameImg.image = [UIImage imageNamed:@"img_lable"];
    }else{
        self.catalogNameImg.image = [UIImage imageNamed:@""];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
