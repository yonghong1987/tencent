//
//  CSCheckPointCell.m
//  tencent
//
//  Created by cyh on 16/8/3.
//  Copyright © 2016年 cyh. All rights reserved.
//

#import "CSCheckPointCell.h"
#import "UIImageView+AFNetworking.h"

@implementation CSCheckPointCell


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


- (void)initUI{
    self.checkPointIV = [[UIImageView alloc]initWithFrame:self.bounds];
    [self.contentView addSubview:self.checkPointIV];
    
    self.lockIV = [[UIImageView alloc]initWithFrame:CGRectMake(self.bounds.size.width/2 - 50, self.bounds.size.height/2 - 20, 100, 100)];
    self.lockIV.image = [UIImage imageNamed:@"icon_lock"];
    [self.contentView addSubview:self.lockIV];
}

-(void)setCheckPointModel:(CSCheckPointModel *)checkPointModel{
    _checkPointModel = checkPointModel;
     [self.checkPointIV setImageWithURL:[NSURL URLWithString:self.checkPointModel.backgroundImg] placeholderImage:[UIImage imageNamed:@"loadingtencent-guanqia"]];
}

//-(void)layoutSubviews{
//    [super layoutSubviews];
//    self.checkPointIV.frame = self.bounds;
//    self.lockIV.frame = CGRectMake(self.bounds.size.width/2 - 50, self.bounds.size.height/2 - 50, 100, 100);
//    [self.checkPointIV setImageWithURL:[NSURL URLWithString:self.checkPointModel.backgroundImg] placeholderImage:[UIImage imageNamed:@"loadingtencent-guanqia"]];
//}
@end
