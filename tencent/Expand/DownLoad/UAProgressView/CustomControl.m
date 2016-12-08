//
//  CustomControl.m
//  eLearning
//
//  Created by chenliang on 15-1-19.
//  Copyright (c) 2015年 sunon. All rights reserved.
//

#import "CustomControl.h"
#import "CircleProgressView.h"
#import "KACircleProgressView.h"
#import "CSColorConfig.h"
#import "CSConfig.h"
@interface CustomControl()
@property(nonatomic,strong)UIImageView *imgV;
@property(nonatomic,strong)KACircleProgressView *progressV;

@end
@implementation CustomControl
-(id)initWithFrame:(CGRect)frame
{
    self=[super initWithFrame:frame];
    if (self) {
        self.enabled=YES;
        CGFloat radius=MIN(frame.size.height, frame.size.width);

        _progressV=[[KACircleProgressView alloc] initWithFrame:CGRectMake((frame.size.width-radius)/2.0, (frame.size.height-radius)/2.0, radius, radius)];
        _progressV.trackColor=[UIColor lightGrayColor];
        _progressV.progressColor=kCSThemeColor;
        _progressV.progressWidth=2.0;
        _progressV.userInteractionEnabled=NO;
        [self addSubview:_progressV];
        _imgV=[[UIImageView alloc] init];
        _imgV.userInteractionEnabled=NO;
        [self addSubview:_imgV];
        
    }
    return self;
}

-(void)setProgress:(float)progress stopped:(DOWN_TYPE)type;
{
    NSLog(@"progress is %f,stop is %d",progress,type);
    UIImage *img=ImageNamed(@"course_detail_loading");
    if (type==DOWN_PAUSE) {
        img=ImageNamed(@"course_detail_pause");
    }else if(type==DOWN_LOADING){
        img=ImageNamed(@"course_detail_stopped");
    }else if(type==DOWN_SUCCESS){
        img=ImageNamed(@"icon_delete");
    }
    _imgV.image=img;
    _imgV.frame=CGRectMake(0, 0, img.size.width, img.size.height);
     _progressV.progress=progress;
    _imgV.center=_progressV.center;
    if (type==DOWN_SUCCESS) {
        _progressV.hidden=YES;
    }else{
        _progressV.hidden=NO;
    }
}
@end
