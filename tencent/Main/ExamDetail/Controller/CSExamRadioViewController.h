//
//  CSExamRadioViewController.h
//  tencent
//
//  Created by admin on 16/5/19.
//  Copyright © 2016年 cyh. All rights reserved.
//

#import "CSBaseViewController.h"
#import "CSRadioModel.h"
@interface CSExamRadioViewController : CSBaseViewController
@property (nonatomic, strong) CSRadioModel *radioModel;
/**
 *是否可以作答
 */
@property (nonatomic, strong) NSNumber *canAnswer;
/**
 *是否显示正确答案
 */
@property (nonatomic, strong) NSNumber *displayAnswer;
@end
