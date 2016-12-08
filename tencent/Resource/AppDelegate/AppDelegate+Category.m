//
//  AppDelegate+Category.m
//  tencent
//
//  Created by sunon002 on 16/4/15.
//  Copyright © 2016年 cyh. All rights reserved.
//

#import "AppDelegate+Category.h"
#import "CSBaseNavigationController.h"
#import "CSMyViewController.h"
#import "CSForumViewController.h"
#import "CSEvaluationViewController.h"
#import "CSHomeViewController.h"
#import "CSLoginViewController.h"
#import "CSUserDefaults.h"
#import "YTKNetworkConfig.h"
#import "CSUrl.h"
#import "YTKUrlArgumentsFilter.h"
#import "CSTabBarController.h"
#import "CSGlobalMacro.h"
#import "CSGuideViewController.h"
#import "CSConfig.h"
#import "CSHttpRequestManager.h"
#import "CSAppWakeUpManager.h"
#import <Bugly/Bugly.h>
#import "CSUserDefaults.h"

//哪个环境登录（测试或者腾讯正式环境）,YES为正式环境，NO为测试环境
BOOL isTencent = NO;
#define Bugly_Appid @"fa52a09844"
#define Bugly_Appkey @"7e0bf1aa-e783-4140-a290-6f7a5f16f1ee"
@implementation AppDelegate (Category)

/*
 **进入首页
 */
- (void)enterHomeVC{
    CSHomeViewController *home = [[CSHomeViewController alloc]init];
    CSBaseNavigationController *homeNavi = [[CSBaseNavigationController alloc]initWithRootViewController:home];
    homeNavi.tabBarItem.imageInsets = UIEdgeInsetsMake(5, 0, -5, 0);
    
    CSEvaluationViewController *evalution = [[CSEvaluationViewController alloc]init];
    CSBaseNavigationController *evalutionNavi = [[CSBaseNavigationController alloc]initWithRootViewController:evalution];
    evalutionNavi.tabBarItem.imageInsets = UIEdgeInsetsMake(5, 0, -5, 0);
    
    CSForumViewController *forum = [[CSForumViewController alloc]init];
    CSBaseNavigationController *forumNavi = [[CSBaseNavigationController alloc]initWithRootViewController:forum];
    forumNavi.tabBarItem.imageInsets = UIEdgeInsetsMake(5, 0, -5, 0);
    
    CSMyViewController *my = [[CSMyViewController alloc]init];
    CSBaseNavigationController *myNavi = [[CSBaseNavigationController alloc]initWithRootViewController:my];
     myNavi.tabBarItem.imageInsets = UIEdgeInsetsMake(5, 0, -5, 0);
    
    CSTabBarController *tabBarController = [[CSTabBarController alloc]init];
    tabBarController.viewControllers = @[homeNavi,evalutionNavi,forumNavi,myNavi];
    [tabBarController setSelectedIndex:0];
    
    UITabBarItem *homeTab = [tabBarController.tabBar.items objectAtIndex:0];
    homeTab.image = [UIImage imageNamed:@"course2"];
    homeTab.selectedImage = [[UIImage imageNamed:@"course_green2"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    UITabBarItem *evalutionTab = [tabBarController.tabBar.items objectAtIndex:1];
    evalutionTab.image = [UIImage imageNamed:@"test2"];
    evalutionTab.selectedImage = [[UIImage imageNamed:@"test_green2"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    UITabBarItem *forumTab = [tabBarController.tabBar.items objectAtIndex:2];
    forumTab.image = [UIImage imageNamed:@"forum2"];
    forumTab.selectedImage = [[UIImage imageNamed:@"forum_green2"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    UITabBarItem *myTab = [tabBarController.tabBar.items objectAtIndex:3];
    myTab.image = [UIImage imageNamed:@"user2"];
    myTab.selectedImage = [[UIImage imageNamed:@"user_green2"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    self.window.rootViewController = tabBarController;

}

//ITLogin登陆
- (void)ITLogin{
    // init ITLogin SDK
    [[ITLogin sharedInstance] startWithAppKey:kITLoginAppkey AppId:kITLoginAppId];
    [(ITLogin*)[ITLogin sharedInstance] setDelegate:self];
    
    //自定义logo和titlez
//    [[ITLogin sharedInstance] changeTitle:@"Tencent"];
//    [[ITLogin sharedInstance] changeLogo:[UIImage imageNamed:@"iconlogin"]];
    
    //关闭outlook白名单登录
//    [[ITLogin sharedInstance] disableOutlookLogin];
}

#pragma mark -
#pragma mark ITLoginDelegate
//每次启动或唤醒，或程序运行15分钟，sdk会自动验证登录态（validateLogin），并将结果回调
- (void)didValidateLoginSuccess
{
    [iConsole info:@"didValidateLoginSuccess，Ckey: %@ Version:%@",[[ITLogin sharedInstance] getLoginInfo].credentialkey,[[ITLogin sharedInstance] getLoginInfo].version];
//    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"验证登录" message:@"验证登录成功" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
//    [alert show];
    [self getUserInfo];
    
}

- (void)didValidateLoginFailWithError:(ITLoginError*)error
{
    //当error.errorCode为非0时（非网络错误情况），ITLogin会主动唤起登录页面，这里不需要再进行提示或退出登录操作
    [iConsole info:@"didValidateLoginFailWithError msg: %@, httpCode: %d, statusID: %d",error.errorMsg,error.httpStatusCode,error.errorCode];
    //如果是网络错误的情况
    if(error.errorCode==0)
    {
        //这里可以根据业务自身情况处理网络错误情况
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"验证登录" message:@"验证登录失败，网络错误" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
    }
    
}

//退出登录结果回调
- (void)didFinishLogout
{
    //ITLogin会主动唤起登录页面
    [iConsole info:@"didFinishLogout"];
}

//token登录页的结果回调
- (void)didTokenLoginSuccess
{
    //ITLogin会主动推出登录页面
    [iConsole info:@"didTokenLoginSuccess，Ckey: %@ Version:%@",[[ITLogin sharedInstance] getLoginInfo].credentialkey,[[ITLogin sharedInstance] getLoginInfo].version];
//    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"token登录" message:@"token登录成功" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
//    [alert show];
    [self getUserInfo];
    
}

- (void)didTokenLoginFailWithError:(ITLoginError*)error
{
    [iConsole info:@"didTokenLoginFailWithError msg: %@, httpCode: %d, statusID: %d",error.errorMsg,error.httpStatusCode,error.errorCode];
    if (isTencent == YES) {
        if (error.errorCode !=0) {
            [[ITLogin sharedInstance] logout];
        }
    }
    
    [self getUserInfo];
}

//自动登陆
-(void)validLogin{
[[ITLogin sharedInstance] validateLogin];
}
//验证登陆
-(void)getUserInfo{
 ITLoginInfo* loginInfo=[[ITLogin sharedInstance] getLoginInfo];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setValue:@"ITLoginV1.0" forKey:@"xProtocolVersion"];
     [params setValue:kAppKey forKey:@"xSystemKey"];
     [params setValue:@" " forKey:@"xMdmSessionId"];
     [params setValue:loginInfo.credentialkey forKey:@"credentialkey"];
     [params setValue:@" " forKey:@"xDeviceOs"];
     [params setValue:@" " forKey:@"xDeviceIp"];
     [params setValue:@" " forKey:@"xDeviceMacAddress"];
     [params setValue:@"ios" forKey:@"xDevicePlatform"];
     [params setValue:@" " forKey:@"xDeviceSerialNumber"];
     [params setValue:@" " forKey:@"xDeviceImei"];
     [params setValue:[UIDevice currentDevice].identifierForVendor.UUIDString forKey:@"xDeviceUuid"];
     [params setValue:@" " forKey:@"xLongiTude"];
     [params setValue:@" " forKey:@"xLatiTude"];
    [params setValue:@" " forKey:@"identification"];
    [params setValue:[UIDevice currentDevice].systemName forKey:@"system"];
    [params setValue:[UIDevice currentDevice].systemVersion forKey:@"version"];
    [params setValue:[UIDevice currentDevice].model forKey:@"models"];
    [params setValue:@" " forKey:@"brand"];
    
    [[CSHttpRequestManager shareManager] getDataFromNetWork:@"" parameters:params success:^(CSHttpRequestManager *manager, id model) {
        
    } failture:^(CSHttpRequestManager *manager, id nodel) {
        
    }];
}


/*
 **进入登录界面
 */
- (void)enterLoginVC{
    if (isTencent == NO) {
        CSLoginViewController *loginVC = [[CSLoginViewController alloc]initWithNibName:@"CSLoginViewController" bundle:nil];
        self.window.rootViewController = [[UINavigationController alloc]initWithRootViewController:loginVC];
    }else{
        [self ITLogin];
        [self enterHomeVC];
        [self validLogin];
    }
   
}

/*
 ***应当进入登录界面、引导页或者首页 (测试环境)
 */

- (void)enterWhichVC{
    [self deleteAnswerData];
    YTKNetworkConfig *config = [YTKNetworkConfig sharedInstance];
    config.baseUrl = BASE_URL_STRING;
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    BOOL isFirst = [ud boolForKey:kFirstLaunch];
    BOOL isLoginSuccess = [ud boolForKey:kIsLoginSuccess];
        if (isFirst == true) {
            if (isLoginSuccess == true) {
                NSString *token = [[CSUserDefaults shareUserDefault] getUserToken];
                YTKUrlArgumentsFilter *tokenFilter = [YTKUrlArgumentsFilter filterWithArguments:@{@"token": token}];
                [config addUrlFilter:tokenFilter];
                [self enterHomeVC];
            }else{
            [self enterLoginVC];
            }
        }else{
            CSGuideViewController *guide = [[CSGuideViewController alloc]init];
            self.window.rootViewController = [[UINavigationController alloc]initWithRootViewController:guide];
        }
}

/*
 ***应当进入登录界面、引导页或者首页 (正式环境)
 */
- (void)tencentEnterWhichVC{
    [self deleteAnswerData];
    YTKNetworkConfig *config = [YTKNetworkConfig sharedInstance];
    config.baseUrl = BASE_URL_STRING;
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    
    BOOL isFirst = [ud boolForKey:kFirstLaunch];
    
    BOOL isLoginSuccess = [ud boolForKey:kIsLoginSuccess];
    if (isFirst == true) {
        if (isLoginSuccess == true) {
            NSString *token = [[CSUserDefaults shareUserDefault] getUserToken];
            YTKUrlArgumentsFilter *tokenFilter = [YTKUrlArgumentsFilter filterWithArguments:@{@"token": token}];
            [config addUrlFilter:tokenFilter];
            [self enterHomeVC];
          
        }else{
            [self ITLogin];
            [self enterHomeVC];
        }
    }else{
        CSGuideViewController *guide = [[CSGuideViewController alloc]init];
        self.window.rootViewController = [[UINavigationController alloc]initWithRootViewController:guide];
    }
    
}

//哪个环境登录（测试或者腾讯正式环境）
- (void)whichEnvironmentLogin{
    if (isTencent == NO) {
        //如果是测试环境
        [self enterWhichVC];
        //如果是正式环境
    }else{
        [self tencentEnterWhichVC];
    }
   
}


//清除拼接答案的plist文件
- (void)deleteAnswerData{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *singleAnswerPath = [NSHomeDirectory() stringByAppendingPathComponent:kSingleArrayPathType];
    NSString *multiAnswerPath = [NSHomeDirectory() stringByAppendingPathComponent:kMultiArrayPathType];
    NSString *noItemAnswerPath = [NSHomeDirectory() stringByAppendingPathComponent:kNoItemArrayPathType];
    NSString *judgeAnswerPath = [NSHomeDirectory() stringByAppendingPathComponent:kJudgeArrayPathType];
    NSString *questionAnswerPath = [NSHomeDirectory() stringByAppendingPathComponent:kQuestionArrayPathType];
     NSString *fillAnswerPath = [NSHomeDirectory() stringByAppendingPathComponent:kFillArrayPathType];
    if ([fileManager fileExistsAtPath:singleAnswerPath]) {
        NSError *error;
        [fileManager removeItemAtPath:singleAnswerPath error:&error];
    }
    if ([fileManager fileExistsAtPath:multiAnswerPath]){
        NSError *error;
        [fileManager removeItemAtPath:multiAnswerPath error:&error];
    }
    if ([fileManager fileExistsAtPath:noItemAnswerPath]){
        NSError *error;
        [fileManager removeItemAtPath:noItemAnswerPath error:&error];
    }
    if ([fileManager fileExistsAtPath:judgeAnswerPath]){
        NSError *error;
        [fileManager removeItemAtPath:judgeAnswerPath error:&error];
    }
    if ([fileManager fileExistsAtPath:questionAnswerPath]){
        NSError *error;
        [fileManager removeItemAtPath:questionAnswerPath error:&error];
    }
    if ([fileManager fileExistsAtPath:fillAnswerPath]){
        NSError *error;
        [fileManager removeItemAtPath:fillAnswerPath error:&error];
    }
}

/**
 *腾讯bugly
 */
- (void)setBugly{
    BuglyConfig * config = [[BuglyConfig alloc] init];
    //#if DEBUG
    config.debugMode = YES;
    //#endif
    config.reportLogLevel = BuglyLogLevelWarn;
    config.blockMonitorEnable = YES;
    config.blockMonitorTimeout = 1.5;
    
    
    [Bugly startWithAppId:Bugly_Appid
     //#if DEBUG
        developmentDevice:NO
     //#endif
                   config:config];
    
    NSString * userName = [CSUserDefaults shareUserDefault].getUserName;
    [Bugly setUserIdentifier:[NSString stringWithFormat:@"%@",userName]];
    
    [Bugly setUserValue:[NSProcessInfo processInfo].processName forKey:@"Tencent"];

}

@end
