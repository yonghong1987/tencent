//
//  CSPostListModel.m
//  tencent
//
//  Created by admin on 16/5/23.
//  Copyright © 2016年 cyh. All rights reserved.
//

#import "CSPostListModel.h"
#import "NSDictionary+convenience.h"
#import "CSUrl.h"
@implementation CSPostListModel


#pragma mark  重写父类的方法
- (instancetype)initWithDictionary:(NSDictionary *)dict error:(NSError *__autoreleasing *)err
{
    self = [super initWithDictionary:dict error:err];
    if (self) {
        NSArray *images = [dict arrayForKey:@"imgList"];
        self.images = [NSMutableArray array];
        for (NSString *imageString in images) {
            NSString *imageStr = [NSString stringWithFormat:@"%@/%@",BASE_URL_STRING,imageString];
            [self.images addObject:imageStr];
        }
    }
    return self;
}

@end
