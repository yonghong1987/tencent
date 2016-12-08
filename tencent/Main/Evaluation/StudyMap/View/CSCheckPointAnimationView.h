//
//  CSCheckPointAnimationView.h
//  tencent
//
//  Created by cyh on 16/8/3.
//  Copyright © 2016年 cyh. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CSCheckPointAnimationView : UIView
/**
 *动画图片
 */
@property (nonatomic, copy) NSString *cartoonString;
@property (nonatomic, copy) void (^ pushToNextVC)();
@end
