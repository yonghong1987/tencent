//
//  CSHttpRequestManager.m
//  tencent
//
//  Created by sunon002 on 16/4/16.
//  Copyright © 2016年 cyh. All rights reserved.
//

#import "CSHttpRequestManager.h"
#import "AFNetworking.h"
#import <CoreTelephony/CTTelephonyNetworkInfo.h>
#import "CSUrl.h"
#import "NSDictionary+convenience.h"
#import "CSConfig.h"

#import "CSProjectDefault.h"
#import "CSUserDefaults.h"

#import "SMBaseNetworkApi.h"

@interface CSHttpRequestManager ()

@property (nonatomic, strong) AFHTTPRequestOperationManager *manager;

@end

@implementation CSHttpRequestManager

#pragma mark - 单例
+ (CSHttpRequestManager *)shareManager{
    static CSHttpRequestManager *shareIntance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        shareIntance = [[CSHttpRequestManager alloc]init];
    });
    return shareIntance;
}

- (id)init{
    self = [super init];
    if ( self ) {

    }
    return self;
}

/*
 **创建manager对象
 */
- (AFHTTPRequestOperationManager *)manager{
    if (!_manager) {
        _manager = [[AFHTTPRequestOperationManager alloc] initWithBaseURL:[NSURL URLWithString:BASE_URL_STRING]];
    }
    return _manager;
}

#pragma mark 发送Get请求
- (void)getDataFromNetWork:(NSString *)urlString parameters:(id)parameters success:(httpRequestSuccess)success failture:(httpRequestFailure)failure{
    [self.manager GET:urlString parameters:parameters success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        int code = [responseObject intForKey:@"code"];
        if (code == 0) {
            success(self,responseObject);
        }else{
            failure(self, nil);
        }
    } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
        failure(self,error);
    }];
}

#pragma mark 发送Post请求
- (void)postDataFromNetWork:(NSString *)urlString parameters:(id)parameters success:(httpRequestSuccess)success failture:(httpRequestFailure)failure{
    
//    NSString *string = [NSString stringWithFormat:@"%@%@",BASE_URL_STRING,[self urlDictToStringWithUrlStr:urlString WithDict:parameters]];
//    NSLog(@"string:%@",string);
    NSMutableDictionary *paramDic = [NSMutableDictionary dictionaryWithDictionary:parameters];
    
    /**
     *  检查是否存在项目Id
     */
    if ( ![urlString isEqualToString:URL_USER_LOGIN] && ![urlString isEqualToString:GET_PROJECTS] ) {
        id projectId = [[CSProjectDefault shareProjectDefault] getProjectId];
        if ( !projectId ) {
            failure(self,[self errorWithDescription:@"项目id异常"]);
            return;
        }
    }
    
    SMBaseNetworkApi *netWorkApi = [[SMBaseNetworkApi alloc] init];
    netWorkApi.requestUrl = urlString;
    netWorkApi.requestArgument = paramDic;
    [netWorkApi startWithCompletionBlockWithSuccess:^(id responseJSONObject, NSInteger responseCode) {
        success(self, responseJSONObject);
    }withFailure:^(NSError *error) {
         failure(self,error);
    }];
}


/**
 *  构造错误提示语
 *
 *  @param desc 错误描述
 *
 *  @return 错误实体
 */
- (NSError *)errorWithDescription:(NSString *)desc{
    NSError *error = [[NSError alloc] initWithDomain:desc
                                                code:-1
                                            userInfo:@{@"errorInfo":desc}];
    return error;
}


#pragma mark - 监测网络情况
- (NSString *)GetNetWorkType
{
    NSString *strNetworkType = @"";
    
    //创建零地址，0.0.0.0的地址表示查询本机的网络连接状态
    struct sockaddr_storage zeroAddress;
    
    bzero(&zeroAddress, sizeof(zeroAddress));
    zeroAddress.ss_len = sizeof(zeroAddress);
    zeroAddress.ss_family = AF_INET;
    
    // Recover reachability flags
    SCNetworkReachabilityRef defaultRouteReachability = SCNetworkReachabilityCreateWithAddress(NULL, (struct sockaddr *)&zeroAddress);
    SCNetworkReachabilityFlags flags;
    
    //获得连接的标志
    BOOL didRetrieveFlags = SCNetworkReachabilityGetFlags(defaultRouteReachability, &flags);
    CFRelease(defaultRouteReachability);
    
    //如果不能获取连接标志，则不能连接网络，直接返回
    if (!didRetrieveFlags)
    {
        return strNetworkType;
    }
    
    
    if ((flags & kSCNetworkReachabilityFlagsConnectionRequired) == 0)
    {
        // if target host is reachable and no connection is required
        // then we'll assume (for now) that your on Wi-Fi
        strNetworkType = @"WIFI";
    }
    
    if (
        ((flags & kSCNetworkReachabilityFlagsConnectionOnDemand ) != 0) ||
        (flags & kSCNetworkReachabilityFlagsConnectionOnTraffic) != 0
        )
    {
        // ... and the connection is on-demand (or on-traffic) if the
        // calling application is using the CFSocketStream or higher APIs
        if ((flags & kSCNetworkReachabilityFlagsInterventionRequired) == 0)
        {
            // ... and no [user] intervention is needed
            strNetworkType = @"WIFI";
        }
    }
    
    if ((flags & kSCNetworkReachabilityFlagsIsWWAN) == kSCNetworkReachabilityFlagsIsWWAN)
    {
        if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0)
        {
            CTTelephonyNetworkInfo * info = [[CTTelephonyNetworkInfo alloc] init];
            NSString *currentRadioAccessTechnology = info.currentRadioAccessTechnology;
            
            if (currentRadioAccessTechnology)
            {
                if ([currentRadioAccessTechnology isEqualToString:CTRadioAccessTechnologyLTE])
                {
                    strNetworkType =  @"4G";
                }
                else if ([currentRadioAccessTechnology isEqualToString:CTRadioAccessTechnologyEdge] || [currentRadioAccessTechnology isEqualToString:CTRadioAccessTechnologyGPRS])
                {
                    strNetworkType =  @"2G";
                }
                else
                {
                    strNetworkType =  @"3G";
                }
            }
        }
        else
        {
            if((flags & kSCNetworkReachabilityFlagsReachable) == kSCNetworkReachabilityFlagsReachable)
            {
                if ((flags & kSCNetworkReachabilityFlagsTransientConnection) == kSCNetworkReachabilityFlagsTransientConnection)
                {
                    if((flags & kSCNetworkReachabilityFlagsConnectionRequired) == kSCNetworkReachabilityFlagsConnectionRequired)
                    {
                        strNetworkType = @"2G";
                    }
                    else
                    {
                        strNetworkType = @"3G";
                    }
                }
            }
        }
    }
    
    
    if ([strNetworkType isEqualToString:@""]) {
        strNetworkType = @"WWAN";
    }
    
    NSLog( @"GetNetWorkType() strNetworkType :  %@", strNetworkType);
    
    return strNetworkType;
}

#pragma mark -- 拼接 post 请求的网址
- (NSString *)urlDictToStringWithUrlStr:(NSString *)urlStr WithDict:(NSDictionary *)parameters{
    if (!parameters) {
        return urlStr;
    }
    NSMutableArray *parts = [NSMutableArray array];
    [parameters enumerateKeysAndObjectsUsingBlock:^(id key, id<NSObject> obj, BOOL *stop) {
        NSString *encodedKey = [key stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
        NSString *encodedValue = [obj.description stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
        NSString *part = [NSString stringWithFormat: @"%@=%@", encodedKey, encodedValue];
        [parts addObject: part];
    }];
    NSString *queryString = [parts componentsJoinedByString: @"&"];
    queryString =  queryString ? [NSString stringWithFormat:@"?%@", queryString] : @"";
    NSString * pathStr =[NSString stringWithFormat:@"%@%@",urlStr,queryString];
    NSLog(@"pathStr:%@",pathStr);
    return pathStr;
}

@end
