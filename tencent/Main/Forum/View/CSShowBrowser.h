//
//  CSShowBrowser.h
//  eLearning
//
//  Created by sunon on 14-5-30.
//  Copyright (c) 2014年 sunon. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface CSShowBrowser : NSObject<UIScrollViewDelegate>
+(CSShowBrowser *)shareInstance;
//-(void)showBigImage:(UIImage *)img view:(UIView *)v;
-(void)showListBigImage:(NSMutableArray *)imgUrlArray imgVArray:(NSMutableArray *)imgVArray index:(NSInteger)index edit:(BOOL)edit;

@end
