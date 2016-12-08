//
//  CSTitleListModel.h
//  tencent
//
//  Created by cyh on 16/8/23.
//  Copyright © 2016年 cyh. All rights reserved.
//

#import "CSBaseModel.h"

@interface CSTitleListModel : CSBaseModel
/**
 *该题用户是否做的正确
 */
@property (nonatomic, strong) NSNumber *isCorrect;
/**
 *题目id
 */
@property (nonatomic, strong) NSNumber *questionId;
@end
