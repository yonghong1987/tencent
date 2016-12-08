//
//  CSCommentSourceModel.m
//  tencent
//
//  Created by cyh on 16/8/25.
//  Copyright © 2016年 cyh. All rights reserved.
//

#import "CSCommentSourceModel.h"

@implementation CSCommentSourceModel

-(instancetype)initWithDictionary:(NSDictionary *)dict error:(NSError *__autoreleasing *)err{
    if (self = [super initWithDictionary:dict error:err]) {
        self.type = [dict objectForKey:@"type"];
        if ([self.type isEqualToString:@"S"]) {
            self.commentSourceType = CSCommentSourceSpecialType;
        }else if ([self.type isEqualToString:@"C"]){
        self.commentSourceType = CSCommentSourceCourceType;
        }else if ([self.type isEqualToString:@"N"]){
            self.commentSourceType = CSCommentSourceCaseType;
        }else if ([self.type isEqualToString:@"K"]){
            self.commentSourceType = CSCommentSourceForumType;
        }else if ([self.type isEqualToString:@"M"]){
            self.commentSourceType = CSCommentSourceMapType;
        }
    }
    return self;
}
@end
