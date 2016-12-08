//
//  CSPostCommentCell.m
//  tencent
//
//  Created by cyh on 16/7/26.
//  Copyright © 2016年 cyh. All rights reserved.
//

#import "CSPostCommentCell.h"
#import "CSConfig.h"
#import "CSColorConfig.h"
#import "CSFrameConfig.h"
#import "CSFontConfig.h"
#import "UIView+SDAutoLayout.h"
#import "UIColor+HEX.h"
#import "CSUserModel.h"
#import "CSColorConfig.h"
@implementation CSPostCommentCell

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
    self.backView = [[UIView alloc]init];
    self.backView.backgroundColor = [UIColor whiteColor];
    [self.contentView addSubview:self.backView];
    
    self.roleIV = [[UIImageView alloc]init];
    self.roleIV.backgroundColor = [UIColor whiteColor];
    [self.contentView addSubview:self.roleIV];
    
    self.nameLabel = [[UILabel alloc] init];
    self.nameLabel.textColor = kTitleColor;
    self.nameLabel.font = kMainTitleFont;
    [self.contentView addSubview:self.nameLabel];
    
    self.topLabel = [[UILabel alloc] init];
    self.topLabel.backgroundColor = [UIColor colorWithHexString:@"#f39179"];
    self.topLabel.text = @"置顶";
    self.topLabel.textAlignment = NSTextAlignmentCenter;
    self.topLabel.textColor = [UIColor whiteColor];
    self.topLabel.font = kForumTopFont;
    [self.contentView addSubview:self.topLabel];
    
    self.praiseBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.praiseBtn setImage:[UIImage imageNamed:@"icon_dianzan"] forState:UIControlStateNormal];
    [self.praiseBtn setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 5)];
    [self.praiseBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, 0,0 , 0)];
    self.praiseBtn.titleLabel.font = kCaseCatalogNameFont;
    [self.praiseBtn setTitleColor:kTitleColor forState:UIControlStateNormal];
    [self.contentView addSubview:self.praiseBtn];
    
    self.contentLabel = [[UILabel alloc] init];
    self.contentLabel.font = kContentFont;
    self.contentLabel.textColor = kTimeColor;
    [self.contentView addSubview:self.contentLabel];
    
    self.timeLabel = [UILabel new];
    self.timeLabel.font = kTimeFont;
    self.timeLabel.textColor = kTimeColor;
    [self.contentView addSubview:self.timeLabel];
    
    self.roleLabel = [[UILabel alloc] init];
    self.roleLabel.font = kContentFont;
    [self.contentView addSubview:self.roleLabel];
    
    self.gapIV = [UIImageView new];
    self.gapIV.image = [UIImage imageNamed:@"line_dotted"];
    [self.contentView addSubview:self.gapIV];
    
    //添加约束
    self.backView.sd_layout
    .leftSpaceToView(self.contentView,10)
    .topSpaceToView(self.contentView,0)
    .rightSpaceToView(self.contentView,10)
    .bottomSpaceToView(self.contentView,0);
    
    self.nameLabel.sd_layout
    .leftSpaceToView(self.contentView,20)
    .topSpaceToView(self.contentView,10)
    .heightIs(20);
    [self.nameLabel setSingleLineAutoResizeWithMaxWidth:250];
    
    self.roleIV.sd_layout
    .topEqualToView(self.nameLabel)
    .leftSpaceToView(self.contentView,10)
    .widthIs(2)
    .bottomSpaceToView(self.contentView,10);
    
    self.topLabel.sd_layout
    .leftSpaceToView(self.nameLabel,10)
    .topEqualToView(self.nameLabel)
    .widthIs(30)
    .heightIs(20);
    
    self.praiseBtn.sd_layout
    .topEqualToView(self.nameLabel)
    .rightSpaceToView(self.contentView,20)
    .widthIs(50)
    .heightIs(15);
    
    self.contentLabel.sd_layout
    .leftEqualToView(self.nameLabel)
    .topSpaceToView(self.nameLabel,10)
    .rightSpaceToView(self.contentView,20)
    .autoHeightRatio(0);
    
    self.timeLabel.sd_layout
    .leftEqualToView(self.nameLabel)
    .topSpaceToView(self.contentLabel,10)
    .widthIs(200)
    .heightIs(20);
    
    self.roleLabel.sd_layout
    .topEqualToView(self.timeLabel)
    .rightSpaceToView(self.contentView,20)
    .widthIs(80)
    .heightIs(20);
    
    self.gapIV.sd_layout
    .topSpaceToView(self.timeLabel,10)
    .leftEqualToView(self.timeLabel)
    .rightSpaceToView(self.contentView,20)
    .heightIs(1);
    
    [self setupAutoHeightWithBottomViewsArray:@[self.gapIV] bottomMargin:0.1];
}

-(void)setCommentModel:(CSSpecialCommentModel *)commentModel{
    _commentModel = commentModel;
    CSUserModel *user = commentModel.userModel;
    self.nameLabel.text = user.name;
    
    if ([self.commentModel.isTop integerValue] > 0) {
        [self.topLabel setHidden:NO];
    }else{
        [self.topLabel setHidden:YES];
    }
    [self.praiseBtn setTitle:[NSString stringWithFormat:@"%ld",[commentModel.praiseCount integerValue]] forState:UIControlStateNormal];
    if ([commentModel.praiseId boolValue]) {
        [self.praiseBtn setImage:[UIImage imageNamed:@"icon_yidianzan"] forState:UIControlStateNormal];
    }else{
    [self.praiseBtn setImage:[UIImage imageNamed:@"icon_dianzan"] forState:UIControlStateNormal];
    }
    self.contentLabel.text = commentModel.content;
    self.timeLabel.text = commentModel.createDate;
    if (user.userRoleType == CSUserRoleExportType) {
        self.roleIV.backgroundColor = kCSThemeColor;
        self.roleLabel.textColor = kCSThemeColor;
        self.roleLabel.text = @"专家评论";
    }else if (user.userRoleType == CSUserRoleSystemType){
        self.roleIV.backgroundColor = [UIColor colorWithHexString:@"#5cacdf"];
        self.roleLabel.textColor = [UIColor colorWithHexString:@"#5cacdf"];
        self.roleLabel.text = @"管理员评论";
    }else if (user.userRoleType == CSUserRoleLanType){
        self.roleIV.backgroundColor = [UIColor whiteColor];
        self.roleLabel.textColor = [UIColor whiteColor];
        self.roleLabel.text = @"";
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
