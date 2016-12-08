//
//  CircleProgressView.h
//  eLearning
//
//  Created by sunon on 14-5-26.
//  Copyright (c) 2014年 sunon. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CircleProgressView : UIView
@property(nonatomic,assign)CGFloat progress;
@property(nonatomic,assign)CGFloat thickness;
@property(nonatomic,strong)UIColor* bottomProgressFillColor;
@property(nonatomic,strong)UIColor* progressFillColor;
@property(nonatomic,assign)BOOL showText;
@property(nonatomic,assign)CGFloat textSize;
@property(nonatomic,strong)UIFont *font;

@end
