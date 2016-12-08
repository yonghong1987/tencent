//
//  CSCourseDetailArticleTableViewCell.m
//  tencent
//
//  Created by bill on 16/5/3.
//  Copyright © 2016年 cyh. All rights reserved.
//

#import "CSCourseDetailArticleTableViewCell.h"
#import "CSFrameConfig.h"
@interface CSCourseDetailArticleTableViewCell ()

@property (strong, nonatomic) IBOutlet UILabel *courseName;
@property (strong, nonatomic) IBOutlet UILabel *viewAmount;

@end

@implementation CSCourseDetailArticleTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.redBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.redBtn.frame = CGRectMake(0, 0,kCSScreenWidth + 50 , self.frame.size.height);
    [self.contentView addSubview:self.redBtn];

    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setResourceCell:(CSCourseResourceModel *)model{

    _courseName.text = model.resName;
    _viewAmount.text = [model.viewAmount stringValue];
    
    
    /**
     *  动态改变Cell的高度
     */
    _courseName.numberOfLines = 0;
    CGSize size = CGSizeMake( _courseName.frame.size.width, MAXFLOAT);
    size = [_courseName.text  boundingRectWithSize:size
                                           options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading
                                        attributes:@{NSFontAttributeName :[UIFont systemFontOfSize:14]}
                                           context:nil].size;
    
    CGRect frame = _courseName.frame;
    frame.size.height = size.height;
    _courseName.frame = frame;

 
}

@end
