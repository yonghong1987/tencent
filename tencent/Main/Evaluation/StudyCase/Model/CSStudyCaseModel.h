//
//  CSStudyCaseModel.h
//  tencent
//
//  Created by admin on 16/5/12.
//  Copyright © 2016年 cyh. All rights reserved.
//

#import "CSBaseModel.h"

@interface CSStudyCaseModel : CSBaseModel

/**
 *  案列id
 */
@property (nonatomic, strong) NSNumber *caseId;
/**
 *  案列图片
 */
@property (nonatomic, copy) NSString *caseImg;
/**
 *  案列名称
 */
@property (nonatomic, copy) NSString *caseName;
/**
 *  案列标签名
 */
@property (nonatomic, copy) NSString *catalogName;
/**
 *  案列修改日期
 */
@property (nonatomic, copy) NSString *modifiedDate;
@end
