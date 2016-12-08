//
//  CSUtilFunction.m
//  tencent
//
//  Created by bill on 16/5/4.
//  Copyright © 2016年 cyh. All rights reserved.
//

#import "CSUtilFunction.h"
#import "AppDelegate.h"

@implementation CSUtilFunction


+(BOOL)isNotNiLString:(NSString*)str
{
    //return ((NSNull*)str!=[NSNull null])&&str&&![str isEqualToString:@"<null>"] && ([str length] > 0);
    if((NSNull *)str != [NSNull null])
    {
        if(str && str.length > 0)
        {
            if(![str isEqualToString:@"<null>"] && ![str isEqualToString:@"null"])
            {
                return YES;
            }
        }
    }
    return NO;
}



+ (UINavigationController *)getCurrentRootNavigationController{
    AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    UITabBarController *tabBar = (UITabBarController *)delegate.window.rootViewController;
    return tabBar.selectedViewController;
}


+ (NSNumber *)stringToNumber:(NSString *)convertStr{
    NSScanner* scan = [NSScanner scannerWithString:convertStr];
    int val;
    
    if( [scan scanInt:&val] && [scan isAtEnd] ){
        NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
        return [numberFormatter numberFromString:convertStr];
    }else{
        return nil;
    }
}

+ (NSString *)numberToString:(NSNumber *)convertNum{
    NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
    return [numberFormatter stringFromNumber:convertNum];
}
@end
