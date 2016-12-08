//
//  CSSpecialParentModel.h
//  tencent
//
//  Created by admin on 16/5/3.
//  Copyright © 2016年 cyh. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CSSpecialMenuModel.h"
#import "CSBaseModel.h"
@interface CSSpecialParentModel : CSBaseModel
/*
 ***专题目录数组
 */
@property (nonatomic ,strong) NSMutableArray *specialMenus;
- (instancetype)initWithSpecialMenuDic:(NSDictionary *)dictionary;

/**
 *父节点id
 */
@property (nonatomic, strong) NSNumber *parentId;
/**
 *目录id
 */
@property (nonatomic, strong) NSNumber *catalogId;
/**
 *目录名称
 */
@property (nonatomic, copy) NSString *name;
@end
