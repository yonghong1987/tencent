//
//  CSStudyMapModel.h
//  tencent
//
//  Created by admin on 16/5/16.
//  Copyright © 2016年 cyh. All rights reserved.
//

#import "CSBaseModel.h"

@interface CSStudyMapModel : CSBaseModel

/**
 *  学习地图id
 */
@property (nonatomic, strong) NSNumber *mappId;
/**
 *  学习地图图片
 */
@property (nonatomic, copy) NSString *img;
/**
 *  学习地图描述
 */
@property (nonatomic, copy) NSString *describe;
/**
 *  学习地图标题
 */
@property (nonatomic, copy) NSString *name;
/**
 *  学习地图点赞数
 */
@property (nonatomic, strong) NSNumber *praiseCount;
/**
 *  学习地图浏览数
 */
@property (nonatomic, strong) NSNumber *viewAmount;
/**
 *  学习地图收藏数
 */
@property (nonatomic, strong) NSNumber *commentCount;
/**
 *地图开场动画
 */
@property (nonatomic, copy) NSString *cartoon;
@end
