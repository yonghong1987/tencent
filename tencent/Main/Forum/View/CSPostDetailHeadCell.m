//
//  CSPostDetailHeadCell.m
//  tencent
//
//  Created by cyh on 16/7/26.
//  Copyright © 2016年 cyh. All rights reserved.
//

#import "CSPostDetailHeadCell.h"
#import "UIView+SDAutoLayout.h"
#import "CSColorConfig.h"
#import "CSFrameConfig.h"
#import "CSFontConfig.h"
@implementation CSPostDetailHeadCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self initUI];
    }
    return self;
}

-(void)initUI{
    self.backgroundColor = kBGColor;
    self.namelLabel = [[UILabel alloc] init];
    self.namelLabel.font = kNaviTitleFont;
    self.namelLabel.textColor = kTitleColor;
    [self.contentView addSubview:self.namelLabel];

    self.roleLabel = [UILabel new];
    self.roleLabel.text = @"楼主";
    self.roleLabel.textAlignment = NSTextAlignmentCenter;
    self.roleLabel.backgroundColor = CSColorFromRGB(100, 161, 195);
    self.roleLabel.font = kForumTopFont;
    self.roleLabel.layer.cornerRadius = 2.0;
    self.roleLabel.layer.masksToBounds = YES;
    self.roleLabel.textColor = [UIColor whiteColor];
    [self.contentView addSubview:self.roleLabel];

    self.gapIV = [UIImageView new];
    self.gapIV.image = [UIImage imageNamed:@"line_dotted"];
    [self.contentView addSubview:self.gapIV];
    
    self.commentTotalBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.commentTotalBtn.frame = CGRectZero;
    [self.commentTotalBtn setImage:[UIImage imageNamed:@"icon_pinglun_block"] forState:UIControlStateNormal];
    [self.commentTotalBtn setImageEdgeInsets:UIEdgeInsetsMake(0, -5, 0, 0)];
    [self.commentTotalBtn setTitleColor:kPraiseContent forState:UIControlStateNormal];
    self.commentTotalBtn.titleLabel.font = kCaseCatalogNameFont;
    [self.contentView addSubview:self.commentTotalBtn];
    self.contentLabel = [UILabel new];
    self.contentLabel.font = kNaviTitleFont;
    self.contentLabel.textColor = kTitleColor;
    [self.contentView addSubview:self.contentLabel];
    
    self.photoContainerView = [SMPhotoContainerView new];
    [self.contentView addSubview:self.photoContainerView];
    
    self.timeLabel = [UILabel new];
    self.timeLabel.font = kTimeFont;
    self.timeLabel.textColor = kTimeColor;
    [self.contentView addSubview:self.timeLabel];
    
    self.triangleIV = [[UIImageView alloc]init];
    self.triangleIV.image = [UIImage imageNamed:@"icon_play_white_up"];
    [self.contentView addSubview:self.triangleIV];
    
    //添加约束
    self.namelLabel.sd_layout
    .leftSpaceToView(self.contentView,20)
    .topSpaceToView(self.contentView,20)
    .heightIs(20);
    [self.namelLabel setSingleLineAutoResizeWithMaxWidth:300];
    
    self.roleLabel.sd_layout
    .leftSpaceToView(self.namelLabel,10)
    .topSpaceToView(self.contentView,22)
    .widthIs(30)
    .heightIs(15);
    
    self.commentTotalBtn.sd_layout
    .topEqualToView(self.namelLabel)
    .rightSpaceToView(self.contentView,20)
    .widthIs(50)
    .heightIs(20);
    
    self.gapIV.sd_layout
    .topSpaceToView(self.namelLabel,10)
    .leftEqualToView(self.namelLabel)
    .rightSpaceToView(self.contentView,20)
    .heightIs(1);
    
    self.contentLabel.sd_layout
    .leftEqualToView(self.namelLabel)
    .topSpaceToView(self.contentView,50)
    .rightSpaceToView(self.contentView,20)
    .autoHeightRatio(0);

    self.photoContainerView.sd_layout
    .leftEqualToView(self.contentLabel)
    .topSpaceToView(self.contentLabel,10);
    
    self.timeLabel.sd_layout
    .leftEqualToView(self.namelLabel)
    .topSpaceToView(self.photoContainerView,10)
    .widthIs(150)
    .heightIs(30);
    
    self.triangleIV.sd_layout
    .leftSpaceToView(self.timeLabel,5)
    .topSpaceToView(self.timeLabel,0)
    .widthIs(10)
    .heightIs(10);
    
    [self setupAutoHeightWithBottomViewsArray:@[self.timeLabel] bottomMargin:10];
}

-(void)setPostDetailModel:(CSPostDetailModel *)postDetailModel{
    _postDetailModel = postDetailModel;
    self.namelLabel.text = postDetailModel.creatorName;
    [self.commentTotalBtn setTitle:[NSString stringWithFormat:@"%ld",[postDetailModel.commentCount integerValue]] forState:UIControlStateNormal];
    self.contentLabel.text = postDetailModel.content;
    
    self.photoContainerView.picPathStringsArray = postDetailModel.postImages;
    self.timeLabel.text = postDetailModel.createDate;
    if ([postDetailModel.commentCount intValue] > 0) {
        self.triangleIV.sd_layout
        .leftSpaceToView(self.timeLabel,5)
        .topSpaceToView(self.timeLabel,0)
        .widthIs(10)
        .heightIs(10);
    }else{
        self.triangleIV.sd_layout
        .leftSpaceToView(self.timeLabel,5)
        .topSpaceToView(self.timeLabel,0)
        .widthIs(10)
        .heightIs(0);
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
