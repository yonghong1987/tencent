//
//  AppDelegate.m
//  tencent
//
//  Created by sunon002 on 16/4/15.
//  Copyright © 2016年 cyh. All rights reserved.
//

#import "AppDelegate.h"
#import "AppDelegate+Category.h"
#import "CSUserDefaults.h"

#import "CSCoreDataManager.h"
#import "CSDownLoadResourceModel.h"
#import "CSGetCrash.h"

#import "CSCourseDetailOperationModel.h"
#import "CSCrashModel.h"
#import "CSConfig.h"

#import "YTKNetworkConfig.h"
#import "CSUrl.h"
#import "MacrosSystem.h"
#import "CSUserDefaults.h"
#import "WXApi.h"
#import "CSSpecialDetailViewController.h"
#import <TVKPlayer/TVKPlayer.h>
#import "CSUtilFunction.h"
#import "CSUserDefaults.h"
#import "CSGlobalMacro.h"
#define kWeiXinAppID @"wxa1fd47b939891d35"

#define SDK_PRODUCT_PRIVATEKEY  @"f3f1b37dd82f9f2a3f1aaf232d903c2a4fb2b8faa548e72512ad12d72d6a6906a148885451d64d35aa81e862cc421d302776cb4752e0065c3a9af6ed9ce28009"
#define SDK_PRODUCT_APPKEY @"a4XkSJJmpd7frpOVeKchVCBu5Ag2fioCn0cgSyxK5CJP/CH3bJTy12410lS7I18/M1LN2g46qHtsHiihmPhI+xO1lhG2GTu+2lDXS33lgiSGXF07lstPiePfmVWheW9aoGZLbuy7kmzYDY4paY2qQ8+wCfl2wgFcGs3OL8zKp/U="


#import "TYDownloadSessionManager.h"
#import "MagicalRecord.h"
#import "AvoidCrash.h"
@interface AppDelegate ()<WXApiDelegate>
/**
 *app唤醒传过来的字符串
 */
@property (nonatomic, strong) NSMutableDictionary *tencentDic;
@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.window = [[UIWindow alloc]initWithFrame:[UIScreen mainScreen].bounds];
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    [CSCourseDetailOperationModel configurationTVKSDK];
    [self whichEnvironmentLogin];
    [self setBugly];
    //注册异常不闪退
    [AvoidCrash becomeEffective];
    //监听通知:AvoidCrashNotification, 获取AvoidCrash捕获的崩溃日志的详细信息
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(dealwithCrashMessage:) name:AvoidCrashNotification object:nil];

//    [self initVideo];
    [WXApi registerApp:kWeiXinAppID];
    
    
    
    [self backgroundDownload];
    [self setupcCoreData];

    return YES;
}

+ (AppDelegate *) sharedInstance
{
    return (AppDelegate *) [UIApplication sharedApplication].delegate;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
     [[UIApplication sharedApplication] beginBackgroundTaskWithExpirationHandler:nil];
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    NSError *error = nil;
    [[NSFileManager defaultManager] removeItemAtPath:[cacheDir stringByAppendingPathComponent:@"EXAM"] error:&error];
    NSLog(@"delete inforamtion is:%@",error.description);
    
    [MagicalRecord cleanUp];
    
}

- (void)initDB
{
    CSCoreDataManager *manager = [CSCoreDataManager shareDBManager];
    NSPredicate *predicate=[NSPredicate predicateWithFormat:@"download_type=%d",DOWN_LOADING];
    NSFetchRequest *fetch=[[NSFetchRequest alloc] initWithEntityName:@"CSDownLoadResourceModel"];
    [fetch setPredicate:predicate];
    NSArray *array=[manager.managedObjectContext executeFetchRequest:fetch error:nil];
    for (CSDownLoadResourceModel *resourceModel in array) {
        [resourceModel setDownload_type:[NSNumber numberWithInteger:DOWN_PAUSE]];
    }

//    if (![manager.managedObjectContext save:nil]) {
//        NSLog(@"save error");
//    }else{
//        NSLog(@"======save success======");
//    }
    
}




- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation{
    [[ITLogin sharedInstance] handleSSOURL:url];
    [WXApi handleOpenURL:url delegate:self];
    return YES;
}

//解析app唤醒的链接
-(void)parserAppWakeupWithUrl:(NSString *)strURL{
    
     //-- sunontalentTencent://com.sunontalent.eLearning/type=ONLINE&courseId=416&projectId=4
    NSString * guDinStr = @"sunontalentTencent://";
    if([strURL rangeOfString:@"com.sunontalent.eLearning/"].location != NSNotFound) {
        guDinStr = [guDinStr stringByAppendingString:@"com.sunontalent.eLearning/"];
    }else{
        return ;
    }
    if(strURL.length > guDinStr.length) {
        NSString * parameters = [strURL substringFromIndex:guDinStr.length];
        NSMutableArray  * arrParam = (NSMutableArray * )[parameters componentsSeparatedByString:@"&"];
        if([arrParam containsObject:@""])
            [arrParam removeObject:@""];
        NSUInteger arrParamCount = arrParam.count;
        NSMutableDictionary * dicParam = [[NSMutableDictionary alloc] initWithCapacity:arrParamCount];
        for(NSString *param in arrParam) {
            NSMutableArray *oneParam = (NSMutableArray *)[param componentsSeparatedByString:@"="];
            if([oneParam containsObject:@""])
                [oneParam removeObject:@""];
            [dicParam setValue:[oneParam lastObject] forKey:[oneParam firstObject]];
            
        }
        self.tencentDic = [NSMutableDictionary dictionaryWithDictionary:dicParam];
    }

}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    
    if([keyPath isEqualToString:@"token"]) {
        NSString * token = [change objectForKey:NSKeyValueChangeNewKey];
        NSString * oldToken = [change objectForKey:NSKeyValueChangeOldKey];
        if(token && !oldToken) {// && oldToken && ![oldToken isEqualToString:token]
            if([CSUtilFunction isNotNiLString:[[CSUserDefaults shareUserDefault] getUserToken]]) {
                /*
                 *  item            ViewController的索引
                 *  projectName     项目名称
                 *  projectId       项目ID
                 */
                //-- sunontalentTencent://com.sunontalent.eLearning/type=ONLINE&courseId=416&projectId=4
                NSString * strURL = [[NSUserDefaults standardUserDefaults] objectForKey:OpenURLChangedApp];
                
                NSString * guDinStr = @"sunontalentTencent://";
                if([strURL rangeOfString:@"com.sunontalent.eLearning/"].location != NSNotFound) {
                    guDinStr = [guDinStr stringByAppendingString:@"com.sunontalent.eLearning/"];
                }else{
                    return ;
                }
                if(strURL.length > guDinStr.length) {
                    NSString * parameters = [strURL substringFromIndex:guDinStr.length];
                    NSMutableArray  * arrParam = (NSMutableArray * )[parameters componentsSeparatedByString:@"&"];
                    if([arrParam containsObject:@""])
                        [arrParam removeObject:@""];
                    NSUInteger arrParamCount = arrParam.count;
                    NSMutableDictionary * dicParam = [[NSMutableDictionary alloc] initWithCapacity:arrParamCount];
                    for(NSString *param in arrParam) {
                        NSMutableArray *oneParam = (NSMutableArray *)[param componentsSeparatedByString:@"="];
                        if([oneParam containsObject:@""])
                            [oneParam removeObject:@""];
                        [dicParam setValue:[oneParam lastObject] forKey:[oneParam firstObject]];
                        
                    }
                    
                    self.tencentDic = [NSMutableDictionary dictionaryWithDictionary:dicParam];
                }
            }
        }
        
    }
}



-(void)initVideo
{
    //////////////////////////////////////////////////////////////////////
    //注册SDK（必须）
    BOOL regSuc = [[TVKSDKManager sharedInstance] registerWithAppKey:SDK_PRODUCT_APPKEY];
    if (regSuc)
    {
        //设置privatekey（必须）
        [TVKSDKManager sharedInstance].productPrivateKey = SDK_PRODUCT_PRIVATEKEY;
        
        //        //设置QQ和cookie（可选）
        //        [TVKSDKManager sharedInstance].loginQQ = @"1623238768";
        //                [TVKSDKManager sharedInstance].cookieForRequest = @"uin=1623238768;skey=MsCb5QtP3B;lsky=00030000372672dfefb910235404797261c94927d48e391430a0cd3daeacbcc495c52ed165543a36d70bb30c;";
        //
        //        //demo用，不必填写，但需要在后台登记app的UA
        //        [TVKSDKManager sharedInstance].uaForRequest = @"live4iphone/9999 CFNetwork/672.1.15 Darwin/14.0.0";
        
        
        //初始化播放（必须）
        [TVKMediaPlayer initializeTVKPlayer];
        
        /////////////////上面的过程通常在程序启动后调用////////////////////////////////
        /////////////////下面关于播放器的方法可在开始播放时才调用////////////////////////
        
        //插入控制UI（可选）
        //        UIView* smallPlayerView = [[UIView alloc] initWithFrame:CGRectZero];
        //        smallPlayerView.backgroundColor = [UIColor redColor];
        //        [[TVKMediaPlayer sharedInstance] addCustomSmallPlayerUI:smallPlayerView];
        //        UIView* mainPlayerView = [[UIView alloc] initWithFrame:initWithFrame:CGRectZero];
        //        mainPlayerView.backgroundColor = [UIColor blueColor];
        //        [[TVKMediaPlayer sharedInstance] addCustomMainPlayerUI:mainPlayerView];
        
        //启用功能项（可选，除TVKMediaPlayerFunc_LoadingTips默认打开外，其他默认关闭），
        [[TVKMediaPlayer sharedInstance] enablePlayerFuncWithItem:TVKMediaPlayerFunc_Advertisement];
        [[TVKMediaPlayer sharedInstance] enablePlayerFuncWithItem:TVKMediaPlayerFunc_FlyScreen];
        [[TVKMediaPlayer sharedInstance] enablePlayerFuncWithItem:TVKMediaPlayerFunc_Download];
        [[TVKMediaPlayer sharedInstance] enablePlayerFuncWithItem:TVKMediaPlayerFunc_JumpNext];
        [[TVKMediaPlayer sharedInstance] enablePlayerFuncWithItem:TVKMediaPlayerFunc_ChooseFormat];
        [[TVKMediaPlayer sharedInstance] enablePlayerFuncWithItem:TVKMediaPlayerFunc_Recomment];
        [[TVKMediaPlayer sharedInstance] enablePlayerFuncWithItem:TVKMediaPlayerFunc_MoreMenu];
        [[TVKMediaPlayer sharedInstance] enablePlayerFuncWithItem:TVKMediaPlayerFunc_DLNA];
        [[TVKMediaPlayer sharedInstance] enablePlayerFuncWithItem:TVKMediaPlayerFunc_AirPlay];
        [[TVKMediaPlayer sharedInstance] enablePlayerFuncWithItem:TVKMediaPlayerFunc_Gesture];
    }
    else
    {
        NSLog(@"registerWithAppKey failed:%d", [TVKSDKManager sharedInstance].authStatus);
    }
    
    //////////////////////////////////////////////////////////////////////
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(pausePlayWithEnterBackground:)
                                                 name:UIApplicationWillResignActiveNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(continuePlayWithEnterBackground:)
                                                 name:UIApplicationDidBecomeActiveNotification
                                               object:nil];
    
}


//若需要自己控制前后台暂停播放，请做如下操作，否则播放器退后台会自动暂停，进前台会自动播放
- (void)pausePlayWithEnterBackground:(NSNotification*)noti
{
    //    if (![TVKMediaPlayer sharedInstance].isDLNAActive && ![TVKMediaPlayer sharedInstance].isAirPlayActive) {
    //        [[TVKMediaPlayer sharedInstance] pause];
    //    }
}

- (void)continuePlayWithEnterBackground:(NSNotification*)noti
{
    //    [[TVKMediaPlayer sharedInstance] play];
}
#pragma mark  - coreData
- (void)setupcCoreData{
    [MagicalRecord setupAutoMigratingCoreDataStack];
}
#pragma mark - duck  后台下载
- (void)backgroundDownload{
    [[TYDownloadSessionManager manager] setBackgroundSessionDownloadCompleteBlock:^NSString *(NSString *downloadUrl) {
        TYDownloadModel *model = [[TYDownloadModel alloc]initWithURLString:downloadUrl];
        return model.filePath;
    }];
    [[TYDownloadSessionManager manager] configureBackroundSession];
}

- (void)application:(UIApplication *)application handleEventsForBackgroundURLSession:(NSString *)identifier
  completionHandler:(void (^)())completionHandler
{
    [TYDownloadSessionManager manager].backgroundSessionCompletionHandler = completionHandler;
}


#pragma mark - 捕获异常补闪退
- (void)dealwithCrashMessage:(NSNotification *)note {
    
    //注意:所有的信息都在userInfo中
    //你可以在这里收集相应的崩溃信息进行相应的处理(比如传到自己服务器)
    NSLog(@"\n\n在AppDelegate中 方法:dealwithCrashMessage打印\n\n\n\n\n%@\n\n\n\n",note.userInfo);
}

@end

