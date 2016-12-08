//
//  AppDelegate+Category.h
//  tencent
//
//  Created by sunon002 on 16/4/15.
//  Copyright © 2016年 cyh. All rights reserved.
//

#import "AppDelegate.h"
#import "ITLogin.h"
#import "iConsole.h"
@interface AppDelegate (Category)<ITLoginDelegate>

/*
 **进入首页
 */
- (void)enterHomeVC;
/*
 **进入登录界面
 */
- (void)enterLoginVC;
/*
 **应当进入登录界面、引导页或者首页
 */
- (void)enterWhichVC;
//清除拼接答案的plist文件
- (void)deleteAnswerData;
//ITLogin登陆
- (void)ITLogin;
//哪个环境登录
- (void)whichEnvironmentLogin;
/**
 *腾讯bugly
 */
- (void)setBugly;
@end
