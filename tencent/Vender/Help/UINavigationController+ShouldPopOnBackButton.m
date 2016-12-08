//
//  UINavigationController+ShouldPopOnBackButton.m
//  tencent
//
//  Created by bill on 16/5/12.
//  Copyright © 2016年 cyh. All rights reserved.
//

#import "UINavigationController+ShouldPopOnBackButton.h"
#import "CSMapCourseDetailViewController.h"

@implementation UINavigationController (ShouldPopOnBackButton)

/**
 *  导航栏返回按钮响应事件
 *
 *  @param navigationBar 目标页面导航栏
 *  @param item          目标页面Item
 *
 *  @return 是否用系统的返回按钮事件
 */
- (BOOL)navigationBar:(UINavigationBar *)navigationBar shouldPopItem:(UINavigationItem*)item {
    
    if([self.viewControllers count] < [navigationBar.items count]) {
        return YES;
    }
    
    BOOL needOverrideBackBtnAction = YES;
    UIViewController* vc = [self topViewController];
    if( [vc respondsToSelector:@selector(navigationShouldPopOnBackBtn)] ) {
        needOverrideBackBtnAction = [vc navigationShouldPopOnBackBtn];
    }
    
   
    /**
     *  如果有重写返回按钮响应事件则走重写逻辑；否则走默认逻辑
     */
    if( needOverrideBackBtnAction ) {
        __weak UINavigationController *weakCurrentVC = self;
        dispatch_async(dispatch_get_main_queue(), ^{
 
            /**
             *  地图闯关状态下，不管闯了多少关，都要返回到进入闯关的页面
             */
            if ( [vc isKindOfClass:[CSMapCourseDetailViewController class]] ) {
                NSInteger index = 0;

                for ( ;index < [weakCurrentVC.navigationController.childViewControllers count]; index++ ) {
                    
                    UIViewController *currentVC = [weakCurrentVC.childViewControllers objectAtIndex:index];
                    if ( ![currentVC isKindOfClass:[CSMapCourseDetailViewController class]] ) {
                        index++;
                    }else{
                        break;
                    }
                }
                
                if ( index <= [weakCurrentVC.childViewControllers count] - 1 ) {
                    UIViewController *destionVC = [weakCurrentVC.childViewControllers objectAtIndex:index];
                    [weakCurrentVC popToViewController:destionVC animated:YES];
                }else{
                    [weakCurrentVC popViewControllerAnimated:YES];
                }
            }else{
                [weakCurrentVC popViewControllerAnimated:YES];
            }
        });
 

    } else {
        [self popViewControllerAnimated:YES];
    }
    
    return NO;
}


@end
