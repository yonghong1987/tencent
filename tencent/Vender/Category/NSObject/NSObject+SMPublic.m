//
//  NSObject+SMPublic.m
//  sunMobile
//
//  Created by duck on 16/6/25.
//  Copyright © 2016年 www.sunontalent.com. All rights reserved.
//

#import "NSObject+SMPublic.h"
#import <UIKit/UIKit.h>
#import "sys/utsname.h"
@implementation NSObject (SMPublic)



+ (CGFloat)diskOfAllSizeMBytes{
    
    CGFloat size = 0;
    NSError * error;
    NSDictionary * dic =[[NSFileManager defaultManager]attributesOfFileSystemForPath:NSHomeDirectory() error:&error];
    
    if (error) {
#ifdef DEBUG
        NSLog(@"error = %@",error.localizedDescription);
#endif
    }else{
        NSNumber * number = dic[NSFileSystemSize];
        size = [number floatValue]/1024/1024;
    }
    return size;
}


+ (CGFloat)diskOfFreeSizeMyytes{
    
    CGFloat size = 0;
    NSError * error;
    NSDictionary * dic =[[NSFileManager defaultManager]attributesOfFileSystemForPath:NSHomeDirectory() error:&error];
    
    if (error) {
#ifdef DEBUG
        NSLog(@"error = %@",error.localizedDescription);
#endif
    }else{
        NSNumber * number = dic[NSFileSystemFreeSize];
        size = [number floatValue]/1024/1024;
    }
    return size;
}

+ (long long)fileSizeAtpath:(NSString * )filePath{
    NSFileManager * fileManger = [NSFileManager defaultManager];
    if (![fileManger  fileExistsAtPath:filePath])
        return 0;
    NSEnumerator * fileEnumerator = [[fileManger subpathsAtPath:filePath] objectEnumerator];
    NSString * fileName;
    long long fileSize;
    while ((fileName = [fileEnumerator nextObject]) != nil) {
        NSString * path  = [filePath stringByAppendingPathComponent:fileName];
        fileSize += [self fileSizeAtpath:path];
    }
    return fileSize;
    
}

+ (NSString*)deviceVersion{
    struct utsname systemInfo;
    uname(&systemInfo);
    NSString *deviceString = [NSString stringWithCString:systemInfo.machine encoding:NSUTF8StringEncoding];
    return deviceString;
}
@end
