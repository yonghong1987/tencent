//
//  CSSpecialParentModel.m
//  tencent
//
//  Created by admin on 16/5/3.
//  Copyright © 2016年 cyh. All rights reserved.
//

#import "CSSpecialParentModel.h"
#import "NSDictionary+convenience.h"
@implementation CSSpecialParentModel

//- (instancetype)initWithSpecialMenuDic:(NSDictionary *)dictionary;{
//    if (self = [super init]) {
//        self.specialMenus = [NSMutableArray array];
//        NSArray *array = [dictionary arrayForKey:@"catalogList"];
//        for (NSDictionary *specialDic in array) {
//            CSSpecialMenuModel *special = [CSSpecialMenuModel new];
//            special.specialMenuid = [NSString stringWithFormat:@"%d",[specialDic intForKey:@"id"]];
//            special.specialMenuName = [specialDic stringForKey:@"name"];
//            [self.specialMenus addObject:special];
//        }
//    }
//    return self;
//}

-(instancetype)initWithDictionary:(NSDictionary *)dict error:(NSError *__autoreleasing *)err{
    if (self = [super initWithDictionary:dict error:err]) {
        
    }
    return self;
}
@end
