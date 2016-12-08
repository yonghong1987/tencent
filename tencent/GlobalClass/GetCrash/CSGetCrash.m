//
//  CSGetCrash.m
//  tencent
//
//  Created by admin on 16/5/18.
//  Copyright © 2016年 cyh. All rights reserved.
//

#import "CSGetCrash.h"
#import <UIKit/UIKit.h>
#import "CSCrashModel.h"
@implementation CSGetCrash

void uncaughtExceptionHandler(NSException *exception)
{
    //初始化crash对象
    CSCrashModel *crashModel = [CSCrashModel new];
    // 异常的堆栈信息
    crashModel.crashStack = [exception callStackSymbols];
    // 出现异常的原因
    crashModel.crashReason = [exception reason];
    // 异常名称
    crashModel.crashName = [exception name];
    //异常发生的时间
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    crashModel.crashTime = [dateFormatter stringFromDate:[NSDate date]];
    //手机版本
    UIDevice *device = [[UIDevice alloc] init];
    crashModel.deviceSystemVerson = device.systemVersion;
    //手机系统
    crashModel.deviceType = device.systemName;
    //归档
    NSMutableData *data = [NSMutableData data];
    NSKeyedArchiver *arch = [[NSKeyedArchiver alloc] initForWritingWithMutableData:data];
    [arch encodeObject:crashModel forKey:@"crash"];
    [arch finishEncoding];
    [data writeToFile:[NSString stringWithFormat:@"%@/Documents/error.text",NSHomeDirectory()] atomically:YES];
}
@end
