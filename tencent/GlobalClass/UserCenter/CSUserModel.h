//
//  CSUserModel.h
//  tencent
//
//  Created by sunon002 on 16/4/16.
//  Copyright © 2016年 cyh. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JSONModel.h"
#import "CSBaseModel.h"
@interface CSUserModel : CSBaseModel

typedef NS_ENUM(NSInteger ,CSUserRoleType){
    CSUserRoleSystemType,
    CSUserRoleExportType,
    CSUserRoleLanType,
};

/*
 **用户id
 */
@property (nonatomic, strong) NSNumber *userId;
/*
 **用户名
 */
@property (nonatomic, copy) NSString *name;
/*
 **用户头像
 */
@property (nonatomic, copy) NSString *img;
/*
 **用户登录名
 */
@property (nonatomic, copy) NSString *loginName;
/*
 **用户昵称
 */
@property (nonatomic, copy) NSString *nickName;
/*
 **用户名
 */
@property (nonatomic, copy) NSString *userName;
/*
 **用户性别
 */
@property (nonatomic, copy) NSString *sex;
/*
 **用户部门
 */
@property (nonatomic, copy) NSString *department;
/*
 **用户角色
 */
@property (nonatomic, copy) NSString *role;
/**
 *用户岗位
 */
@property (nonatomic, copy) NSString *post;

@property (nonatomic, assign) CSUserRoleType userRoleType;
@end
