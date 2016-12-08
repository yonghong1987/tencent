//
//  CSExamResultView.m
//  tencent
//
//  Created by cyh on 16/8/20.
//  Copyright © 2016年 cyh. All rights reserved.
//

#import "CSExamResultView.h"
#import "UIView+SDAutoLayout.h"
#import "CSFontConfig.h"
#import "CSFrameConfig.h"
#import "CSColorConfig.h"
#import "UIImageView+AFNetworking.h"
@interface CSExamResultView ()
/**
 *通关状态iv
 */
@property (nonatomic, strong) UIImageView *statusIV;
@property (nonatomic, strong) UIView *scoreView;
/**
 *考试名称
 */
@property (nonatomic, strong) UILabel *examNameLabel;
/**
 *考试得分
 */
@property (nonatomic, strong) UILabel *scoreLabel;
@property (nonatomic, strong) UILabel *gapLabel;
/**
 *卷面总分
 */
@property (nonatomic, strong) UILabel *totalLabel;
/**
 *合格分
 */
@property (nonatomic, strong) UILabel *qualifiedScoreLabel;
/**
 *描述
 */
@property (nonatomic, strong) UILabel *descriptionLabel;
@end

@implementation CSExamResultView

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
    self.backgroundColor = kBGColor;
    self.statusIV = [[UIImageView alloc]init];
    [self addSubview:self.statusIV];
    
    self.scoreView = [UIView new];
    self.scoreView.backgroundColor = [UIColor whiteColor];
    [self addSubview:self.scoreView];
    
    self.examNameLabel = [UILabel new];
    self.examNameLabel.textAlignment = NSTextAlignmentCenter;
    self.examNameLabel.font = kMainTitleFont;
    [self addSubview:self.examNameLabel];
    
    self.scoreLabel = [UILabel new];
    self.scoreLabel.textAlignment = NSTextAlignmentCenter;
    self.scoreLabel.font = [UIFont systemFontOfSize:36.0];
    self.scoreLabel.textColor = [UIColor redColor];
    [self addSubview:self.scoreLabel];
    
    self.gapLabel = [UILabel new];
    self.gapLabel.backgroundColor = [UIColor blackColor];
    [self addSubview:self.gapLabel];
    
    self.totalLabel = [UILabel new];
    self.totalLabel.textAlignment = NSTextAlignmentCenter;
    self.totalLabel.font = [UIFont systemFontOfSize:17.0];
    [self addSubview:self.totalLabel];
    
    self.qualifiedScoreLabel = [UILabel new];
    self.qualifiedScoreLabel.textAlignment = NSTextAlignmentCenter;
    self.qualifiedScoreLabel.font = [UIFont systemFontOfSize:17.0];
    [self addSubview:self.qualifiedScoreLabel];
    
    self.descriptionLabel = [UILabel new];
    self.descriptionLabel.textAlignment = NSTextAlignmentCenter;
    self.descriptionLabel.font = [UIFont systemFontOfSize:15.0];
    [self addSubview:self.descriptionLabel];

    CGFloat statusHeight = 236 * (kCSScreenWidth - 38 - 31) / 250;
    self.statusIV.sd_layout
    .leftSpaceToView(self,38)
    .rightSpaceToView(self,31)
    .topSpaceToView(self,27)
    .heightIs(statusHeight);
    
    CGFloat scoreHeight = 82 * (kCSScreenWidth - 17 - 16) / 287 + 10;
    self.scoreView.sd_layout
    .leftSpaceToView(self,17)
    .rightSpaceToView(self,16)
    .topSpaceToView(self.statusIV,5)
    .heightIs(scoreHeight);
    
    self.examNameLabel.sd_layout
    .topSpaceToView(self.statusIV,10)
    .leftSpaceToView(self,40)
    .rightSpaceToView(self,40)
    .autoHeightRatio(0);
    
    CGFloat width = (kCSScreenWidth - 17 - 16) / 2;
    self.scoreLabel.sd_layout
    .topSpaceToView(self.examNameLabel,10)
    .leftSpaceToView(self,17)
    .widthIs(width)
    .heightIs(60);
    
    self.gapLabel.sd_layout
    .topSpaceToView(self.examNameLabel,20)
    .leftSpaceToView(self.scoreLabel,1)
    .widthIs(1)
    .heightIs(40);
    
    self.totalLabel.sd_layout
    .topSpaceToView(self.examNameLabel,20)
    .leftSpaceToView(self.gapLabel,1)
    .widthIs(width)
    .heightIs(20);
    
    self.qualifiedScoreLabel.sd_layout
    .topSpaceToView(self.totalLabel,0)
    .leftSpaceToView(self.gapLabel,1)
    .widthIs(width)
    .heightIs(20);

    self.descriptionLabel.sd_layout
    .topSpaceToView(self.scoreView,5)
    .leftSpaceToView(self,17)
    .rightSpaceToView(self,16)
    .autoHeightRatio(0);
//    self.descriptionLabel.sd_layout
//    .topSpaceToView(self.scoreView,5)
//    .leftSpaceToView(self,17)
//    .rightSpaceToView(self,16)
//    .heightIs(40);
    
    [self setupAutoHeightWithBottomViewsArray:@[self.descriptionLabel] bottomMargin:20];
 }

-(void)setExamResultModel:(CSExamResultModel *)examResultModel{
    _examResultModel = examResultModel;
    NSInteger scoreLevel = [examResultModel.scoreLevel integerValue];
    //如果是评卷中
    if ([examResultModel.status isEqualToString:@"PROGRESS"]) {
        [self.statusIV setImageWithURL:[NSURL URLWithString:examResultModel.levelImg] placeholderImage:[UIImage imageNamed:@"img_pingjuanzhong6"]];
        self.scoreLabel.text = @"???";
    }else{
        if (scoreLevel == 5) {
            [self.statusIV setImageWithURL:[NSURL URLWithString:examResultModel.levelImg] placeholderImage:[UIImage imageNamed:@"img_xuezha5"]];
        }else if (scoreLevel == 4){
            [self.statusIV setImageWithURL:[NSURL URLWithString:examResultModel.levelImg] placeholderImage:[UIImage imageNamed:@"img_xueruo4"]];
        }else if (scoreLevel == 3){
            [self.statusIV setImageWithURL:[NSURL URLWithString:examResultModel.levelImg] placeholderImage:[UIImage imageNamed:@"img_xuemin3"]];
        }else if (scoreLevel == 2){
            [self.statusIV setImageWithURL:[NSURL URLWithString:examResultModel.levelImg] placeholderImage:[UIImage imageNamed:@"img_xueba2"]];
        }else if (scoreLevel == 1){
            [self.statusIV setImageWithURL:[NSURL URLWithString:examResultModel.levelImg] placeholderImage:[UIImage imageNamed:@"img_xueshen1"]];
        }
       self.scoreLabel.text = [NSString stringWithFormat:@"%ld分",[examResultModel.finalScore integerValue]];
        self.descriptionLabel.attributedText = [self displayInfoWithLevel:scoreLevel overPercent:examResultModel.overPercent];
    }
    
    self.examNameLabel.text = examResultModel.examActivityName;
    
    self.totalLabel.text = [NSString stringWithFormat:@"试卷总分:%ld",[examResultModel.score integerValue]];
    self.qualifiedScoreLabel.text = [NSString stringWithFormat:@"合格分数:%ld",[examResultModel.passingScore integerValue]];
}

-(NSMutableAttributedString *)displayInfoWithLevel:(NSInteger)level overPercent:(NSString *)overPercent{
    NSString *firstStr;
    NSString *lastStr;
    switch (level) {
        case 1:
            firstStr = @"这一关你的表现完美，分数超过了";
            lastStr = @"的同学，一直被追赶，从未被超越！";
            break;
        case 2:
            firstStr = @"恭喜你，你的分数超过了";
            lastStr = @"的同学，离人生巅峰只差一步，请再接再厉！";
            break;
        case 3:
            firstStr = @"你的分数只超过了";
            lastStr = @"的同学，为了走向人生巅峰，请继续努力吧。";
            break;
        case 4:
            firstStr = @"很遗憾，本次考试离通过只差一点点，";
            lastStr = @"别灰心，重在参与，下次再来！";
            break;
        case 5:
            firstStr = @"是不是手滑了...？以你的水平不应该这么低分啊，";
            lastStr = @"再来一次吧少年。";
            break;
        case 0:
            firstStr = @" ";
            lastStr = @" ";
            break;
        default:
            break;
    }
    NSMutableAttributedString *attributeString = [[NSMutableAttributedString alloc]initWithString:@" "];
    NSAttributedString *firstString = [[NSAttributedString alloc]initWithString:firstStr];
    NSAttributedString *lastString = [[NSAttributedString alloc]initWithString:lastStr];
    if (level == 1 ||level == 2 ||level == 3) {
        NSMutableAttributedString *scoreStr2 = [[NSMutableAttributedString alloc]initWithString:overPercent];
        [scoreStr2 addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(0, scoreStr2.length)];
        [attributeString appendAttributedString:firstString];
        [attributeString appendAttributedString:scoreStr2];
        [attributeString appendAttributedString:lastString];
    }else if(level == 4 || level == 5){
        [attributeString appendAttributedString:firstString];
        [attributeString appendAttributedString:lastString];
    }else{
        [attributeString appendAttributedString:firstString];
        [attributeString appendAttributedString:lastString];
    }
    
    return attributeString;
}

@end
