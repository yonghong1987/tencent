//
//  CSTureFalseAllChooseView.h
//  tencent
//
//  Created by cyh on 16/8/23.
//  Copyright © 2016年 cyh. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CSTureFalseAllChooseView : UIView

@property (nonatomic, copy) void (^clickTrueAction)();
@property (nonatomic, copy) void (^clickFalseAction)();
@property (nonatomic, copy) void (^clickAllAction)();
@end
