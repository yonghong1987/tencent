//
//  CSQuestionViewController.h
//  tencent
//
//  Created by cyh on 16/8/17.
//  Copyright © 2016年 cyh. All rights reserved.
//

#import "CSBaseViewController.h"
#import "CSRadioModel.h"
@interface CSQuestionViewController : CSBaseViewController
@property (nonatomic, strong) CSRadioModel *radioModel;
/**
 *是否可以作答
 */
@property (nonatomic, strong) NSNumber *canAnswer;
//是否显示答案
@property (nonatomic, strong) NSNumber *displayAnswer;
@end
