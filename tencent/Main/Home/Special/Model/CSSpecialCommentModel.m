//
//  CSSpecialCommentModel.m
//  tencent
//
//  Created by admin on 16/5/7.
//  Copyright © 2016年 cyh. All rights reserved.
//

#import "CSSpecialCommentModel.h"
#import "NSDictionary+convenience.h"
#import "CSReplyCommentModel.h"
@implementation CSSpecialCommentModel


#pragma mark  重写父类的方法
- (instancetype)initWithDictionary:(NSDictionary *)dict error:(NSError *__autoreleasing *)err
{
    self = [super initWithDictionary:dict error:err];
    if (self) {
        self.commentUserName = [[dict objectForKey:@"user"] objectForKey:@"name"];
    }
    return self;
}


@end
