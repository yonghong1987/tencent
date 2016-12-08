//
//  CSAskAndAnswerCell.h
//  tencent
//
//  Created by cyh on 16/7/27.
//  Copyright © 2016年 cyh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XHMessageTextView.h"
#import "CSRadioModel.h"

@interface CSAskAndAnswerCell : UITableViewCell
@property (nonatomic, strong) XHMessageTextView *textView;
@property (nonatomic, copy) NSString *textString;
@property (nonatomic, copy) void (^hideBackViewAction)();
/**
 *是否可以作答
 */
@property (nonatomic, strong) NSNumber *canAnswer;
@property (nonatomic, strong) CSRadioModel *radioModel;
@end
