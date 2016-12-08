//
//  CircleProgressView.m
//  eLearning
//
//  Created by sunon on 14-5-26.
//  Copyright (c) 2014年 sunon. All rights reserved.
//

#import "CircleProgressView.h"
@interface CircleProgressView()
@property(nonatomic,strong)UILabel* textLb;
@end
@implementation CircleProgressView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initialization];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if(self) {
        [self initialization];
    }
    return self;
}

- (void)dealloc
{

}
- (void)initialization
{
    self.progress=0.0;
    self.thickness=10.0;
    self.backgroundColor=[UIColor clearColor];
    self.bottomProgressFillColor=[UIColor lightGrayColor];
    _textLb=[[UILabel alloc] init];
    _textLb.backgroundColor=[UIColor clearColor];
    _textLb.textColor=[UIColor blackColor];
    _textLb.textAlignment=NSTextAlignmentCenter;
    _textLb.adjustsFontSizeToFitWidth=YES;
    _textLb.userInteractionEnabled=NO;
    _textLb.baselineAdjustment=UIBaselineAdjustmentAlignCenters;
    [self addSubview:_textLb];
}


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    CGSize size=self.bounds.size;
    // Drawing code
    CGContextRef context=UIGraphicsGetCurrentContext();
    CGContextSetStrokeColorWithColor(context, _bottomProgressFillColor.CGColor);
    CGContextSetLineWidth(context,_thickness+1.0);
    CGContextAddArc(context, size.width/2.0, size.height/2.0,MIN(size.width/2.0, size.height/2.0)-_thickness-1.0, -M_PI_2, 2*M_PI-M_PI_2, 0);
    CGContextDrawPath(context, kCGPathStroke);
    
    CGContextSetStrokeColorWithColor(context,_progressFillColor.CGColor);
    CGContextSetLineWidth(context,_thickness);
    CGContextAddArc(context, size.width/2.0,size.height/2.0,MIN(size.width/2.0, size.height/2.0)-_thickness-1.0,-M_PI_2,2*M_PI*_progress-M_PI_2, 0);
    CGContextDrawPath(context, kCGPathStroke);
    if (_showText) {
        CGFloat contentWidth=MIN(size.width/2.0, size.height/2.0)-_thickness-2.0;
        CGRect textFrame=_textLb.frame;
        textFrame.size=CGSizeMake(contentWidth*2, 20.0);
        _textLb.frame=textFrame;
        _textLb.center=CGPointMake(size.width/2.0, size.height/2.0);
        NSString* contentStr=[NSString stringWithFormat:@"%.0f%@",_progress*100,@"%"];
        _textLb.text=contentStr;
    }else{
        _textLb.hidden=YES;
    }
}

-(void)setProgress:(CGFloat)progress
{
    _progress=progress;
    [self setNeedsDisplay];
}
-(void)setBottomProgressFillColor:(UIColor *)bottomProgressFillColor
{
    _bottomProgressFillColor=bottomProgressFillColor;
    [self setNeedsDisplay];
}
-(void)setThickness:(CGFloat)thickness
{
    _thickness=thickness;
    [self setNeedsDisplay];
}
-(void)setTextSize:(CGFloat)textSize
{
    _textLb.font = [UIFont systemFontOfSize:textSize];
    [self setNeedsDisplay];
}
-(void)setFont:(UIFont *)font
{
    _textLb.font = font;
    [self setNeedsDisplay];
}

@end
