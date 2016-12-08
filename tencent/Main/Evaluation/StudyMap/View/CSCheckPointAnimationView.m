//
//  CSCheckPointAnimationView.m
//  tencent
//
//  Created by cyh on 16/8/3.
//  Copyright © 2016年 cyh. All rights reserved.
//

#import "CSCheckPointAnimationView.h"
#import "UIImageView+AFNetworking.h"
#import "UIImageView+WebCache.h"
#import "CSFrameConfig.h"
@interface CSCheckPointAnimationView ()
/**
 *动画视图
 */
@property (nonatomic, strong) UIImageView *animationImageView;
/**
 *timer 定时器
 */
@property (nonatomic, strong) NSTimer *animationTimer;
@end

@implementation CSCheckPointAnimationView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

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
    self.userInteractionEnabled = YES;
    CGRect frame = CGRectMake(0, 0,kCSScreenWidth , kCSScreenHeight);
    self.frame = frame;
    self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.2];
    self.animationImageView = [[UIImageView alloc]initWithFrame:CGRectZero];
    [self addSubview:self.animationImageView];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(hideBackView)];
    [self addGestureRecognizer:tap];
    
    self.animationTimer = [NSTimer scheduledTimerWithTimeInterval:3.0 target:self selector:@selector(hideBackView) userInfo:nil repeats:NO];
}

-(void)hideBackView{
    [self removeFromSuperview];
    [self.animationImageView removeFromSuperview];
    [self.animationTimer invalidate];
    self.animationTimer = nil;
    if (self.pushToNextVC) {
        self.pushToNextVC();
    }
}

-(void)dealloc{
    [self removeFromSuperview];
    [self.animationImageView removeFromSuperview];
    [self.animationTimer invalidate];
    self.animationTimer = nil;
}

-(void)setCartoonString:(NSString *)cartoonString{
    _cartoonString = cartoonString;
    [self.animationImageView sd_setImageWithURL:[NSURL URLWithString:self.cartoonString] placeholderImage:nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
    }];
}

-(void)layoutSubviews{
    [super layoutSubviews];
    self.animationImageView.frame = CGRectMake(self.bounds.size.width/2 - 100, self.bounds.size.height/2 - 100, 200, 200);
}

@end
