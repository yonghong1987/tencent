//
//  ITLogin.h
//  ITLoginDemo
//
//  Created by Kavin on 14-3-21.
//  Copyright (c) 2014年 Tencent. All rights reserved.
//  Version: ITLogin V1.4.0
//
//  == ITLogin登录sdk使用流程 ==
//
//  1. 申请所开发产品使用ITLogin SDK的权限标识appkey，可联系 @kavinzheng
//  2. 在工程中使用libITLoginSDK包，同时导入接口函数类ITLogin.h和数据类ITLoginObject.h
//  3. info.plist中LSApplicationQueriesSchemes增加跳转名单：itlogin和itlogin3
//  4. 导入图片资源bundle
//
//  接入业务联系 @kavinzheng


#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import "ITLoginObject.h"


/**
 *  登录操作回调协议，分别有token登录的回调、验证登录的回调，以及登出的回调
 */
@protocol ITLoginDelegate <NSObject>
/**
 *  验证登录成功回调
 */
- (void)didValidateLoginSuccess;
/**
 *  验证登录失败回调，并返回登录失败数据信息
 */
- (void)didValidateLoginFailWithError:(ITLoginError*)error;
/**
 *  token或sso登录成功回调
 */
- (void)didTokenLoginSuccess;
/**
 *  token或sso登录失败回调，并返回登录失败数据信息
 */
- (void)didTokenLoginFailWithError:(ITLoginError*)error;
/**
 *  退出登录成功回调
 */
- (void)didFinishLogout;


@end

/**
 *  ITLogin sdk接口函数类，封装了ITLogin所需的所有接口
 */
@interface ITLogin : NSObject
/**
 *  登录操作的回调代理
 */
@property (nonatomic, assign) id<ITLoginDelegate> delegate;
/**
 *  弹出token登录页面的动画设置，与showTokenLoginPage配合使用
 */
@property (nonatomic, assign) ITLoginTransitionType transitionType;

/**
 *  封装ITLogin sdk接口函数的单例
 *
 *  @return 返回ITLogin接口函数的实例，供全局使用
 */
+ (id)sharedInstance;
/**
 *  设置ITLogin sdk权限使用appkey，接入sdk时需要联系申请
 *
 *  @param key    第三方产品使用ITLogin sdk的唯一权限标识
 *  @param appid  第三方产品使用ITLogin sdk的唯一id名
 */
- (void)startWithAppKey:(NSString*)key AppId:(NSString *)appid;
/**
 *  验证登录，用于用户自动登录、唤起app和使用过程中心跳验证登录的方法
 */
- (void)validateLogin;
/**
 *  退出登录，自动删除本地登录态
 */
- (void)logout;


/**
 *  处理MOA SSO授权后传递过来的数据，需要在 application:openURL:sourceApplication:annotation:或者application:handleOpenURL中调用。
 *
 *  @param url MOA SSO授权处理后传递过来的URL
 */
- (void)handleSSOURL:(NSURL *)url;
/**
 *  获得当前登录身份信息
 *
 *  @return 返回当前用户登录的身份信息
 */
- (ITLoginInfo *)getLoginInfo;
/**
 *  自定义token登录页面logo
 *
 *  @param logo token登录页面顶部logo图标，默认展示ITLogin图标，建议自定义图片大小216*216px
 */
- (void)changeLogo:(UIImage *)logo;
/**
 *  ITLogin默认支持outlook白名单登录，如果调用此方法，则默认关闭outlook登录方式，弹出数字键盘强制token登录
 *
 */
- (void)disableOutlookLogin;

@end
