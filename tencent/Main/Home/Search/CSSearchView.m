//
//  CSSearchView.m
//  tencent
//
//  Created by cyh on 16/10/27.
//  Copyright © 2016年 cyh. All rights reserved.
//

#import "CSSearchView.h"

@implementation CSSearchView

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
    self.searchBar = [[UISearchBar alloc]initWithFrame:CGRectMake(0, 20, self.bounds.size.width, 44)];
    self.searchBar.delegate = self;
    self.searchBar.placeholder = @"请输入关键字";
//    self.searchBar.backgroundColor = [UIColor clearColor];
//    self.searchBar.layer.cornerRadius = 4;
//    self.searchBar.layer.masksToBounds = YES;
//    [self.searchBar setSearchFieldBackgroundImage:[UIImage imageNamed:@"base"] forState:UIControlStateNormal];
//    self.searchBar.backgroundImage  = [UIImage imageNamed:@"search_mini"];
    [self addSubview:self.searchBar];
}

-(void)layoutSubviews{
    [super layoutSubviews];
//    self.searchBar.frame = CGRectMake(0, 20, self.bounds.size.width - 40, 30);
}
@end
