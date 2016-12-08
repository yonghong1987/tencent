//
//  CSHotTagsListModel.h
//  tencent
//
//  Created by bill on 16/4/28.
//  Copyright © 2016年 cyh. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CSBaseModel.h"
#import "JSONModel.h"

@interface CSHotTagsListModel : CSBaseModel

/**
 *   标签Id
 */
@property (nonatomic, strong) NSNumber *specialId;

/**
 *  标签封面图片
 */
@property (nonatomic, strong) NSString *img;

/**
 *  标签内容
 */
@property (nonatomic, strong) NSNumber *activityNum;


/**
 *  标签名
 */
@property (nonatomic, strong) NSString *name;

/**
 *  标签浏览数
 */
@property (nonatomic, strong) NSNumber *viewAmount;


@end
