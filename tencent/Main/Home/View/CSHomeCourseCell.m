//
//  CSHomeCourseCell.m
//  tencent
//
//  Created by sunon002 on 16/4/27.
//  Copyright © 2016年 cyh. All rights reserved.
//

#import "CSHomeCourseCell.h"
#import "CSColorConfig.h"
@implementation CSHomeCourseCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])
    {
        [self initUI];
    }
    return self;
}

-(void)initUI{
    self.titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, self.frame.size.width-20, self.frame.size.height)];
    self.titleLabel.backgroundColor = [UIColor whiteColor];
    [self.contentView addSubview:self.titleLabel];
    self.iconIV = [[UIImageView alloc]initWithFrame:CGRectMake(10, self.frame.size.height - 1, self.frame.size.width - 20, 1)];
    self.iconIV.backgroundColor = [[UIColor lightGrayColor]colorWithAlphaComponent:0.05];
    [self.contentView addSubview:self.iconIV];
}

-(void)layoutSubviews{
    [super layoutSubviews];
    self.titleLabel.frame = CGRectMake(10, 0, self.frame.size.width-20, self.frame.size.height);
    self.iconIV.frame = CGRectMake(10, self.frame.size.height - 1, self.frame.size.width - 20, 1);
}
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
