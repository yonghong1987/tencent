//
//  SMGlobalApi.m
//  sunMobile
//
//  Created by duck on 16/4/19.
//  Copyright © 2016年 www.sunontalent.com. All rights reserved.
//

#import "SMGlobalApi.h"
#pragma mark - SMGlobalApi -- 华丽分割线
@implementation SMGlobalApi
- (NSString *)globalTargetType:(SMGlobalApiType)type{
    NSString * targetType = nil;
    
    switch (type) {
        case SMGlobalApiTypeCircle:
            targetType = @"D";
            break;
        case SMGlobalApiTypeCourse:
            targetType = @"C";
            break;
        case SMGlobalApiTypeKnowledge:
            targetType = @"K";
            break;
        case SMGlobalApiTypeNotes:
            targetType = @"N";
            break;
        case SMGlobalApiTypeProblem:
            targetType = @"Q";
            break;
        case SMGlobalApiTypeConsult:
            targetType = @"I";
            break;
        case SMGlobalApiTypePople:
            targetType = @"P";
            break;
        case SMGlobalApiTypeComments:
            targetType = @"M";
            break;
        case SMGlobalApiTypeShare:
            targetType = @"S";
            break;
        case SMGlobalApiTypeGroupTopic:
            targetType = @"T";
            break;
        case SMGlobalApiTypeGroupReply:
            targetType = @"R";
            break;
            
         //后面添加
        case SMGlobalApiCommentPraise:
            targetType = @"P";
            break;
        case SMGlobalApiCoursePraise:
            targetType = @"C";
            break;
        case SMGlobalApiSpecialPraise:
            targetType = @"S";
            break;
        case SMGlobalApiCheckPointCollect:
            targetType = @"T";
            break;
        case SMGlobalApiCourseCollect:
            targetType = @"C";
            break;
        case SMGlobalApiSpecialCollect:
            targetType = @"S";
            break;
        default:
            targetType = @"";
            break;
    }
    return targetType;
}
@end

#pragma mark - 点赞 -- 华丽分割线
@implementation SMClickGlobaPraise

- (void)startWithPraiseId:(NSNumber *)praiseId completionBlockWithSuccess:(SMRequestSuccessBlock)success withFailure:(SMRequestFailureBlock)failure{
    if ([praiseId integerValue] > 0) {
         self.requestArgument = @{@"targetType":[self globalTargetType:self.targetType],@"targetId":self.targetId,@"praiseId":praiseId};
    }else{
    self.requestArgument = @{@"targetType":[self globalTargetType:self.targetType],@"targetId":self.targetId};
    }
    self.requestUrl = CLICK_PRAISE;
    [super startWithCompletionBlockWithSuccess:success withFailure:failure];
}

@end

#pragma mark - 获取收藏列表 -- 华丽分割线
@implementation SMGetGlobalCollectList

- (void)startWithCompletionBlockWithSuccess:(SMRequestSuccessBlock)success withFailure:(SMRequestFailureBlock)failure{
    
    NSString * targetType = [self globalTargetType:self.targetType];
    self.requestArgument = @{@"targetType":targetType};
//    self.requestUrl = URL_GLOBAL_GET_COLLECTION;
    [super startWithCompletionBlockWithSuccess:success withFailure:failure];
    
}
@end

#pragma mark - 收藏 -- 华丽分割线
@implementation  SMGlobalCollect
- (void)startWithCollectId:(NSNumber *)collectId completionBlockWithSuccess:(SMRequestSuccessBlock)success withFailure:(SMRequestFailureBlock)failure{
    
    NSString * targetType = [self globalTargetType:self.targetType];
    if ([collectId integerValue] > 0) {
         self.requestUrl = DELETE_GLOBAL_COLLECT;
        self.requestArgument = @{@"targetType":targetType,
                                 @"targetId":self.targetId,@"collectId":collectId};
    }else{
        self.requestUrl =  SAVE_GLOBAL_COLLECT;
        self.requestArgument = @{@"targetType":targetType,@"targetId":self.targetId,@"title":self.titleString};
    }
    [super startWithCompletionBlockWithSuccess:success withFailure:failure];
}

@end
#pragma mark - 评论 -- 华丽分割线
@implementation   SMGlobalComment

- (void)startWithCompletionBlockWithSuccess:(SMRequestSuccessBlock)success withFailure:(SMRequestFailureBlock)failure{
    
    NSString * targetType = [self globalTargetType:self.targetType];
    
    if ([self.rootparentid integerValue] == 0) {
        self.requestArgument = @{@"targetType":targetType,
                                 @"targetId":self.targetId,
                                 @"content":self.content
                                 };
    }else{
        self.requestArgument = @{@"targetType":targetType,
                                 @"targetId":self.targetId,
                                 @"parentUserId":self.becommentuserid,
                                 @"parentId":self.parentid,
                                 @"content":self.content,
                                 @"rootId":self.rootparentid
                                 };
    }
//    self.requestUrl = URL_GLOBAL_COMMENT_REPLY;
    [super startWithCompletionBlockWithSuccess:success withFailure:failure];
    
}
@end
#pragma mark - 添加标签 -- 华丽分割线
@implementation  SMGlobalAddTagCollect
- (void)startWithCompletionBlockWithSuccess:(SMRequestSuccessBlock)success withFailure:(SMRequestFailureBlock)failure{
    

    self.requestArgument = @{@"collectId":self.collectId,@"tagName":self.tagName};
//    self.requestUrl = URL_ADD_TAG;
    [super startWithCompletionBlockWithSuccess:success withFailure:failure];
    
}
@end


#pragma mark - 删除标签 -- 华丽分割线
@implementation  SMGlobalDeleteTagCollect
- (void)startWithCompletionBlockWithSuccess:(SMRequestSuccessBlock)success withFailure:(SMRequestFailureBlock)failure{
    
    self.requestArgument = @{@"tagId":self.tagId};
//    self.requestUrl = URL_DELETE_TAG;
    [super startWithCompletionBlockWithSuccess:success withFailure:failure];
    
}
@end
#pragma mark - 分享动态 -- 华丽分割线
@implementation SMGlobalShare

- (void)startWithCompletionBlockWithSuccess:(SMRequestSuccessBlock)success withFailure:(SMRequestFailureBlock)failure withProgressBlock:(ProgressBlock)progressBlock{
    
    if (!self.alreadyShare) {
        
        NSMutableDictionary * atgument = [NSMutableDictionary dictionary];
        
        if (self.content.length>0) {
            [atgument setObject:self.content forKey:@"content"];
        }
        if (self.targetType != SMGlobalApiTypeDefault) {
            NSString * targetType = [self globalTargetType:self.targetType];
            [atgument setObject:targetType forKey:@"targetType"];
        }
        
        if (self.targetId) {
            [atgument setObject:self.targetId forKey:@"targetId"];
        }
        
        self.requestArgument = atgument;
//        self.requestUrl = URL_SAVE_SHARE;
    }else{

        self.requestArgument = @{@"shareId": self.targetId};
//        self.requestUrl = URL_CANCEL_SHARE;
    }
    
    [super startWithCompletionBlockWithSuccess:success withFailure:failure withProgressBlock:progressBlock];
}

@end
