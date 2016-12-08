//
//  CSArgumentUserModel.m
//  Tencent
//
//  Created by bill on 16/4/20.
//  Copyright © 2016年 cyh. All rights reserved.
//

#import "CSArgumentUserModel.h"
#import "NSDictionary+convenience.h"

@implementation CSArgumentUserModel

- (id)initWithDictionary:(NSDictionary *)dic{
    
    self = [super init];
    
    if ( self ) {
        self.name = [dic stringForKey:@"name"];
        self.userId = [dic numberForKey:@"id"];
        self.role = [dic stringForKey:@"role"];
    }
    return self;
}


@end
