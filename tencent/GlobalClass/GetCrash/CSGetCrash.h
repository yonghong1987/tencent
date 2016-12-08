//
//  CSGetCrash.h
//  tencent
//
//  Created by admin on 16/5/18.
//  Copyright © 2016年 cyh. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CSGetCrash : NSObject
/*
 **获取异常的函数
 */
void uncaughtExceptionHandler(NSException *exception);
@end
