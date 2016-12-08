//
//  CSHttpRequestManager.h
//  tencent
//
//  Created by sunon002 on 16/4/16.
//  Copyright © 2016年 cyh. All rights reserved.
//

#import <Foundation/Foundation.h>

@class CSHttpRequestManager;
@interface CSHttpRequestManager : NSObject
/*
 **定义请求成功的block变量
 */
typedef void(^httpRequestSuccess) (CSHttpRequestManager *manager,id model);
/*
 ***定义请求失败的block变量
 */
typedef void(^httpRequestFailure) (CSHttpRequestManager *manager,id nodel);


+ (CSHttpRequestManager *)shareManager;
/*
 **检测网络情况
 */
- (NSString *)GetNetWorkType;
/*
 **发送Get请求
 */
- (void)getDataFromNetWork:(NSString *)urlString parameters:(id)parameters success:(httpRequestSuccess)success failture:(httpRequestFailure)failure;
/*
 **发送Post请求
 */
- (void)postDataFromNetWork:(NSString *)urlString parameters:(id)parameters success:(httpRequestSuccess)success failture:(httpRequestFailure)failure;
@end
