//
//  CSCrashModel.m
//  tencent
//
//  Created by admin on 16/5/18.
//  Copyright © 2016年 cyh. All rights reserved.
//

#import "CSCrashModel.h"

@implementation CSCrashModel

-(void)encodeWithCoder:(NSCoder *)aCoder{
    [aCoder encodeObject:self.crashReason forKey:@"crashReason"];
    [aCoder encodeObject:self.crashName forKey:@"crashName"];
    [aCoder encodeObject:self.crashStack forKey:@"crashStack"];
    [aCoder encodeObject:self.deviceSystemVerson forKey:@"deviceSystemVerson"];
    [aCoder encodeObject:self.deviceType forKey:@"deviceType"];
    [aCoder encodeObject:self.crashTime forKey:@"crashTime"];
}

-(instancetype)initWithCoder:(NSCoder *)aDecoder{
    if (self = [super init]) {
        self.crashName = [aDecoder decodeObjectForKey:@"crashName"];
        self.crashReason = [aDecoder decodeObjectForKey:@"crashReason"];
        self.crashStack = [aDecoder decodeObjectForKey:@"crashStack"];
        self.deviceSystemVerson = [aDecoder decodeObjectForKey:@"deviceSystemVerson"];
        self.deviceType = [aDecoder decodeObjectForKey:@"deviceType"];
        self.crashTime = [aDecoder decodeObjectForKey:@"crashTime"];
    }
    return self;
}
@end
