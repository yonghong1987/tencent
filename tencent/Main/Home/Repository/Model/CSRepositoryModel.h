//
//  CSRepositoryModel.h
//  tencent
//
//  Created by bill on 16/4/27.
//  Copyright © 2016年 cyh. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JSONModel.h"
#import "CSBaseModel.h"

@interface CSRepositoryModel : CSBaseModel

/**
 *  目录Id
 */
@property (strong, nonatomic) NSNumber *catalogId;

/**
 *  1:是父节点，有子目录；0：没有子目录 
 */
@property (strong, nonatomic) NSNumber *isParent;
/**
 *  目录名字
 */
@property (strong, nonatomic) NSString *name;

/**
 *  目录封面图片
 */
@property (strong, nonatomic) NSString *img;

/**
 *  是否有更新 : 0 表示无更新 1 表示有更新
 */
@property (strong, nonatomic) NSNumber *isUpdate;


@end
