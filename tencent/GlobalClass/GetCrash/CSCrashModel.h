//
//  CSCrashModel.h
//  tencent
//
//  Created by admin on 16/5/18.
//  Copyright © 2016年 cyh. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CSCrashModel : NSObject<NSCoding>
/*
 **异常发生的时间
 */
@property (nonatomic, copy) NSString *crashTime;
/*
 **异常的原因
 */
@property (nonatomic, copy) NSString *crashReason;
/*
 **异常的名称
 */
@property (nonatomic, copy) NSString *crashName;
/*
 **异常的堆栈信息
 */
@property (nonatomic, strong) NSArray *crashStack;
/*
 **异常的设备系统版本
 */
@property (nonatomic, copy) NSString *deviceSystemVerson;
/*
 **异常的设备型号
 */
@property (nonatomic, copy) NSString *deviceType;
@end
