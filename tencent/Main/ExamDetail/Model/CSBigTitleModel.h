//
//  CSBigTitleModel.h
//  tencent
//
//  Created by cyh on 16/8/16.
//  Copyright © 2016年 cyh. All rights reserved.
//

#import "CSBaseModel.h"

@interface CSBigTitleModel : CSBaseModel
/**
 *大题标题
 */
@property (nonatomic, copy) NSString *categoryTitle;
/**
 *大题类型
 */
@property (nonatomic, copy) NSString *categoryType;
/**
 *是否显示大题标题
 */
@property (nonatomic, strong) NSNumber *displayTitle;
/**
 *大题id
 */
@property (nonatomic, strong) NSNumber *categoryId;
/**
 *每个大题包含的小题数组
 */
@property (nonatomic, strong) NSMutableArray *smallTitleArray;
@end
