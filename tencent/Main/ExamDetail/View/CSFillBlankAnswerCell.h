//
//  CSFillBlankAnswerCell.h
//  tencent
//
//  Created by cyh on 16/8/24.
//  Copyright © 2016年 cyh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CSOptionModel.h"
@interface CSFillBlankAnswerCell : UITableViewCell
@property (nonatomic, strong) UILabel *fillPromptLabel;
@property (nonatomic, strong) UILabel *contentLabel;
@property (nonatomic, strong) CSOptionModel *radioModel;
@end
