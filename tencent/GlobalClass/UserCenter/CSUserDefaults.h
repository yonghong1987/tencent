 //
//  CSUserDefaults.h
//  tencent
//
//  Created by sunon002 on 16/4/18.
//  Copyright © 2016年 cyh. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CSUserModel.h"
@class CSUserDefaults;
/*
 **保存用户名
 */
#define kUserDefaultsName  @"name"
/*
 **保存用户密码
 */
#define kUserDefaultsPassword @"password"
/*
 **保存用户token
 */
#define kUserDefaultsToken @"token"
/*
 **保存用户
 */
#define kUserDefaultsUser @"user"
/*
 **是否是第一次进入app
 */
#define kFirstLaunch @"FirstLaunch"
/*
 **保存登陆状态
 */
#define kIsLoginSuccess @"loginSucessStatus"

@interface CSUserDefaults : NSObject


#pragma mark Single
+ (CSUserDefaults *)shareUserDefault;
/*
 **保存用户
 */
- (void)saveUser:(CSUserModel *)user;
/*
 **取出用户
 */
- (CSUserModel *)getUser;
/*
 **保存用户token
 */
- (void)saveUserToken:(NSString *)token;
/*
 **取出用户token
 */
- (NSString *)getUserToken;
/*
 **取出用户token
 */
- (void)saveUserName:(NSString *)userName;
/*
 **取出用户名
 */
- (NSString *)getUserName;
/*
 **保存用户密码
 */
- (void)saveUserPassword:(NSString *)password;
/*
 **取出用户密码
 */
- (NSString *)getUserPassword;
/*
 **保存第一次登陆信息
 */
- (void)saveFirstLaunch:(BOOL)launch;
/*
 **取出第一次登陆信息
 */
- (BOOL)getFirstLaunch;
/*
 **保存登陆成功状态
 */
- (void)saveLoginSuccessStatus:(BOOL)loginSucess;
/*
 **取出登陆状态
 */
-(BOOL)getLoginSuccessStatus;

/*
 **清除用户信息
 */
- (void)clearUserMessage;
@end
