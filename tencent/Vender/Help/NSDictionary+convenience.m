//
//  NSDictionary+convenience.m
//  eLearning
//
//  Created by sunon on 14-6-5.
//  Copyright (c) 2014年 sunon. All rights reserved.
//

#import "NSDictionary+convenience.h"

@implementation NSDictionary (convenience)
-(int)intForKey:(NSString *)key
{
    id obj=[self objectForKey:key];
    if ([obj isKindOfClass:[NSNumber class]]||[obj isKindOfClass:[NSString class]]) {
        return [obj intValue];
    }
    return -1;
}
-(NSInteger)integerForKey:(NSString *)key
{
    id obj=[self objectForKey:key];
    if ([obj isKindOfClass:[NSNumber class]]||[obj isKindOfClass:[NSString class]]) {
        return [obj integerValue];
    }
    return 0;
}
-(CGFloat)floatForKey:(NSString *)key
{
    id obj=[self objectForKey:key];
    if ([obj isKindOfClass:[NSNumber class]]||[obj isKindOfClass:[NSString class]]) {
        return [obj floatValue];
    }
    return 0.0;
}
-(NSNumber *)numberForKey:(NSString *)key
{
    id obj=[self objectForKey:key];
    if ([obj isKindOfClass:[NSNumber class]]) {
        return obj;
    }
    return nil;
}
-(NSString *)stringForKey:(NSString *)key
{
    id obj=[self objectForKey:key];
    if ([obj isKindOfClass:[NSString class]]) {
        return obj;
    }else if([obj isKindOfClass:[NSNumber class]]){
        return [obj stringValue];
    }else if ([obj isEqual:[NSNull null]]){
        
      return nil;
    }else if (obj  == nil){
    return nil;
    }
    return @"";
}
-(NSString *)strForKey:(NSString *)key
{
    id obj=[self objectForKey:key];
    if ([obj isKindOfClass:[NSString class]]) {
        return obj;
    }else if([obj isKindOfClass:[NSNumber class]]){
        return [obj stringValue];
    }
    return @"";
}
-(BOOL)boolForKey:(NSString *)key
{
    id obj=[self objectForKey:key];
    if ([obj isKindOfClass:[NSNumber class]]||[obj isKindOfClass:[NSString class]]) {
        return [obj boolValue];
    }
    return 0;
}
-(NSDate *)dateForKey:(NSString *)key
{
    id obj=[self objectForKey:key];
    if ([obj isKindOfClass:[NSDate class]]) {
        return obj;
    }
    return [NSDate date];
}
-(NSDictionary *)dictForKey:(NSString *)key
{
    id obj=[self objectForKey:key];
    if ([obj isKindOfClass:[NSDictionary class]]) {
        return obj;
    }
    return nil;
}
-(NSArray *)arrayForKey:(NSString *)key
{
    id obj=[self objectForKey:key];
    if ([obj isKindOfClass:[NSArray class]]) {
        return obj;
    }
    return nil;
}
@end
