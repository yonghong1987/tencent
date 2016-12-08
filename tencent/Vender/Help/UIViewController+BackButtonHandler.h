//
//  UIViewController+BackButtonHandler.h
//  tencent
//
//  Created by bill on 16/5/12.
//  Copyright © 2016年 cyh. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol BackButtonHandlerProtocol <NSObject>

@optional
- (BOOL)navigationShouldPopOnBackBtn;

@end

@interface UIViewController (BackButtonHandler)<BackButtonHandlerProtocol>

@end
