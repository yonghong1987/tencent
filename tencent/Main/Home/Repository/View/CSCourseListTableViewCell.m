//
//  CSCourseListTableViewCell.m
//  tencent
//
//  Created by bill on 16/4/27.
//  Copyright © 2016年 cyh. All rights reserved.
//

#import "CSCourseListTableViewCell.h"
#import "UIImageView+AFNetworking.h"

@interface CSCourseListTableViewCell ()

@property (strong, nonatomic) IBOutlet UIImageView *courseThumbnailImg;

@property (strong, nonatomic) IBOutlet UILabel *courseNameLbl;


@property (strong, nonatomic) IBOutlet UILabel *courseDescriptionLbl;


@property (strong, nonatomic) IBOutlet UILabel *viewTotalLbl;


@property (strong, nonatomic) IBOutlet UILabel *commentTotalLbl;

@property (strong, nonatomic) IBOutlet UILabel *supportTotalLbl;

@end

@implementation CSCourseListTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}


- (void)setCourseCell:(CSCourseListModel *)model{
    
    _courseNameLbl.text = model.name;
    
    _courseDescriptionLbl.text = model.describe;
    
    _viewTotalLbl.text = [NSString stringWithFormat:@"%@", model.viewAmount];
    
    _commentTotalLbl.text = [NSString stringWithFormat:@"%@", model.commentCount];
    
    _supportTotalLbl.text = [NSString stringWithFormat:@"%@", model.praiseCount];
    
    [_courseThumbnailImg setImageWithURL:[NSURL URLWithString:model.thumbnail]
                        placeholderImage:[UIImage imageNamed:@"default_image"]];
    
}


- (void)setHotCourseCell:(CSHotCourseListModel *)model{
    
    _courseNameLbl.text = model.name;
    
    _courseDescriptionLbl.text = model.describe;
    
    _viewTotalLbl.text = [NSString stringWithFormat:@"%d",[model.viewAmount integerValue]];
    
    _commentTotalLbl.text = [NSString stringWithFormat:@"%d",[model.commentCount integerValue]];
    
    _supportTotalLbl.text = [NSString stringWithFormat:@"%d",[model.praiseCount integerValue]];
    
    [_courseThumbnailImg setImageWithURL:[NSURL URLWithString:model.thumbnail]
                        placeholderImage:[UIImage imageNamed:@"default_image"]];
}


- (void)setSpecialCell:(CSSpecialListModel *)model{
    _courseNameLbl.text = model.name;
    
    _courseDescriptionLbl.text = model.describe;
    
    _viewTotalLbl.text = [NSString stringWithFormat:@"%ld",[model.viewAmount integerValue]];
    
    _commentTotalLbl.text = [NSString stringWithFormat:@"%ld",[model.commentCount integerValue]];
    
    _supportTotalLbl.text = [NSString stringWithFormat:@"%ld",[model.praiseCount integerValue]];
    
    [_courseThumbnailImg setImageWithURL:[NSURL URLWithString:model.thumbnail]
                        placeholderImage:[UIImage imageNamed:@"catalog_default"]];
}

- (void)setMapCell:(CSStudyMapModel *)model{
    _courseNameLbl.text = model.name;
    _courseDescriptionLbl.text = model.describe;
    
    _viewTotalLbl.text = [NSString stringWithFormat:@"%ld",[model.viewAmount integerValue]];
    
    _commentTotalLbl.text = [NSString stringWithFormat:@"%ld",[model.commentCount integerValue]];
    
    _supportTotalLbl.text = [NSString stringWithFormat:@"%ld",[model.praiseCount integerValue]];
    
    [_courseThumbnailImg setImageWithURL:[NSURL URLWithString:model.img]
                        placeholderImage:[UIImage imageNamed:@"loadingtencent-guanqia"]];
}

@end
