//
//  CSUserDefaults.m
//  tencent
//
//  Created by sunon002 on 16/4/18.
//  Copyright © 2016年 cyh. All rights reserved.
//

#import "CSUserDefaults.h"

@implementation CSUserDefaults


#pragma mark Single
+ (CSUserDefaults *)shareUserDefault{
    static CSUserDefaults *share = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        share = [[CSUserDefaults alloc]init];
    });
    return share;
}

#pragma mark - Get、Save
- (id)getData:(NSString *)key
{
    NSUserDefaults *standardUserDefaults = [NSUserDefaults standardUserDefaults];
    NSString *val = nil;
    
    if (standardUserDefaults)
        val = [standardUserDefaults objectForKey:key];
    
    return val;
}

- (BOOL)saveData:(NSString *)key andValue:(id)value
{
    NSUserDefaults *standardUserDefaults = [NSUserDefaults standardUserDefaults];
    BOOL bResult = NO;
    if (standardUserDefaults) {
        [standardUserDefaults setObject:value forKey:key];
        [standardUserDefaults synchronize];
        bResult = YES;
    }
    return bResult;
}

- (void)saveUser:(CSUserModel *)user{
    NSData *userData = [NSKeyedArchiver archivedDataWithRootObject:user];
    [self saveData:kUserDefaultsUser andValue:userData];
}

- (CSUserModel *)getUser{
    NSData *userData = [self getData:kUserDefaultsUser];
    CSUserModel *userModel = [CSUserModel new];
    if (userData.length > 0) {
        userModel = [NSKeyedUnarchiver unarchiveObjectWithData:userData];
    }
    return userModel;
}

- (void)saveUserToken:(NSString *)token{
    [self saveData:kUserDefaultsToken andValue:token];
}

- (NSString *)getUserToken{
    return [self getData:kUserDefaultsToken];
}

- (void)saveUserName:(NSString *)userName{
    [self saveData:kUserDefaultsName andValue:userName];
}

- (NSString *)getUserName{
    return [self getData:kUserDefaultsName];
}

- (void)saveUserPassword:(NSString *)password{
    [self saveData:kUserDefaultsPassword andValue:password];
}

- (NSString *)getUserPassword{
   return [self getData:kUserDefaultsPassword];
}

- (void)saveFirstLaunch:(BOOL)launch{
    [self saveData:kFirstLaunch andValue:[NSNumber numberWithBool:launch]];
}

- (BOOL)getFirstLaunch{
    id obj = [self getData:kFirstLaunch];
    if ([obj isKindOfClass:[NSNumber class]]) {
        return [obj boolValue];
    }
    return YES;
}

- (void)saveLoginSuccessStatus:(BOOL)loginSucess{
   [self saveData:kIsLoginSuccess andValue:[NSNumber numberWithBool:loginSucess]];
}

-(BOOL)getLoginSuccessStatus{
    id obj = [self getData:kIsLoginSuccess];
    if ([obj isKindOfClass:[NSNumber class]]) {
        return [obj boolValue];
    }
    return YES;
}

- (void)clearUserMessage{
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    NSDictionary * dictionary = [ud dictionaryRepresentation];
    for (NSString *key in [dictionary allKeys]) {
        if (![key isEqualToString:kFirstLaunch]) {
            if ([key hasPrefix:@"http"]) {
                
            }else{
                [ud removeObjectForKey:key];
                [ud synchronize];
            }
        }
    }
}
@end
