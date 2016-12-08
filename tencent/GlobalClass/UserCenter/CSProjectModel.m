//
//  CSProjectModel.m
//  Tencent
//
//  Created by sunon002 on 16/4/21.
//  Copyright © 2016年 cyh. All rights reserved.
//

#import "CSProjectModel.h"
#import "NSDictionary+convenience.h"
#import "CSImagePath.h"
@implementation CSProjectModel

- (id)initWithDictionary:(NSDictionary *)dictionary
{
    if (self = [super init]) {
        self.isAddedInd = [dictionary boolForKey:@"addedInd"];
        self.projectName = [dictionary stringForKey:@"name"];
        self.projectid = [dictionary intForKey:@"id"];
        self.appName = [dictionary stringForKey:@"appName"];
        self.projectImg = [CSImagePath noEncodeingImageUrl:[dictionary stringForKey:@"img"]];
        
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:[NSNumber numberWithBool:self.isAddedInd] forKey:@"isAddedInd"];
    [aCoder encodeObject:[NSNumber numberWithInt:self.projectid] forKey:@"projectid"];
    [aCoder encodeObject:self.projectName forKey:@"projectName"];
    [aCoder encodeObject:self.appName forKey:@"appName"];
    [aCoder encodeObject:self.projectImg forKey:@"projectImg"];
    [aCoder encodeObject:[NSNumber numberWithInt:self.isAll] forKey:@"isAll"];
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super init]) {
        self.isAddedInd = [[aDecoder decodeObjectForKey:@"isAddedInd"] boolValue];
        self.projectid = [[aDecoder decodeObjectForKey:@"projectid"] intValue];
        self.projectName = [aDecoder decodeObjectForKey:@"projectName"];
        self.appName = [aDecoder decodeObjectForKey:@"appName"];
        self.projectImg = [aDecoder decodeObjectForKey:@"projectImg"];
        self.isAll=[[aDecoder decodeObjectForKey:@"isAll"] intValue] ;
    }
    return self;
    
}

@end
