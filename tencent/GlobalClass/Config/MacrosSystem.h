//
//  MacrosSystem.h
//  sunMobile
//
//  Created by duck on 16/3/18.
//  Copyright © 2016年 www.sunontalent.com. All rights reserved.
//

#ifndef MacrosSystem_h
#define MacrosSystem_h

// 当前系统版本
#define FSystemVersion          ([[[UIDevice currentDevice] systemVersion] floatValue])
#define DSystemVersion          ([[[UIDevice currentDevice] systemVersion] doubleValue])
#define SSystemVersion          ([[UIDevice currentDevice] systemVersion])

//App版本号
#define AppMPVersion [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"]

#endif /* MacrosSystem_h */
