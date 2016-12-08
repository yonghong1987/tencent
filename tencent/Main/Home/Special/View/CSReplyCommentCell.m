//
//  CSReplyCommentCell.m
//  tencent
//
//  Created by admin on 16/5/7.
//  Copyright © 2016年 cyh. All rights reserved.
//

#import "CSReplyCommentCell.h"
#import "CSConfig.h"
#import "CSColorConfig.h"
#import "CSFrameConfig.h"
#import "CSFontConfig.h"
#import "UIView+SDAutoLayout.h"
@implementation CSReplyCommentCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])
    {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
//        UITapGestureRecognizer *tapGest = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(creatReplyView:)];
//        [self addGestureRecognizer:tapGest];
        [self initUI];
    }
    return self;
}

- (void)initUI{
//    self.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"box_comments"]];
    self.backImg = [[UIImageView alloc] init];
    self.backImg.image = [UIImage imageNamed:@"box_comments"];
    [self.contentView addSubview:self.backImg];
    
    self.nameLabel = [[UILabel alloc] init];
    self.nameLabel.textColor = kTitleColor;
    self.nameLabel.font = kMainTitleFont;
    [self.contentView addSubview:self.nameLabel];
    
    self.contentLabel = [[UILabel alloc] init];
    self.contentLabel.font = kContentFont;
    self.contentLabel.textColor = kTitleColor;
    [self.contentView addSubview:self.contentLabel];
    
    self.timeLabel = [UILabel new];
    self.timeLabel.font = kTimeFont;
    self.timeLabel.textColor = kTimeColor;
    [self.contentView addSubview:self.timeLabel];
    
    self.gapIV = [UIImageView new];
    self.gapIV.image = [UIImage imageNamed:@"line_dotted"];
    [self.contentView addSubview:self.gapIV];
    //添加约束
    self.backImg.sd_layout
    .leftSpaceToView(self.contentView,10)
    .topSpaceToView(self.contentView,0)
    .rightSpaceToView(self.contentView,0)
    .bottomSpaceToView(self.contentView,0);
    
    self.nameLabel.sd_layout
    .leftSpaceToView(self.contentView,20)
    .topSpaceToView(self.contentView,10)
    .widthIs(200)
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
    
    self.gapIV.sd_layout
    .bottomSpaceToView(self.contentView,0)
    .leftSpaceToView(self.contentView,20)
    .rightSpaceToView(self.contentView,10)
    .heightIs(1);
}

-(void)layoutSubviews{
    [super layoutSubviews];
    self.nameLabel.text = self.replyCommentModel.userModel.name;
    self.contentLabel.text = self.replyCommentModel.content;
    self.timeLabel.text = self.replyCommentModel.createDate;
    [self setupAutoHeightWithBottomViewsArray:@[self.timeLabel] bottomMargin:10];
    self.cellReplyView.frame = CGRectMake(self.contentView.frame.size.width / 2 - 55 , self.contentView.frame.size.height / 2 - 25, 110, 50);
    if (self.commentType == CSCommentStudyCaseType) {
        //添加约束
        self.backImg.sd_layout
        .leftSpaceToView(self.contentView,20)
        .topSpaceToView(self.contentView,0)
        .rightSpaceToView(self.contentView,10)
        .bottomSpaceToView(self.contentView,0);
        
        self.nameLabel.sd_layout
        .leftSpaceToView(self.contentView,30)
        .topSpaceToView(self.contentView,10)
        .widthIs(200)
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
        
        self.gapIV.sd_layout
        .bottomSpaceToView(self.contentView,0)
        .leftSpaceToView(self.contentView,20)
        .rightSpaceToView(self.contentView,10)
        .heightIs(1);
        
        UIView *leftView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 10, self.contentView.frame.size.height)];
        leftView.backgroundColor = kBGColor;
        [self.contentView addSubview:leftView];
        
        UIView *rightView = [[UIView alloc]initWithFrame:CGRectMake(self.contentView.frame.size.width - 10, 0, 10, self.contentView.frame.size.height)];
        rightView.backgroundColor = kBGColor;
        [self.contentView addSubview:rightView];

    }else if (self.commentType == CSCommentSpecialType){
        //添加约束
        self.backImg.sd_layout
        .leftSpaceToView(self.contentView,10)
        .topSpaceToView(self.contentView,0)
        .rightSpaceToView(self.contentView,0)
        .bottomSpaceToView(self.contentView,0);
        
        self.nameLabel.sd_layout
        .leftSpaceToView(self.contentView,20)
        .topSpaceToView(self.contentView,10)
        .widthIs(200)
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
        
        self.gapIV.sd_layout
        .bottomSpaceToView(self.contentView,0)
        .leftSpaceToView(self.contentView,20)
        .rightSpaceToView(self.contentView,10)
        .heightIs(1);
       
    }
}

//重新计算回复评论的高度
- (CGFloat)getCellHeight{
    CGFloat cellHeight = 76.0;
    self.contentLabel.font = kContentFont;
    CGSize size;
    if (self.commentType == CSCommentStudyCaseType){
//        cellHeight += 10;
        size = CGSizeMake(self.frame.size.width - 50,2000);
    }else if (self.commentType == CSCommentSpecialType){
        size = CGSizeMake(self.frame.size.width - 40,2000);
    }
    CGSize labelSize = [self.replyCommentModel.content sizeWithFont:kContentFont constrainedToSize:size lineBreakMode:NSLineBreakByWordWrapping];

    cellHeight += labelSize.height;
    return cellHeight;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
