//
//  CSArgumentUserModel.h
//  Tencent
//
//  Created by bill on 16/4/20.
//  Copyright © 2016年 cyh. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CSArgumentUserModel : NSObject

/**
 *  显示的昵称
 */
@property (nonatomic, strong) NSString *name;


/**
 *  评论人Id
 */
@property (nonatomic, strong) NSNumber *userId;


/**
 *  评论人角色
 */
@property (nonatomic, strong) NSString *role;


/**
 *  初始化Model
 *
 *  @param dic 服务端返回的Json
 *
 *  @return Model实例
 */
- (id)initWithDictionary:(NSDictionary *)dic;

@end
