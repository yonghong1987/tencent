//
//  CSRepositoryCollectionViewCell.m
//  tencent
//
//  Created by bill on 16/4/27.
//  Copyright © 2016年 cyh. All rights reserved.
//

#import "CSRepositoryCollectionViewCell.h"
#import "UIImageView+AFNetworking.h"
#import "CSFrameConfig.h"

@interface CSRepositoryCollectionViewCell ()
@property (nonatomic, strong) UIImageView *backIV;
@property (strong, nonatomic)  UIImageView *categoryImg;

@property (strong, nonatomic)  UILabel *categoryContent;



@end

@implementation CSRepositoryCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.backIV = [UIImageView new];
    self.backIV.image = [UIImage imageNamed:@"course_fine_bg"];
    [self.contentView addSubview:self.backIV];
    
    self.categoryImg = [UIImageView new];
    self.categoryImg.image = [UIImage imageNamed:@"catalog_default"];
    [self.contentView addSubview:self.categoryImg];
    
    self.categoryContent = [UILabel new];
    self.categoryContent.font = [UIFont systemFontOfSize:15.0];
    self.categoryContent.textAlignment = NSTextAlignmentCenter;
    [self.contentView addSubview:self.categoryContent];
    
    self.unreadMarkImg = [[UIImageView alloc]init];
    self.unreadMarkImg.backgroundColor = [UIColor redColor];
    [self.contentView addSubview:self.unreadMarkImg];
}

-(void)setModel:(CSRepositoryModel *)model{
    _model = model;
    self.backIV.frame = CGRectMake(2, 2, self.frame.size.width - 4, self.frame.size.width - 4 + 20);
    self.selectedBtn.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"course_fine_bg"]];
    self.categoryImg.frame = CGRectMake(self.frame.size.width / 2 - 40, self.frame.size.width / 2 - 40, 80, 80);
    self.categoryImg.layer.cornerRadius = 40.0;
    self.categoryImg.layer.masksToBounds = YES;
    self.categoryContent.frame = CGRectMake(0, self.frame.size.height - 35, self.frame.size.width, 20);
    self.unreadMarkImg.frame = CGRectMake(self.frame.size.width - 30, 30, 10, 10);
    self.unreadMarkImg.layer.cornerRadius = 5.0;
    self.unreadMarkImg.layer.masksToBounds = YES;
    _categoryContent.text = self.model.name;
    
    [_categoryImg setImageWithURL:[NSURL URLWithString:self.model.img]
                 placeholderImage:[UIImage imageNamed:@"default_image"]];
    
    [_unreadMarkImg setHidden:([self.model.isUpdate integerValue] == 0)];
}


@end
