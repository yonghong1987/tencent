//
//  KACircleProgressView.h
//  eLearning
//
//  Created by chenliang on 15-1-20.
//  Copyright (c) 2015年 sunon. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface KACircleProgressView : UIView
{
    CAShapeLayer *_trackLayer;
    UIBezierPath *_trackPath;
    CAShapeLayer *_progressLayer;
    UIBezierPath *_progressPath;
}
@property (nonatomic, strong) UIColor *trackColor;
@property (nonatomic, strong) UIColor *progressColor;
@property (nonatomic) float progress;//0~1之间的数
@property (nonatomic) float progressWidth;
@end
