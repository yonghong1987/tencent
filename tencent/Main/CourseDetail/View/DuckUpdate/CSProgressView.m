//
//  CSProgressView.m
//  tencent
//
//  Created by duck on 2016/11/25.
//  Copyright © 2016年 cyh. All rights reserved.
//

#import "CSProgressView.h"
#import "KACircleProgressView.h"
#import "UIView+BlockGesture.h"
#import "CSConfig.h"
#import "CSColorConfig.h"
#import "UIView+Frame.h"
@interface CSProgressView ()

@property (strong, nonatomic) KACircleProgressView *progressView;
@property (strong, nonatomic) UIImageView *downLoadImageView;

@end

@implementation CSProgressView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        WS(weakSelf);
        [self addTapActionWithBlock:^(UIGestureRecognizer *gestureRecoginzer) {
            if (weakSelf.touchUpInsideBlcok) {
                weakSelf.touchUpInsideBlcok();
            }
        }];
        
        [self setup];
        
    }
    return self;
}


- (void)setup{
    
    self.progressView = [[KACircleProgressView alloc]initWithFrame:self.bounds];
    self.progressView.trackColor=[UIColor lightGrayColor];
    self.progressView.progressColor= kCSThemeColor;
    self.progressView.progressWidth=2.0;
    
    
    self.downLoadImageView = [[UIImageView alloc]initWithFrame:CGRectMake(7, 7, self.width-14, self.height -14)];
    self.downLoadImageView.userInteractionEnabled = YES;
    self.state = TYDownloadStateNone; //默认状态
    
    [self addSubview:self.downLoadImageView];
    [self addSubview:self.progressView];
    

}

- (void)setProgress:(float)progress{
    _progress = progress;
    self.progressView.progress = progress;

}

- (void)setState:(TYDownloadState)state{
    
    
    switch (state) {
        case TYDownloadStateNone:
        {
            self.downLoadImageView.image = [UIImage imageNamed:@"xiazai"];
            [self setProgressViewColor];
        }
            break;
        case TYDownloadStateReadying:
        {
            self.downLoadImageView.image = [UIImage imageNamed:@"xiazai"];
            [self setProgressViewColor];
        }
            break;
        case TYDownloadStateRunning:
        {
           
           self.downLoadImageView.image = [UIImage imageNamed:@"icon_pause-0"];
            [self setProgressViewColor];
        }
            break;
        case TYDownloadStateSuspended:
        {
           self.downLoadImageView.image = [UIImage imageNamed:@"icon_pause"];
            [self setProgressViewColor];
           
        }
            break;
        case TYDownloadStateCompleted:
        {
           self.downLoadImageView.image = [UIImage imageNamed:@"icon_delete"];
            self.progressView.progressColor=[UIColor clearColor];
            self.progressView.trackColor=[UIColor clearColor];
            
        }
            break;
        case TYDownloadStateFailed:
        {
            self.downLoadImageView.image = [UIImage imageNamed:@"xiazai"];
            [self setProgressViewColor];
        }
            break;
            
        default:
            break;
    }

}
- (void)setProgressViewColor{
    self.progressView.trackColor=[UIColor lightGrayColor];
    self.progressView.progressColor= kCSThemeColor;
}
@end
