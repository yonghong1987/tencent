//
//  CSHomeCollectionCell.m
//  tencent
//
//  Created by sunon002 on 16/4/27.
//  Copyright © 2016年 cyh. All rights reserved.
//

#import "CSHomeCollectionCell.h"
#import "CSFontConfig.h"
#import "UIView+SDAutoLayout.h"
#import "CSFrameConfig.h"
@implementation CSHomeCollectionCell

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
    self.backgroundColor = [[UIColor redColor]colorWithAlphaComponent:0.2];
    self.itemIcon = [[UIImageView alloc]init];
    [self.contentView addSubview:self.itemIcon];
    
    self.itemTitleLabel = [[UILabel alloc]init];
    self.itemTitleLabel.textColor = [UIColor whiteColor];
    self.itemTitleLabel.font = kContentFont;
    self.itemTitleLabel.textAlignment = NSTextAlignmentCenter;
    [self.contentView addSubview:self.itemTitleLabel];

    self.itemIcon.sd_layout
    .topSpaceToView(self.contentView,[self getVarHeight:13])
    .centerXEqualToView(self.contentView)
    .widthIs([self getVarHeight:35])
    .heightIs([self getVarHeight:35]);
    
   self.itemTitleLabel.sd_layout
    .topSpaceToView(self.itemIcon,[self getVarHeight:10])
    .centerXEqualToView(self.contentView)
    .widthIs(100)
    .heightIs([self getVarHeight:20]);
    
}

- (CGFloat)getVarHeight:(CGFloat)height{
    CGFloat hei = height * kCSScreenWidth / 320;
    return hei;
}
@end
