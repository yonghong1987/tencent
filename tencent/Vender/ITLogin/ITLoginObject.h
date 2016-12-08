//
//  ITLoginObject.h
//  ITLoginSDK
//
//  Created by Kavin on 14-3-21.
//  Copyright (c) 2014年 Tencent. All rights reserved.
//  Version: ITLogin 1.4.0
//
//  == ITLogin登录sdk使用流程 ==
//
//  1. 申请所开发产品使用ITLogin SDK的权限标识appkey，可联系 @kavinzheng
//  2. 在工程中使用libITLoginSDK包，同时导入接口函数类ITLogin.h和数据类ITLoginObject.h
//  3. info.plist中LSApplicationQueriesSchemes增加跳转名单：itlogin和itlogin3
//  4. 导入图片资源bundle
//
//  接入业务联系 @kavinzheng

#import <Foundation/Foundation.h>

/**
 *  登录错误状态码
 */
typedef enum
{
    LoginErrorCodeUnknow = 1,                  /**<  未知错误     */
    LoginErrorCodeParamsError,                 /**<  字段参数错误    */
    LoginErrorCodeAccountError,                /**<  帐号错误      */
    LoginErrorCKeyExpire,                      /**<  credentialkey已经过期或不存在，需重新token验证 */
    LoginErrorCodeAppKeyError,                 /**<  sdk appkey或appid错误或者失效    */
    LoginErrorDeviceForbid,                    /**<  设备被禁用，登录失败    */
    LoginErrorDeviceStatusChange,              /**<  设备状态被改变，需要重新token验证    */
    LoginErrorDeviceExist,                     /**<  设备已经注册给其他用户，不允许新用户登录    */
    LoginErrorDeviceError,                     /**<  设备错误    */
    LoginErrorCodeSSOAuthError,                /**<  SSO登录授权失败    */
    LoginErrorCodeDataError,                   /**<  数据处理错误    */
} LoginErrorCode;


/**
 *  登录页面弹出时的动画类型
 */
typedef enum
{
    ITLoginTransitionTypeNone = 0,      /**< 没有动画    */
    ITLoginTransitionTypeFade = 1,      /**< 淡入淡出    */
    ITLoginTransitionTypePush = 2,      /**< 展现的时候从右边push 退出的时候相反    */
} ITLoginTransitionType;


/**
 *  提供ITLogin登录身份信息的数据模型
 */
@interface ITLoginInfo : NSObject
/**
 *  第三方产品使用ITLogin sdk的唯一权限标识，接入sdk时需要联系申请
 */
@property (nonatomic, retain) NSString *appKey;
/**
 *  第三方产品使用ITLogin sdk分配的产品英文id名，接入sdk时需要联系申请
 */
@property (nonatomic, retain) NSString *appId;
/**
 *  当前登录用户的credentialkey登录票据
 */
@property (nonatomic, retain) NSString *credentialkey;
/**
 *  当前ITLogin sdk版本
 */
@property (nonatomic, retain) NSString *version;

@end

/**
 *  用于ITLogin登录失败状态时，返回的失败信息数据模型
 */
@interface ITLoginError : NSObject
/**
 *  http状态码
 */
@property (nonatomic, assign) NSInteger httpStatusCode;
/**
 *  登录请求返回的状态id，所有具体类型可见LoginErrorCode
 */
@property (nonatomic, assign) LoginErrorCode errorCode;
/**
 *  详细的登录错误信息
 */
@property (nonatomic, retain) NSString  *errorMsg;

@end
