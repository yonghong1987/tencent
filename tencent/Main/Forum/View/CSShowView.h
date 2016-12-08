//
//  CSShowView.h
//  eLearning
//
//  Created by sunon on 14-5-15.
//  Copyright (c) 2014年 sunon. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol CSShowViewDelegate<NSObject>

@optional
-(void)resginFirstResponse;
-(void)removeImg:(UIImage *)img;

@end

@interface CSShowView : UIView
@property(nonatomic,assign)id<CSShowViewDelegate> delegate;
-(void)addImage:(UIImage*)img;
@end
