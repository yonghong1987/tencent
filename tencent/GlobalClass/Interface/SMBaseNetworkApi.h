//
//  SMBaseNetworkApi.h
//  sunMobile
//
//  Created by duck on 16/3/21.
//  Copyright © 2016年 www.sunontalent.com. All rights reserved.
//

#import "YTKRequest.h"
#import "CSUrl.h"


typedef void(^SMRequestSuccessBlock)(id responseJSONObject,NSInteger responseCode);
typedef void(^SMRequestFailureBlock)(NSError * error);
typedef NS_ENUM(NSInteger , SMResponseCode) {
    
    /**
     *  正常状态
     */
    SMResponseCode999 = 999,
    
    /**
     *  服务器异常
     */
    
    SMResponseCode_1 = -1,
    
    /**
     *  Token 无效
     */
    SMResponseCode_99 = -99,
    /**
     *  数据异常
     */
    SMResponseCode900 =  900
};


@interface SMBaseNetworkApi : YTKRequest

/**
 *  设置 GET POST
 *   默认POST
 */
@property (nonatomic ,assign) YTKRequestMethod requestMethod;
/**
 *  请求 url
 */
@property (nonatomic, copy) NSString *requestUrl;
/**
 *  请求参数
 */
@property (nonatomic, copy) id requestArgument;

/**
 *  SMBaseNetworkApi 发送网络请求
 *
 *  @param success 请求成功回调
 *  @param failure 请求失败回调
 */
- (void)startWithCompletionBlockWithSuccess:(SMRequestSuccessBlock)success withFailure:(SMRequestFailureBlock)failure;

@end
