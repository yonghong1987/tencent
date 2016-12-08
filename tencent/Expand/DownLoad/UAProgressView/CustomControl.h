//
//  CustomControl.h
//  eLearning
//
//  Created by chenliang on 15-1-19.
//  Copyright (c) 2015年 sunon. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CSCourseResourceModel.h"
@interface CustomControl : UIControl
-(void)setProgress:(float)progress stopped:(DOWN_TYPE)type;
@end
