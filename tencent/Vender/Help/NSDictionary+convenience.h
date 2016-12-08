//
//  NSDictionary+convenience.h
//  eLearning
//
//  Created by sunon on 14-6-5.
//  Copyright (c) 2014年 sunon. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface NSDictionary (convenience)
-(int)intForKey:(NSString *)key;
-(NSInteger)integerForKey:(NSString *)key;
-(CGFloat)floatForKey:(NSString *)key;
-(NSNumber *)numberForKey:(NSString *)key;
-(NSString *)stringForKey:(NSString *)key;
-(NSString *)strForKey:(NSString *)key;
-(BOOL)boolForKey:(NSString *)key;
-(NSDate *)dateForKey:(NSString *)key;
-(NSDictionary *)dictForKey:(NSString *)key;
-(NSArray *)arrayForKey:(NSString *)key;
@end
