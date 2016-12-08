//
//  SMBaseNetworkApi.m
//  sunMobile
//
//  Created by duck on 16/3/21.
//  Copyright © 2016年 www.sunontalent.com. All rights reserved.
//

#import "SMBaseNetworkApi.h"
#import "MBProgressHUD+SMHUD.h"
#import "AppDelegate+Category.h"
#import "UIApplication+SMAppDelegate.h"
#if DEBUG
#import "NSDictionary+URL.h"
#import "YTKUrlArgumentsFilter.h"
#endif
#import "YTKNetworkConfig.h"
#import "CSUserDefaults.h"
@implementation SMBaseNetworkApi

#pragma mark - 初始化对象
+ (instancetype)new{
    return [[SMBaseNetworkApi  alloc]init];
}

- (instancetype)init
{

    self = [super init];
    if (self) {
        self.requestMethod = YTKRequestMethodPost;
    }
    return self;
}

#pragma mark - 以下是重写父类方法
- (YTKRequestMethod)requestMethod {
    return _requestMethod;
}

- (NSString *)requestUrl{
    return _requestUrl;
}

- (id )requestArgument{
    return _requestArgument;
}



- (void)startWithCompletionBlockWithSuccess:(SMRequestSuccessBlock)success withFailure:(SMRequestFailureBlock)failure{

    @try {
        
        
#if DEBUG
        
        YTKNetworkConfig *config = [YTKNetworkConfig sharedInstance];
        NSLog(@"\nrequestArgument = \n%@",_requestArgument);
        NSLog(@"\n<URL = %@%@?%@&token=%@ >",config.baseUrl,_requestUrl,[_requestArgument URLQueryString],[[CSUserDefaults shareUserDefault] getUserToken]);
        
#endif
        [self startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest *request) {
            
            NSError * error = nil;
            id responseJSONObject;
            if (request.responseData) {
                responseJSONObject = [NSJSONSerialization JSONObjectWithData:request.responseData options:NSJSONReadingMutableContainers error:&error];
            }
//            id responseJSONObject = [NSJSONSerialization JSONObjectWithData:request.responseData options:NSJSONReadingMutableContainers error:&error];
            if (!error) {
                
#if DEBUG       

                NSLog(@"\nresponseJSONObject = \n%@",responseJSONObject);
#endif
                NSInteger responseCode =  [[responseJSONObject objectForKey:@"code"] integerValue];
                
                if (responseCode != 0) {
                    
//                    [MBProgressHUD showToView:[UIApplication sharedAppDelegate].window text:responseJSONObject[@"codedesc"] afterDelay:2 hideBlock:^(MBProgressHUD * _Nonnull hud ) {
//                        
//                    }];

                    if (responseCode == -108 || responseCode == -107 || responseCode == -106) {
                        [[AppDelegate sharedInstance] enterLoginVC];
                    }
                }
                
                success(responseJSONObject,responseCode);
            }else{
//                [MBProgressHUD showToView:[UIApplication sharedAppDelegate].window text:[NSString stringWithFormat:@"%@",request.requestOperation.error] afterDelay:2 hideBlock:^(MBProgressHUD * _Nonnull hud ) {
//                    
//                }];
                failure(error);
            }
        } failure:^(__kindof YTKBaseRequest *request) {
             NSLog(@"===%@",request.requestOperation.error);
            
//            [MBProgressHUD showToView:[UIApplication sharedAppDelegate].window text:[NSString stringWithFormat:@"%@",request.requestOperation.error] afterDelay:2 hideBlock:^(MBProgressHUD * _Nonnull hud ) {
//                
//            }];
            
            failure(request.requestOperation.error);
        }];

    }
    @catch (NSException *exception) {
        NSError * error  = [NSError errorWithDomain:exception.reason code:SMResponseCode900 userInfo:exception.userInfo];
        failure(error);
         NSLog(@"%@",error);
    }
    @finally {
        
    }
    
}
@end
