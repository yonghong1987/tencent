//
//  CSCourseDetailTestTableViewCell.m
//  tencent
//
//  Created by bill on 16/5/3.
//  Copyright © 2016年 cyh. All rights reserved.
//

#import "CSCourseDetailTestTableViewCell.h"
#import "CSFrameConfig.h"

@interface CSCourseDetailTestTableViewCell ()

@property (strong, nonatomic) IBOutlet UILabel *testName;

@property (strong, nonatomic) IBOutlet UILabel *testType;

@end

@implementation CSCourseDetailTestTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.precourseBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.precourseBtn.frame = CGRectMake(0, 0,kCSScreenWidth + 50 , self.frame.size.height);
    [self.contentView addSubview:self.precourseBtn];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setResourceCell:(CSCourseResourceModel *)model{
    _testName.text = model.resName;
    
    if ( [model.resCode isEqualToString:@"PRECOURSE"] ) {
        _testType.text = @"课前测验";
    }else if ( [model.resCode isEqualToString:@"AFCOURSE"] ){
        _testType.text = @"课后测验";
    }
    
    
    /**
     *  动态改变Cell的高度
     */
    _testName.numberOfLines = 0;
    CGSize size = CGSizeMake( _testName.frame.size.width, MAXFLOAT);
    size = [_testName.text  boundingRectWithSize:size
                                         options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading
                                      attributes:@{NSFontAttributeName :[UIFont systemFontOfSize:14]}
                                         context:nil].size;
    
    CGRect frame = _testName.frame;
    frame.size.height = size.height;
    _testName.frame = frame;
}

@end
