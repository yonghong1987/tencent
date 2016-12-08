//
//  CSTitleListCell.m
//  tencent
//
//  Created by cyh on 16/8/23.
//  Copyright © 2016年 cyh. All rights reserved.
//

#import "CSTitleListCell.h"
#import "CSColorConfig.h"
@interface CSTitleListCell ()
@property (nonatomic, strong) UILabel *titleLabel;
@end

@implementation CSTitleListCell


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
    self.titleLabel = [[UILabel alloc]initWithFrame:self.bounds];
    self.titleLabel.textColor = [UIColor whiteColor];
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    [self.contentView addSubview:self.titleLabel];
}

-(void)setTitleListModel:(CSTitleListModel *)titleListModel{
    _titleListModel = titleListModel;
    self.titleLabel.text =[NSString stringWithFormat:@"%ld",self.indexPath.row + 1] ;
    if ([titleListModel.isCorrect integerValue] > 0) {
        self.backgroundColor = kCSThemeColor;
    }else{
        self.backgroundColor = [UIColor grayColor];
    }
}

@end
