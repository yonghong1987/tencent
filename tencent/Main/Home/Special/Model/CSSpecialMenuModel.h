//
//  CSSpecialMenuModel.h
//  tencent
//
//  Created by admin on 16/5/3.
//  Copyright © 2016年 cyh. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CSBaseModel.h"
@interface CSSpecialMenuModel : CSBaseModel
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
