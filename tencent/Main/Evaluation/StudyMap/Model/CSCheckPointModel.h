//
//  CSCheckPointModel.h
//  tencent
//
//  Created by cyh on 16/8/3.
//  Copyright © 2016年 cyh. All rights reserved.
//

#import "CSBaseModel.h"

@interface CSCheckPointModel : CSBaseModel
/**
 *关卡是否锁定  是否给图加锁
 */
@property (nonatomic, strong) NSNumber *isLock;
/**
 *关卡是否通关
 */
@property (nonatomic, strong) NSNumber *isCustoms;
/**
 *通关失败的动画
 */
@property (nonatomic, copy) NSString *fcartoon;
/**
 *通关成功的动画
 */
@property (nonatomic, copy) NSString *cartoon;
/**
 *关卡号
 */
@property (nonatomic, strong) NSNumber *tollgateNo;
/**
 *课程id
 */
@property (nonatomic, strong) NSNumber *courseId;
/**
 *关卡背景图
 */
@property (nonatomic, copy) NSString *backgroundImg;
/**
 *关卡名称
 */
@property (nonatomic, copy) NSString *name;
/**
 *关卡id
 */
@property (nonatomic, strong) NSNumber *tollgateId;
@end
