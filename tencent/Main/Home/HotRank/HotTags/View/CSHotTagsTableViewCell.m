//
//  CSHotTagsTableViewCell.m
//  tencent
//
//  Created by bill on 16/4/28.
//  Copyright © 2016年 cyh. All rights reserved.
//

#import "CSHotTagsTableViewCell.h"
#import "UIImageView+AFNetworking.h"


@interface CSHotTagsTableViewCell ()

@property (strong, nonatomic) IBOutlet UIImageView *tagsCoverImg;

@property (strong, nonatomic) IBOutlet UILabel *tagsContentLbl;

@property (strong, nonatomic) IBOutlet UILabel *tagsViewAmountLbl;

@end

@implementation CSHotTagsTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setCellInfo:(CSHotTagsListModel *)model{

    [_tagsCoverImg setImageWithURL:[NSURL URLWithString:model.img]
                  placeholderImage:[UIImage imageNamed:@"default_image"]];
    _tagsContentLbl.text = [NSString stringWithFormat:@"课程: %d",[model.activityNum integerValue]];
    NSNumberFormatter *number = [[NSNumberFormatter alloc] init];
    _tagsViewAmountLbl.text = [number stringFromNumber:model.viewAmount];
}

@end
