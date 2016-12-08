//
//  CSCommentCell.m
//  tencent
//
//  Created by admin on 16/5/7.
//  Copyright © 2016年 cyh. All rights reserved.
//

#import "CSCommentCell.h"
#import "CSConfig.h"
#import "CSColorConfig.h"
#import "CSFrameConfig.h"
#import "CSFontConfig.h"
#import "UIView+SDAutoLayout.h"


@interface CSCommentCell()
@property (nonatomic, strong) UITapGestureRecognizer *tapGesture;
@end
@implementation CSCommentCell

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
        _tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didSelectedReply)];
        [self addGestureRecognizer:_tapGesture];

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
    
    self.gapIV = [UIImageView new];
    self.gapIV.image = [UIImage imageNamed:@"line_dotted"];
    [self.contentView addSubview:self.gapIV];
    
    //添加约束
    self.backView.sd_layout
    .leftSpaceToView(self.contentView,0)
    .topSpaceToView(self.contentView,0)
    .rightSpaceToView(self.contentView,0)
    .bottomSpaceToView(self.contentView,0);
    
    self.nameLabel.sd_layout
    .leftSpaceToView(self.contentView,10)
    .topSpaceToView(self.contentView,10)
    .widthIs(200)
    .heightIs(20);
    
    self.praiseBtn.sd_layout
    .leftSpaceToView(self.contentView,self.contentView.frame.size.width - 70)
    .topSpaceToView(self.contentView,10)
    .rightSpaceToView(self.contentView,10)
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
    .topSpaceToView(self.timeLabel,5)
    .leftSpaceToView(self.contentView,10)
    .rightSpaceToView(self.contentView,10)
    .heightIs(1);
    
}

-(void)layoutSubviews{
    [super layoutSubviews];
    NSLog(@"section:%d",self.section);
    self.nameLabel.text = self.commentModel.userModel.name;
    [self.praiseBtn setTitle:[NSString stringWithFormat:@"%ld",[self.commentModel.praiseCount integerValue]] forState:UIControlStateNormal];
    if ([self.commentModel.praiseId integerValue] > 0) {
        [self.praiseBtn setImage:[UIImage imageNamed:@"icon_yidianzan"] forState:UIControlStateNormal];
    }else{
        [self.praiseBtn setImage:[UIImage imageNamed:@"icon_dianzan"] forState:UIControlStateNormal];
    }
    self.contentLabel.text = self.commentModel.content;
    self.timeLabel.text = self.commentModel.createDate;
    
    
    if (self.commentModel.replyComments.count > 0 ) {
        [self.gapIV setHidden:YES];
        UIImageView *shapeIv = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"shape3"]];
        shapeIv.frame = CGRectMake(self.contentView.frame.size.width - 70, self.contentView.frame.size.height - 13, 20, 14);
        [self.contentView addSubview:shapeIv];
    }
    
    if (self.commentType == CSCommentStudyCaseType) {
        self.backgroundColor = [UIColor whiteColor];
        if (self.section == 2) {
            
            //添加约束
            self.backView.sd_layout
            .leftSpaceToView(self.contentView,10)
            .topSpaceToView(self.contentView,0)
            .rightSpaceToView(self.contentView,10)
            .bottomSpaceToView(self.contentView,0);
            
            UIView *leftView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 10, self.contentView.frame.size.height + 2)];
            leftView.backgroundColor = kBGColor;
            [self.contentView addSubview:leftView];
            
            UIImageView *catalogIV = [[UIImageView alloc]init];
            catalogIV.image = [UIImage imageNamed:@"img_lable"];
            [self.contentView addSubview:catalogIV];
            
            catalogIV.sd_layout
            .topSpaceToView(self.contentView,5)
            .leftSpaceToView(self.contentView,5)
            .widthIs(60)
            .heightIs(25);
            
            
            UILabel *catalogLabel = [[UILabel alloc]init];
            catalogLabel.text = @"评论";
            catalogLabel.textAlignment = NSTextAlignmentCenter;
            catalogLabel.textColor = [UIColor whiteColor];
            catalogLabel.font = [UIFont systemFontOfSize:14.0];
            [self.contentView addSubview:catalogLabel];
            catalogLabel.sd_layout
            .topSpaceToView(self.contentView,8)
            .leftSpaceToView(self.contentView,10)
            .widthIs(60)
            .heightIs(25);
            
            self.nameLabel.sd_layout
            .leftSpaceToView(self.contentView,20)
            .topSpaceToView(self.contentView,40)
            .widthIs(200)
            .heightIs(20);
            
            self.praiseBtn.sd_layout
            .leftSpaceToView(self.contentView,self.contentView.frame.size.width - 80)
            .topSpaceToView(self.contentView,40)
            .rightSpaceToView(self.contentView,20)
            .heightIs(20);
            
            self.contentLabel.sd_layout
            .topSpaceToView(self.nameLabel,10)
            .leftEqualToView(self.nameLabel)
            .rightSpaceToView(self.contentView,10)
            .autoHeightRatio(0);
            
            self.timeLabel.sd_layout
            .topSpaceToView(self.contentLabel,20)
            .leftEqualToView(self.nameLabel)
            .widthIs(200)
            .heightIs(20);
            
            self.gapIV.sd_layout
            .topSpaceToView(self.timeLabel,5)
            .leftSpaceToView(self.contentView,20)
            .rightSpaceToView(self.contentView,20)
            .heightIs(1);
            
           
            
            UIView *rightView = [[UIView alloc]initWithFrame:CGRectMake(self.contentView.frame.size.width - 10, 0, 10, self.contentView.frame.size.height + 2)];
            rightView.backgroundColor = kBGColor;
            [self.contentView addSubview:rightView];
            
            
            [self setupAutoHeightWithBottomViewsArray:@[self.gapIV] bottomMargin:10];

        }else{
            //添加约束
            self.backView.sd_layout
            .leftSpaceToView(self.contentView,10)
            .topSpaceToView(self.contentView,0)
            .rightSpaceToView(self.contentView,10)
            .bottomSpaceToView(self.contentView,0);
            
            self.nameLabel.sd_layout
            .leftSpaceToView(self.contentView,20)
            .topSpaceToView(self.contentView,10)
            .widthIs(200)
            .heightIs(20);
            
            self.praiseBtn.sd_layout
            .leftSpaceToView(self.contentView,self.contentView.frame.size.width - 80)
            .topSpaceToView(self.contentView,10)
            .rightSpaceToView(self.contentView,20)
            .heightIs(20);
            
            self.contentLabel.sd_layout
            .topSpaceToView(self.nameLabel,10)
            .leftEqualToView(self.nameLabel)
            .rightSpaceToView(self.contentView,10)
            .autoHeightRatio(0);
            
            self.timeLabel.sd_layout
            .topSpaceToView(self.contentLabel,20)
            .leftEqualToView(self.nameLabel)
            .widthIs(200)
            .heightIs(20);
            
            self.gapIV.sd_layout
            .topSpaceToView(self.timeLabel,5)
            .leftSpaceToView(self.contentView,20)
            .rightSpaceToView(self.contentView,20)
            .heightIs(1);
            
            UIView *leftView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 10, self.contentView.frame.size.height + 2)];
            leftView.backgroundColor = kBGColor;
            [self.contentView addSubview:leftView];
            
            UIView *rightView = [[UIView alloc]initWithFrame:CGRectMake(self.contentView.frame.size.width - 10, 0, 10, self.contentView.frame.size.height + 2)];
            rightView.backgroundColor = kBGColor;
            [self.contentView addSubview:rightView];
            
            
            [self setupAutoHeightWithBottomViewsArray:@[self.gapIV] bottomMargin:10];

        }
       
    }else if (self.commentType == CSCommentSpecialType){
        
        self.backView.sd_layout
        .leftSpaceToView(self.contentView,0)
        .topSpaceToView(self.contentView,0)
        .rightSpaceToView(self.contentView,0)
        .bottomSpaceToView(self.contentView,0);
        
        self.nameLabel.sd_layout
        .leftSpaceToView(self.contentView,10)
        .topSpaceToView(self.contentView,10)
        .widthIs(200)
        .heightIs(20);
        
        self.praiseBtn.sd_layout
        .leftSpaceToView(self.contentView,self.contentView.frame.size.width - 80)
        .topSpaceToView(self.contentView,10)
        .rightSpaceToView(self.contentView,10)
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
        .topSpaceToView(self.timeLabel,5)
        .leftSpaceToView(self.contentView,10)
        .rightSpaceToView(self.contentView,10)
        .heightIs(1);
        
       [self setupAutoHeightWithBottomViewsArray:@[self.gapIV] bottomMargin:0.1];
    }
}

//重新计算回复评论的高度
- (CGFloat)getCellHeight{
    CGFloat cellHeight = 76.0;
    self.contentLabel.font = kContentFont;
    CGSize size;
    if (self.commentType == CSCommentStudyCaseType){
        if (self.section == 2) {
            cellHeight += 40;
        }else{
        cellHeight += 10;
        }
        
    size = CGSizeMake(self.frame.size.width,2000);
    }else if (self.commentType == CSCommentSpecialType){
    size = CGSizeMake(self.frame.size.width - 40,2000);
    }
    CGSize labelSize = [self.commentModel.content sizeWithFont:kContentFont constrainedToSize:size lineBreakMode:NSLineBreakByWordWrapping];
    cellHeight += labelSize.height;
    return cellHeight;
}

- (void)didSelectedReply{
    if (self.didSelectedReplyBlock) {
        self.didSelectedReplyBlock(self.indexPath);
    }
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
        // Configure the view for the selected state
}

@end
