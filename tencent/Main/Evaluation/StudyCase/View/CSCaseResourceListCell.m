//
//  CSCaseResourceListCell.m
//  tencent
//
//  Created by cyh on 16/8/15.
//  Copyright © 2016年 cyh. All rights reserved.
//

#import "CSCaseResourceListCell.h"
#import "CSColorConfig.h"
#import "UIView+SDAutoLayout.h"
#import "CSFontConfig.h"
#import "CSFrameConfig.h"
@interface CSCaseResourceListCell ()
/**
 *背景视图
 */
@property (nonatomic, strong) UIView *backView;
/*
 **图标
 */
@property (nonatomic, strong) UIImageView *iconIV;
/**
 *名称
 */
@property (nonatomic, strong) UILabel *nameLabel;
/**
 *视频图标
 */
@property (nonatomic, strong) UIImageView *videoIV;
/**
 *播放器图标
 */
@property (nonatomic, strong) UIImageView *playIV;
/**
 *资源内容
 */
@property (nonatomic, strong) UILabel *contentLabel;
/**
 *时间
 */
@property (nonatomic, strong) UILabel *timeLabel;
/**
 *分割线1
 */
@property (nonatomic, strong) UILabel *gapLabel1;
/**
 *分隔线2
 */
@property (nonatomic, strong) UILabel *gapLabel2;

@end

@implementation CSCaseResourceListCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.backgroundColor = kBGColor;
        [self initUI];
    }
    return self;
}

-(void)initUI{
    
    self.backView = [UIView new];
    self.backView.backgroundColor = [UIColor whiteColor];
    [self.contentView addSubview:self.backView];
    
    self.iconIV = [UIImageView new];
    self.iconIV.image = [UIImage imageNamed:@"icon_article"];
//    self.iconIV.sd_cornerRadiusFromWidthRatio = @(0.5);
//    self.iconIV.sd_cornerRadiusFromHeightRatio = @(0.5);
    [self.contentView addSubview:self.iconIV];
    
    self.nameLabel = [UILabel new];
    [self.contentView addSubview:self.nameLabel];
    
    self.gapLabel1 = [UILabel new];
    self.gapLabel1.backgroundColor = [[UIColor grayColor]colorWithAlphaComponent:0.2];
    [self.contentView addSubview:self.gapLabel1];
    
    self.videoIV = [UIImageView new];
    self.videoIV.image = [UIImage imageNamed:@""];
    [self.contentView addSubview:self.videoIV];
    
    self.playIV = [[UIImageView alloc]init];
    self.playIV.image = [UIImage imageNamed:@"视频111"];
    [self.contentView addSubview:self.playIV];
    
    self.contentLabel = [UILabel new];
    [self.contentView addSubview:self.contentLabel];
    
    self.gapLabel2 = [UILabel new];
     self.gapLabel2.backgroundColor = [[UIColor grayColor]colorWithAlphaComponent:0.2];
    [self.contentView addSubview:self.gapLabel2];

    
    self.timeLabel = [UILabel new];
    self.timeLabel.textColor = kTimeColor;
    self.timeLabel.font = kTimeFont;
    [self.contentView addSubview:self.timeLabel];
    //添加约束
    self.backView.sd_layout
    .topSpaceToView(self.contentView,10)
    .leftSpaceToView(self.contentView,10)
    .rightSpaceToView(self.contentView,10)
    .bottomSpaceToView(self.contentView,0);
    
    self.iconIV.sd_layout
    .topSpaceToView(self.contentView,20)
    .leftSpaceToView(self.contentView,20)
    .widthIs(30)
    .heightEqualToWidth();
    
    self.nameLabel.sd_layout
    .topEqualToView(self.iconIV)
    .leftSpaceToView(self.iconIV,10)
    .rightSpaceToView(self.contentView,20)
    .heightIs(20);
    
    self.gapLabel1.sd_layout
    .topSpaceToView(self.iconIV,5)
    .leftSpaceToView(self.contentView,20)
    .rightSpaceToView(self.contentView,20);
    
    self.videoIV.sd_layout
    .topSpaceToView(self.iconIV,10)
    .leftSpaceToView(self.contentView,0)
    .rightSpaceToView(self.contentView,0)
    .heightIs(150);
    
    self.playIV.sd_layout
    .centerXEqualToView(self.videoIV)
    .centerYEqualToView(self.videoIV)
    .widthIs(40)
    .heightIs(40);
    
    self.contentLabel.sd_layout
    .topSpaceToView(self.iconIV,10)
    .leftSpaceToView(self.contentView,20)
    .rightSpaceToView(self.contentView,20)
    .autoHeightRatio(0);

    self.timeLabel.sd_layout
    .leftSpaceToView(self.contentView,20)
    .rightSpaceToView(self.contentView,20)
    .topSpaceToView(self.contentLabel,10)
    .heightIs(20);
    
    [self setupAutoHeightWithBottomViewsArray:@[self.timeLabel] bottomMargin:5];
}

-(void)setResourceModel:(CSCourseResourceModel *)resourceModel{
    _resourceModel = resourceModel;
    self.nameLabel.text = resourceModel.resName;
    self.contentLabel.text = resourceModel.resDescribe;
    self.timeLabel.text = resourceModel.modifiedDate;
    if ([resourceModel.resCode isEqualToString:@"ARTICLE"]) {
        self.iconIV.image = [UIImage imageNamed:@"icon_article"];
        //添加约束
        self.backView.sd_layout
        .topSpaceToView(self.contentView,10)
        .leftSpaceToView(self.contentView,10)
        .rightSpaceToView(self.contentView,10)
        .bottomSpaceToView(self.contentView,0);
        
        self.iconIV.sd_layout
        .topSpaceToView(self.contentView,20)
        .leftSpaceToView(self.contentView,20)
        .widthIs(30)
        .heightEqualToWidth();
        
        self.nameLabel.sd_layout
        .topEqualToView(self.iconIV)
        .leftSpaceToView(self.iconIV,10)
        .rightSpaceToView(self.contentView,20)
        .heightIs(20);
        
        self.gapLabel1.sd_layout
        .topSpaceToView(self.iconIV,5)
        .leftSpaceToView(self.contentView,20)
        .rightSpaceToView(self.contentView,20)
        .heightIs(0.5);
        [self.videoIV setHidden:YES];
        [self.playIV setHidden:YES];
        self.contentLabel.sd_layout
        .topSpaceToView(self.iconIV,10)
        .leftSpaceToView(self.contentView,20)
        .rightSpaceToView(self.contentView,20)
        .autoHeightRatio(0);
        
        self.gapLabel2.sd_layout
        .topSpaceToView(self.contentLabel,5)
        .leftEqualToView(self.iconIV)
        .rightSpaceToView(self.contentView,20)
        .heightIs(0.5);
        
        self.timeLabel.sd_layout
        .leftSpaceToView(self.contentView,20)
        .rightSpaceToView(self.contentView,20)
        .topSpaceToView(self.contentLabel,10)
        .heightIs(20);
        
        [self setupAutoHeightWithBottomViewsArray:@[self.timeLabel] bottomMargin:5];
    }else if ([resourceModel.resCode isEqualToString:@"VIDEO"]){
        self.iconIV.image = [UIImage imageNamed:@"icon_video"];
        //添加约束
        self.backView.sd_layout
        .topSpaceToView(self.contentView,10)
        .leftSpaceToView(self.contentView,10)
        .rightSpaceToView(self.contentView,10)
        .bottomSpaceToView(self.contentView,0);
        
        self.iconIV.sd_layout
        .topSpaceToView(self.contentView,20)
        .leftSpaceToView(self.contentView,20)
        .widthIs(30)
        .heightEqualToWidth();
        
        self.nameLabel.sd_layout
        .topEqualToView(self.iconIV)
        .leftSpaceToView(self.iconIV,10)
        .rightSpaceToView(self.contentView,20)
        .heightIs(20);
        
        self.gapLabel1.sd_layout
        .topSpaceToView(self.iconIV,5)
        .leftSpaceToView(self.contentView,20)
        .rightSpaceToView(self.contentView,20)
        .heightIs(0.5);
        
        self.videoIV.sd_layout
        .topSpaceToView(self.iconIV,10)
        .leftSpaceToView(self.contentView,0)
        .rightSpaceToView(self.contentView,0)
        .heightIs(150);
        
        self.playIV.sd_layout
        .centerXEqualToView(self.videoIV)
        .centerYEqualToView(self.videoIV)
        .widthIs(40)
        .heightIs(40);
        
        self.gapLabel2.sd_layout
        .topSpaceToView(self.videoIV,5)
        .leftEqualToView(self.iconIV)
        .rightSpaceToView(self.contentView,20)
        .heightIs(0.5);
        
        [self.contentLabel setHidden:YES];
        
        self.timeLabel.sd_layout
        .leftSpaceToView(self.contentView,20)
        .rightSpaceToView(self.contentView,20)
        .topSpaceToView(self.videoIV,10)
        .heightIs(20);
        
        
        [self setupAutoHeightWithBottomViewsArray:@[self.timeLabel] bottomMargin:5];
    }

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
