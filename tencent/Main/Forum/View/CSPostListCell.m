//
//  CSPostListCell.m
//  tencent
//
//  Created by admin on 16/5/23.
//  Copyright © 2016年 cyh. All rights reserved.
//

#import "CSPostListCell.h"
#import "UIView+SDAutoLayout.h"
#import "CSColorConfig.h"
#import "CSFrameConfig.h"
#import "CSFontConfig.h"
#define kIMAGE_GAP 10
#define kIMAGE_WIDTH (kCSScreenWidth - 4 * kIMAGE_GAP) / 3

@implementation CSPostListCell

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


-(void)initUI{
    self.backgroundColor = kBGColor;
    self.backView = [[UIView alloc]init];
    self.backView.backgroundColor = [UIColor whiteColor];
    [self.contentView addSubview:self.backView];
    
    self.namelLabel = [[UILabel alloc] init];
    self.namelLabel.font = kNaviTitleFont;
    self.namelLabel.textColor = kTimeColor;
    [self.contentView addSubview:self.namelLabel];
    
    self.topLabel = [UILabel new];
    self.topLabel.text = @"置顶";
    self.topLabel.textAlignment = NSTextAlignmentCenter;
    self.topLabel.backgroundColor = CSColorFromRGB(241, 145, 124);
    self.topLabel.font = kForumTopFont;
    self.topLabel.textColor = [UIColor whiteColor];
    [self.contentView addSubview:self.topLabel];
    
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
    
    self.photosView = [[CSPhotosView alloc]initWithFrame:CGRectZero photoViewSize:CGSizeMake(kIMAGE_WIDTH, kIMAGE_WIDTH) UIEdgeInset:UIEdgeInsetsMake(5, 5, 5, 5)];
    [self.contentView addSubview:self.photosView];
    
    self.timeLabel = [UILabel new];
    self.timeLabel.font = kTimeFont;
    self.timeLabel.textColor = kTimeColor;
    [self.contentView addSubview:self.timeLabel];
    
    //添加约束
    self.backView.sd_layout
    .leftSpaceToView(self.contentView,10)
    .rightSpaceToView(self.contentView,10)
    .topSpaceToView(self.contentView,10)
    .bottomSpaceToView(self.contentView,0);
    
    self.namelLabel.sd_layout
    .leftSpaceToView(self.contentView,20)
    .topSpaceToView(self.contentView,20)
    .heightIs(20);
    [self.namelLabel setSingleLineAutoResizeWithMaxWidth:300];
    
    self.topLabel.sd_layout
    .leftSpaceToView(self.namelLabel,10)
    .topEqualToView(self.namelLabel)
    .widthIs(30)
    .heightIs(20);
    
    self.commentTotalBtn.sd_layout
    .topEqualToView(self.namelLabel)
    .rightSpaceToView(self.contentView,20)
    .widthIs(50)
    .heightIs(20);
    
    self.contentLabel.sd_layout
    .leftEqualToView(self.namelLabel)
    .topSpaceToView(self.contentView,50)
    .rightSpaceToView(self.contentView,20)
    .autoHeightRatio(0);
    
    self.timeLabel.sd_layout
    .leftEqualToView(self.namelLabel)
    .topSpaceToView(self.contentLabel,10)
    .widthIs(200)
    .heightIs(20);
    
    [self setupAutoHeightWithBottomViewsArray:@[self.timeLabel] bottomMargin:10];
}

-(void)setPostListModel:(CSPostListModel *)postListModel{
    _postListModel = postListModel;
    self.namelLabel.text = postListModel.creatorName;
    if ([postListModel.top boolValue]) {
        [self.topLabel setHidden:NO];
    }else{
        [self.topLabel setHidden:YES];
    }
    [self.commentTotalBtn setTitle:[NSString stringWithFormat:@"%ld",[postListModel.commentCount integerValue]] forState:UIControlStateNormal];
    self.contentLabel.text = postListModel.content;
    self.timeLabel.text = postListModel.createDate;
}
//重新计算帖子的高度
- (CGFloat)getCellHeight{
    CGFloat cellHeight = 90.0;
    self.contentLabel.font = kContentFont;
    self.contentLabel.text = self.postListModel.content;
    CGSize size = CGSizeMake(self.frame.size.width,2000);
    CGSize labelSize = [self.contentLabel.text sizeWithFont:self.contentLabel.font constrainedToSize:size lineBreakMode:NSLineBreakByWordWrapping];
    cellHeight += labelSize.height;
    return cellHeight;
}
//重新计算帖子详情的高度
- (CGFloat)getPostDetailCellHeight{
    CGFloat cellHeight = 90.0;
    self.contentLabel.font = kContentFont;
    self.contentLabel.text = self.postListModel.content;
    CGSize size = CGSizeMake(self.frame.size.width,2000);
    CGSize labelSize = [self.contentLabel.text sizeWithFont:self.contentLabel.font constrainedToSize:size lineBreakMode:NSLineBreakByWordWrapping];
    cellHeight += labelSize.height;
    if (self.postListModel.images.count > 0) {
        CGFloat rowCount = self.postListModel.images.count % 3 ==0 ? self.postListModel.images.count / 3 : self.postListModel.images.count / 3 + 1;
          CGFloat photoViewHeight = kIMAGE_WIDTH * rowCount + rowCount * kIMAGE_GAP;
        cellHeight += photoViewHeight;
    }
    return cellHeight;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
