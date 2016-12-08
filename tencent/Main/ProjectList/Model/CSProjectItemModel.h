//
//  CSProjectItemModel.h
//  tencent
//
//  Created by bill on 16/7/29.
//  Copyright © 2016年 cyh. All rights reserved.
//

#import "CSBaseModel.h"

@interface CSProjectItemModel : CSBaseModel

@property (nonatomic, strong) NSString *appName;

@property (nonatomic, strong) NSNumber *projectId;

@property (nonatomic, strong) NSString *name;
/**
 *  项目图片
 */
@property (nonatomic, strong) NSString *img;

/**
 *  是否常用项目 （1，是；0，不是）
 */
@property (nonatomic, strong) NSNumber *addedInd;

@end
