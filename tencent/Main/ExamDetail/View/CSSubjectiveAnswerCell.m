//
//  CSSubjectiveAnswerCell.m
//  tencent
//
//  Created by cyh on 16/8/10.
//  Copyright © 2016年 cyh. All rights reserved.
//

#import "CSSubjectiveAnswerCell.h"
#import "UIView+SDAutoLayout.h"
#import "CSFontConfig.h"
#import "CSColorConfig.h"
@interface CSSubjectiveAnswerCell ()
@property (nonatomic, strong) UIImageView *gapIV;
@property (nonatomic, strong) UIView *backView;
@end

@implementation CSSubjectiveAnswerCell

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
    
    self.answerPromptLabel = [UILabel new];
    self.answerPromptLabel.font = kMainTitleFont;
    [self.contentView addSubview:self.answerPromptLabel];
    
    self.answerLabel = [UILabel new];
    self.answerLabel.font = kContentFont;
    [self.contentView addSubview:self.answerLabel];
    
    self.gapIV = [UIImageView new];
    self.gapIV.backgroundColor = kCSThemeColor;
    [self.contentView addSubview:self.gapIV];
    
    self.backView.sd_layout
    .topSpaceToView(self.contentView,10)
    .leftSpaceToView(self.contentView,10)
    .rightSpaceToView(self.contentView,10)
    .bottomSpaceToView(self.contentView,0);
    
    self.answerPromptLabel.sd_layout
    .topSpaceToView(self.contentView,20)
    .leftSpaceToView(self.contentView,20)
    .widthIs(150)
    .heightIs(30);
    
    self.answerLabel.sd_layout
    .topSpaceToView(self.answerPromptLabel,10)
    .leftEqualToView(self.answerPromptLabel)
    .rightSpaceToView(self.contentView,20)
    .autoHeightRatio(0);
    
    self.gapIV.sd_layout
    .topSpaceToView(self.answerPromptLabel,10)
    .leftSpaceToView(self.contentView,10)
    .widthIs(2)
    .bottomSpaceToView(self.contentView,10);
    
//    [self setupAutoHeightWithBottomViewsArray:@[self.gapIV] bottomMargin:10];
}

-(void)setCaseDetailModel:(CSStudyCaseDetailModel *)caseDetailModel{
    _caseDetailModel = caseDetailModel;
    if ([caseDetailModel.alreadySubmit integerValue] > 0) {
        NSLog(@"section:%d",self.section);
        
        if (self.section == 1) {
            self.answerLabel.text = caseDetailModel.viewPoint;
            
            self.backView.sd_layout
            .topSpaceToView(self.contentView,10)
            .leftSpaceToView(self.contentView,10)
            .rightSpaceToView(self.contentView,10)
            .bottomSpaceToView(self.contentView,10);
            
            self.answerPromptLabel.sd_layout
            .topSpaceToView(self.contentView,20)
            .leftSpaceToView(self.contentView,20)
            .widthIs(150)
            .heightIs(30);
            
            self.answerLabel.sd_layout
            .topSpaceToView(self.answerPromptLabel,10)
            .leftEqualToView(self.answerPromptLabel)
            .rightSpaceToView(self.contentView,20)
            .autoHeightRatio(0);
            
            self.gapIV.sd_layout
            .topSpaceToView(self.answerPromptLabel,10)
            .leftSpaceToView(self.contentView,10)
            .widthIs(2)
            .bottomSpaceToView(self.contentView,10);
            
            [self setupAutoHeightWithBottomViewsArray:@[self.backView] bottomMargin:10];
            
        }else{
        self.answerLabel.text = caseDetailModel.userAnswer;
            self.backView.sd_layout
            .topSpaceToView(self.contentView,10)
            .leftSpaceToView(self.contentView,10)
            .rightSpaceToView(self.contentView,10)
            .bottomSpaceToView(self.contentView,0);
            
            self.answerPromptLabel.sd_layout
            .topSpaceToView(self.contentView,20)
            .leftSpaceToView(self.contentView,20)
            .widthIs(150)
            .heightIs(30);
            
            self.answerLabel.sd_layout
            .topSpaceToView(self.answerPromptLabel,10)
            .leftEqualToView(self.answerPromptLabel)
            .rightSpaceToView(self.contentView,20)
            .autoHeightRatio(0);
            
            self.gapIV.sd_layout
            .topSpaceToView(self.answerPromptLabel,10)
            .leftSpaceToView(self.contentView,10)
            .widthIs(2)
            .bottomSpaceToView(self.contentView,5);
            
            [self setupAutoHeightWithBottomViewsArray:@[self.answerLabel] bottomMargin:10];
        }
       
    }else{
         NSInteger alreadyOverTime = [caseDetailModel.alreadyOverTime integerValue];
        if (alreadyOverTime == 1) {
            if (self.section == 1) {
                self.answerLabel.text = caseDetailModel.viewPoint;
                
                self.backView.sd_layout
                .topSpaceToView(self.contentView,10)
                .leftSpaceToView(self.contentView,10)
                .rightSpaceToView(self.contentView,10)
                .bottomSpaceToView(self.contentView,10);
                
                self.answerPromptLabel.sd_layout
                .topSpaceToView(self.contentView,20)
                .leftSpaceToView(self.contentView,20)
                .widthIs(150)
                .heightIs(30);
                
                self.answerLabel.sd_layout
                .topSpaceToView(self.answerPromptLabel,10)
                .leftEqualToView(self.answerPromptLabel)
                .rightSpaceToView(self.contentView,20)
                .autoHeightRatio(0);
                
                self.gapIV.sd_layout
                .topSpaceToView(self.answerPromptLabel,10)
                .leftSpaceToView(self.contentView,10)
                .widthIs(2)
                .bottomSpaceToView(self.contentView,10);
                
                [self setupAutoHeightWithBottomViewsArray:@[self.backView] bottomMargin:10];
                
            }
        }
    }

}

-(void)setRadioModel:(CSRadioModel *)radioModel{
    
    if ([self.canAnswer integerValue] == 0) {
        _radioModel = radioModel;
        self.answerLabel.text = radioModel.userAnswerText;
        
        self.backView.sd_layout
        .topSpaceToView(self.contentView,10)
        .leftSpaceToView(self.contentView,10)
        .rightSpaceToView(self.contentView,10)
        .bottomSpaceToView(self.contentView,0);
        
        self.answerPromptLabel.sd_layout
        .topSpaceToView(self.contentView,20)
        .leftSpaceToView(self.contentView,20)
        .widthIs(150)
        .heightIs(30);
        
        self.answerLabel.sd_layout
        .topSpaceToView(self.answerPromptLabel,10)
        .leftEqualToView(self.answerPromptLabel)
        .rightSpaceToView(self.contentView,20)
        .autoHeightRatio(0);
        
        self.gapIV.sd_layout
        .topSpaceToView(self.answerPromptLabel,10)
        .leftSpaceToView(self.contentView,10)
        .widthIs(2)
        .bottomSpaceToView(self.contentView,5);
        
        [self setupAutoHeightWithBottomViewsArray:@[self.gapIV] bottomMargin:10];
        
    }
   
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
