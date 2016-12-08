//
//  CSBaseModel.m
//  tencent
//
//  Created by admin on 16/5/20.
//  Copyright © 2016年 cyh. All rights reserved.
//

#import "CSBaseModel.h"
#import "YTKNetworkConfig.h"

@implementation CSBaseModel



+(BOOL)propertyIsOptional:(NSString *)propertyName{
    return YES;
}

#pragma mark  重写父类的方法
- (instancetype)initWithDictionary:(NSDictionary *)dict error:(NSError *__autoreleasing *)err
{
    self = [super initWithDictionary:dict error:err];
    if (self) {
                
    }
    return self;
}


- (NSString *)stringWithJoining:(NSString *)string{
    YTKNetworkConfig *config = [YTKNetworkConfig sharedInstance];
    if (![string hasPrefix:@"http"]) {
        string = [NSString stringWithFormat:@"%@/%@",config.baseUrl,string];
    }
    return string;
}
@end
