//
//  CSBannerModel.m
//  tencent
//
//  Created by admin on 16/5/21.
//  Copyright © 2016年 cyh. All rights reserved.
//

#import "CSBannerModel.h"
#import "NSDictionary+convenience.h"
#import "CSImagePath.h"
@implementation CSBannerModel


#pragma mark  重写父类的方法
- (instancetype)initWithDictionary:(NSDictionary *)dict error:(NSError *__autoreleasing *)err
{
    self = [super initWithDictionary:dict error:err];
    if (self) {
        self.img = [self stringWithJoining:self.img];
//        NSLog(@"img:%@",self.img);
    }
    return self;
}


@end
