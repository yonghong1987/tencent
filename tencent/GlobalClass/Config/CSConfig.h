//
//  CSConfig.h
//  tencent
//
//  Created by sunon002 on 16/4/18.
//  Copyright © 2016年 cyh. All rights reserved.
//

#import "CSNotificationConfig.h"

#ifndef CSConfig_h
#define CSConfig_h

#define LOCALVERSION @"IOS1605233.2.4"
#define IOS7 ([[UIDevice currentDevice].systemVersion doubleValue] >= 7.0)
/*
 **列表每次请求服务器的条数
 */
#define RP 10

#define WS(weakSelf)  __weak __typeof(&*self)weakSelf = self
#define ImageNamed(x) [UIImage imageNamed:x]
/*
 **开发阶段
 */
#ifdef DEBUG
#define DLog(fmt, ...) NSLog((@"%s [on line %d]" fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__)
#else //发布阶段
#define DLog(...)
#endif

/*  ********* 加密储存视频文件 ********* */
#define sandBoxDocument [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0]
#define sandBoxTemp NSTemporaryDirectory()

#define cacheDir  [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0]
#define VIDOEDOWNLOADPATH @"AFVideoRequestOperationDownloadingVideosFolder"
#define VIDEODOWNLOADCACHEPATH @"AFVideoRequestOperationDownloadingVideosFolderCache"
#define VIDEORECORDPLAYERTIME  @"videoPlaybackTime.plist"
/*  ************************************* */


//ITLogin登陆AppId
#define kITLoginAppId @"sunontalentTencent"
//ITLogin登陆AppKey
#define kITLoginAppkey @"com.sunontalent.eLearning"
#define kAppKey @"9db4581fe42a69ed02dc559e717efdz"
#define kAppID @"mlearning"

#endif /* CSConfig_h */
