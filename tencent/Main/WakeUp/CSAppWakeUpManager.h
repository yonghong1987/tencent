//
//  CSAppWakeUpManager.h
//  tencent
//
//  Created by cyh on 16/10/31.
//  Copyright © 2016年 cyh. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface CSAppWakeUpManager : NSObject
/**
 *  父视图
 */
@property (nonatomic, strong) UIViewController *controlJump;
-(void)controllerMediator:(NSDictionary *)dicParam;
@end
