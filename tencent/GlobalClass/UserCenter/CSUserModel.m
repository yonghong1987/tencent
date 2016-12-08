//
//  CSUserModel.m
//  tencent
//
//  Created by sunon002 on 16/4/16.
//  Copyright © 2016年 cyh. All rights reserved.
//

#import "CSUserModel.h"
#import "NSDictionary+convenience.h"
#import "CSImagePath.h"
@implementation CSUserModel

-(instancetype)initWithDictionary:(NSDictionary *)dict error:(NSError *__autoreleasing *)err{
    if (self = [super initWithDictionary:dict error:err]) {
        self.img = [CSImagePath getImageUrl:[dict stringForKey:@"img"]];
        self.role = [dict stringForKey:@"role"];
        if ([self.role isEqualToString:@"SYSADM"]) {
            self.userRoleType = CSUserRoleSystemType;
        }else if ([self.role isEqualToString:@"EXPERT"]){
        self.userRoleType = CSUserRoleExportType;
        }else if([self.role isEqualToString:@"LRN"]){
         self.userRoleType = CSUserRoleLanType;
        }
    }
    return self;
}

@end
