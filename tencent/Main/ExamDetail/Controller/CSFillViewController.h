//
//  CSFillViewController.h
//  tencent
//
//  Created by cyh on 16/8/17.
//  Copyright © 2016年 cyh. All rights reserved.
//

#import "CSBaseViewController.h"
#import "CSRadioModel.h"
@interface CSFillViewController : CSBaseViewController
@property (nonatomic, strong) CSRadioModel *radioModel;
/**
 *是否可以作答
 */
@property (nonatomic, strong) NSNumber *canAnswer;
/**
 *试卷拥有的试题数目
 */
@property (nonatomic, assign) NSInteger titleCount;
/**
 *该填空在试卷中的顺序（在第几题）
 */
@property (nonatomic, assign) NSInteger titleTag;
@end
