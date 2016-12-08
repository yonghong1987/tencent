//
//  CSCourseDetailVideoTableViewCell.m
//  tencent
//
//  Created by bill on 16/5/3.
//  Copyright © 2016年 cyh. All rights reserved.
//

#import "CSCourseDetailVideoTableViewCell.h"
#import "UIView+SDAutoLayout.h"
#import "CSFrameConfig.h"
#import "CSColorConfig.h"

#import "CSDownLoadResourceModel+CoreDataProperties.h"

#import "CSDownLoadCourseModel+CoreDataProperties.h"
#import "AppDelegate.h"
#import "MBProgressHUD+SMHUD.h"

#import "CSConfig.h"
#import "CSProgressView.h"

@interface CSCourseDetailVideoTableViewCell ()

@property (strong, nonatomic) UILabel *courseName;

@property (strong, nonatomic) UIButton *viewAmountBtn;

@property (strong, nonatomic) UIImageView *seplineImg;

@property (strong, nonatomic) NSString *resourceUrl;

@property (strong ,nonatomic) CSProgressView * progresView;
@end

@implementation CSCourseDetailVideoTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.precourseBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.precourseBtn.frame = CGRectMake(0, 0,kCSScreenWidth + 50 , self.frame.size.height);
    [self.contentView addSubview:self.precourseBtn];
    
    [self initUI];
    
}

-(void)initUI{
    self.courseName = [[UILabel alloc]initWithFrame:CGRectMake(10, 10, kCSScreenWidth-100, 20)];
    self.courseName.font = [UIFont systemFontOfSize:13.0];
    [self.contentView addSubview:self.courseName];
    
    self.playIV = [UIImageView new];
    self.playIV.frame = CGRectMake(kCSScreenWidth - 100, 10, 30, 30);
    self.playIV.image = [UIImage imageNamed:@"icon_video"];
    [self.contentView addSubview:self.playIV];
    
    self.progresView = [[CSProgressView alloc]initWithFrame:CGRectMake(kCSScreenWidth - 60, 10, 30, 30)];
    WS(weakSefl);
    [self.progresView  setTouchUpInsideBlcok:^{
        [weakSefl download:nil];
    }];
    [self.contentView addSubview:self.progresView];
    
    self.viewAmountBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.viewAmountBtn.frame = CGRectMake(10, 30, 30, 30);
    [self.viewAmountBtn setImage:[UIImage imageNamed:@"icon_liulanshu"] forState:UIControlStateNormal];
    [self.viewAmountBtn setImageEdgeInsets:UIEdgeInsetsMake(0, -10, 0, 0)];
    [self.viewAmountBtn setTitleColor:kTimeColor forState:UIControlStateNormal];
    self.viewAmountBtn.titleLabel.font = [UIFont systemFontOfSize:11.0];
    [self.contentView addSubview:self.viewAmountBtn];

}
- (void)setState:(TYDownloadState)state{
    _state = state;
    self.progresView.state = state;
    if (state == TYDownloadStateNone) {
        self.progress = 0;
    }
}

- (void)setProgress:(float)progress{
    self.progresView.progress = progress;
    
}


- (void)dealloc{
     [[NSNotificationCenter defaultCenter] removeObserver:self];
}


-(void)setResourceModel:(CSCourseResourceModel *)resourceModel{
    _resourceModel = resourceModel;
    _courseName.text = resourceModel.resName;
    [_viewAmountBtn setTitle:[resourceModel.viewAmount stringValue] forState:UIControlStateNormal];
    _resourceUrl = resourceModel.rsUrl;

    if (self.studyFlag == 0) {
        [self.progresView setHidden:YES];
    }else{
        if ([resourceModel.allowDown integerValue] == 0) {
            [self.progresView setHidden:YES];
        }
    }
}

-(void)download:(UIButton *)sender{
    if (_delegate&&[_delegate respondsToSelector:@selector(downResource:cell:)]) {
        [_delegate downResource:self.resourceModel cell:self];
    }
}
@end
