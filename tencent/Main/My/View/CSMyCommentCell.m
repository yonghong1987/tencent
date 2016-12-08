//
//  CSMyCommentCell.m
//  tencent
//
//  Created by cyh on 16/8/25.
//  Copyright © 2016年 cyh. All rights reserved.
//

#import "CSMyCommentCell.h"
#import "CSConfig.h"
#import "CSColorConfig.h"
#import "CSFrameConfig.h"
#import "CSFontConfig.h"
#import "UIView+SDAutoLayout.h"
#import "CSCommentSourceModel.h"
@implementation CSMyCommentCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])
    {
        self.backgroundColor = kBGColor;
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self initUI];
    }
    return self;
}

- (void)initUI{
    
    self.backView = [UIView new];
    self.backView.backgroundColor = [UIColor whiteColor];
    [self.contentView addSubview:self.backView];
    
    self.nameLabel = [[UILabel alloc] init];
    self.nameLabel.textColor = kTitleColor;
    self.nameLabel.font = kMainTitleFont;
    [self.contentView addSubview:self.nameLabel];
    
    self.praiseBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.praiseBtn setImage:[UIImage imageNamed:@"icon_dianzan"] forState:UIControlStateNormal];
    [self.praiseBtn setImageEdgeInsets:UIEdgeInsetsMake(4, -10, 3, 0)];
    [self.praiseBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, 5,0 , 0)];
    [self.praiseBtn setTitleColor:kTimeColor forState:UIControlStateNormal];
    self.praiseBtn.titleLabel.font = kTimeFont;
    [self.contentView addSubview:self.praiseBtn];
    
    self.contentLabel = [[UILabel alloc] init];
    self.contentLabel.font = kContentFont;
    self.contentLabel.textColor = kTitleColor;
    [self.contentView addSubview:self.contentLabel];
    
    self.timeLabel = [UILabel new];
    self.timeLabel.font = kTimeFont;
    self.timeLabel.textColor = kTimeColor;
    [self.contentView addSubview:self.timeLabel];
    
    self.flagLabel = [UILabel new];
    self.flagLabel.backgroundColor = kCSThemeColor;
    [self.contentView addSubview:self.flagLabel];
    
    self.sourceNameLabel = [UILabel new];
    self.sourceNameLabel.backgroundColor = [UIColor colorWithRed:247.0/255.0 green:248.0/255.0 blue:250.0/255.0 alpha:1.0];
    self.sourceNameLabel.font = kMainTitleFont;
    self.sourceNameLabel.userInteractionEnabled = NO;
    [self.contentView addSubview:self.sourceNameLabel];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button addTarget:self action:@selector(tapAction) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:button];
    
    self.gapIV = [UIImageView new];
//    self.gapIV.image = [UIImage imageNamed:@"line_dotted"];
    [self.contentView addSubview:self.gapIV];
    
    //添加约束
    self.nameLabel.sd_layout
    .leftSpaceToView(self.contentView,20)
    .topSpaceToView(self.contentView,20)
    .widthIs(200)
    .heightIs(20);
    
    self.praiseBtn.sd_layout
    .leftSpaceToView(self.contentView,self.contentView.frame.size.width - 60)
    .topSpaceToView(self.contentView,20)
    .rightSpaceToView(self.contentView,20)
    .heightIs(20);
    
    self.contentLabel.sd_layout
    .topSpaceToView(self.nameLabel,10)
    .leftEqualToView(self.nameLabel)
    .rightSpaceToView(self.contentView,10)
    .autoHeightRatio(0);
    
    self.timeLabel.sd_layout
    .topSpaceToView(self.contentLabel,10)
    .leftEqualToView(self.nameLabel)
    .widthIs(200)
    .heightIs(20);
    
    self.flagLabel.sd_layout
    .topSpaceToView(self.timeLabel,10)
    .leftSpaceToView(self.contentView,20)
    .widthIs(2)
    .heightIs(30);
    
    self.sourceNameLabel.sd_layout
    .topEqualToView(self.flagLabel)
    .leftSpaceToView(self.flagLabel,1)
    .rightSpaceToView(self.contentView,20)
    .heightIs(30);
    
    button.sd_layout
    .topEqualToView(self.flagLabel)
    .leftSpaceToView(self.flagLabel,1)
    .rightSpaceToView(self.contentView,20)
    .heightIs(30);
    
    self.gapIV.sd_layout
    .topSpaceToView(self.sourceNameLabel,10)
    .leftSpaceToView(self.contentView,10)
    .rightSpaceToView(self.contentView,10)
    .heightIs(1);
    
    self.backView.sd_layout
    .leftSpaceToView(self.contentView,10)
    .topSpaceToView(self.contentView,0)
    .rightSpaceToView(self.contentView,10)
    .bottomSpaceToView(self.contentView,0);
    
    [self setupAutoHeightWithBottomViewsArray:@[self.gapIV] bottomMargin:1];
}

-(void)setCommentModel:(CSSpecialCommentModel *)commentModel{
    _commentModel = commentModel;
    self.nameLabel.text = self.commentModel.userModel.name;
    [self.praiseBtn setTitle:[NSString stringWithFormat:@"%ld",[self.commentModel.praiseCount integerValue]] forState:UIControlStateNormal];
    if ([self.commentModel.praiseId integerValue] > 0) {
        [self.praiseBtn setImage:[UIImage imageNamed:@"icon_yidianzan"] forState:UIControlStateNormal];
    }else{
        [self.praiseBtn setImage:[UIImage imageNamed:@"icon_dianzan"] forState:UIControlStateNormal];
    }
    self.contentLabel.text = self.commentModel.content;
    self.timeLabel.text = self.commentModel.createDate;
    CSCommentSourceModel *sourceModel = commentModel.sourceModel;
    self.sourceNameLabel.text = [NSString stringWithFormat:@" 评论来源: %@",sourceModel.content];
}

-(void)tapAction{
    if (self.clickSelectionAction) {
        self.clickSelectionAction();
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
