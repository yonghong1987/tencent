//
//  JQNavTabBarTagCell.m
//  JQNavTabBarController
//
//  Created by Evan on 16/4/25.
//  Copyright © 2016年 Evan. All rights reserved.
//

#import "JQNavTabBarTagCell.h"

@implementation JQNavTabBarTagCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.lineIV.backgroundColor = [[UIColor grayColor]colorWithAlphaComponent:0.4];
}


-(void)layoutSubviews{
    [super layoutSubviews];
    self.lineIV.frame = CGRectMake(self.frame.size.width-1, 0, 1, self.frame.size.height);
}
@end
