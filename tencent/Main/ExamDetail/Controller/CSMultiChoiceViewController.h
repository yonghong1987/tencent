//
//  CSMultiChoiceViewController.h
//  TXHDemo
//
//  Created by bill on 16/5/18.
//  Copyright © 2016年 Bill. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CSBaseViewController.h"
#import "CSRadioModel.h"
@interface CSMultiChoiceViewController : CSBaseViewController
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
