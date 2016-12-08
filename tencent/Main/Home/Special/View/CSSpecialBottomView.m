//
//  CSSpecialBottomView.m
//  tencent
//
//  Created by admin on 16/5/6.
//  Copyright © 2016年 cyh. All rights reserved.
//

#import "CSSpecialBottomView.h"
#import "CSFrameConfig.h"
#import "CSConfig.h"
@implementation CSSpecialBottomView

-(instancetype)init{
    if (self = [super init]) {
        self.backgroundColor = [UIColor whiteColor];

    }
    return self;
}

-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor whiteColor];

    }
    return self;
}


-(void)setButtonViewType:(CSBottomViewType)buttonViewType{
    _buttonViewType = buttonViewType;
    NSInteger column = 0;
    if (buttonViewType == CSSpecialDetailBottomView || buttonViewType == CSMapCourseDetailBottomView) {
        column = 4;
        CGFloat buttonWith = kCSScreenWidth / column;
        for (int i = 0; i < column; i ++) {
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            button.frame = CGRectMake(i * buttonWith, 0, buttonWith, self.frame.size.height);
            button.tag = 1000 + i;
            if (i == 0) {
                [button setImage:[UIImage imageNamed:@"icon_comments"] forState:UIControlStateNormal];
                self.commentBtn = button;
            }else if (i == 1){
                [button setImage:[UIImage imageNamed:@"icon_share"] forState:UIControlStateNormal];
                self.shareBtn = button;
            }else if (i == 2){
                [button setImage:[UIImage imageNamed:@"icon_dianzan"] forState:UIControlStateNormal];
                self.praiseBtn = button;
            }else if (i == 3){
                [button setImage:[UIImage imageNamed:@"icon_shoucang"] forState:UIControlStateNormal];
                self.collectBtn = button;
            }
            
            [button addTarget:self action:@selector(clickAction:) forControlEvents:UIControlEventTouchUpInside];
            [self addSubview:button];
        }
    }else if (buttonViewType == CSNormalCourseDetailBottomView){
        column = 5;
        CGFloat buttonWith = kCSScreenWidth / column;
        for (int i = 0; i < column; i ++) {
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            button.frame = CGRectMake(i * buttonWith, 0, buttonWith, self.frame.size.height);
            button.tag = 10000 + i;
            if (i == 0) {
                [button setImage:[UIImage imageNamed:@"icon_yanshenyuedu"] forState:UIControlStateNormal];
                self.readBtn = button;
            }else if (i == 1){
                [button setImage:[UIImage imageNamed:@"icon_comments"] forState:UIControlStateNormal];
                self.commentBtn = button;
            }else if (i == 2){
                [button setImage:[UIImage imageNamed:@"icon_share"] forState:UIControlStateNormal];
                self.shareBtn = button;
            }else if (i == 3){
                [button setImage:[UIImage imageNamed:@"icon_dianzan"] forState:UIControlStateNormal];
                self.praiseBtn = button;
            }else if (i ==4){
                [button setImage:[UIImage imageNamed:@"icon_shoucang"] forState:UIControlStateNormal];
                self.collectBtn = button;;
            }
            [button addTarget:self action:@selector(studyClickAction:) forControlEvents:UIControlEventTouchUpInside];
            [self addSubview:button];
        }
    }
}

-(void)setSpecialModel:(CSSpecialListModel *)specialModel{
    _specialModel = specialModel;
    if ([specialModel.praiseId integerValue] > 0 ) {
        [self.praiseBtn setImage:[UIImage imageNamed:@"icon_yidianzan"] forState:UIControlStateNormal];
    }else{
    [self.praiseBtn setImage:[UIImage imageNamed:@"icon_dianzan"] forState:UIControlStateNormal];
    }
    
    if ([specialModel.collectId integerValue] > 0 ) {
        [self.collectBtn setImage:[UIImage imageNamed:@"icon_yishoucang"] forState:UIControlStateNormal];
    }else{
        [self.collectBtn setImage:[UIImage imageNamed:@"icon_shoucang"] forState:UIControlStateNormal];
    }
}


-(void)setDetailModel:(CSCourseDetailModel *)detailModel{
    _detailModel = detailModel;
    if ([detailModel.praiseId integerValue] > 0 ) {
        [self.praiseBtn setImage:[UIImage imageNamed:@"icon_yidianzan"] forState:UIControlStateNormal];
    }else{
        [self.praiseBtn setImage:[UIImage imageNamed:@"icon_dianzan"] forState:UIControlStateNormal];
    }
    
    if ([detailModel.collectId integerValue] > 0 ) {
        [self.collectBtn setImage:[UIImage imageNamed:@"icon_yishoucang"] forState:UIControlStateNormal];
    }else{
        [self.collectBtn setImage:[UIImage imageNamed:@"icon_shoucang"] forState:UIControlStateNormal];
    }

}
- (void)clickAction:(UIButton *)sender{
    UIButton *btn = (UIButton *)sender;
    switch (btn.tag - 1000) {
        case 0:
            if (self.commentActionBlock) {
                self.commentActionBlock();
            }
            break;
        case 1:
            if (self.shareActionBlock) {
                self.shareActionBlock();
            }
            break;
        case 2:
            if (self.praiseActionBlock) {
                self.praiseActionBlock();
            }
            break;
        case 3:
            if (self.collectActionBlock) {
                self.collectActionBlock();
            }
            break;
        default:
            break;
    }
}

-(void)studyClickAction:(UIButton *)sender{
    UIButton *btn = (UIButton *)sender;
    switch (btn.tag - 10000) {
        case 0:
            if (self.redActionBlock) {
                self.redActionBlock();
            }
            break;
        case 1:
            if (self.commentActionBlock) {
                self.commentActionBlock();
            }
            break;
        case 2:
            if (self.shareActionBlock) {
                self.shareActionBlock();
            }
            break;
        case 3:
            if (self.praiseActionBlock) {
                self.praiseActionBlock();
            }
            break;
        case 4:
            if (self.collectActionBlock) {
                self.collectActionBlock();
            }
            break;
        default:
            break;
    }

}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
