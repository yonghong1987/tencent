//
//  CSSubjectiveAnswerCell.h
//  tencent
//
//  Created by cyh on 16/8/10.
//  Copyright © 2016年 cyh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CSStudyCaseDetailModel.h"
#import "CSRadioModel.h"
@interface CSSubjectiveAnswerCell : UITableViewCell

//答案提示label
@property (nonatomic, strong) UILabel *answerPromptLabel;
//答案label
@property (nonatomic, strong) UILabel *answerLabel;

@property (nonatomic, strong) CSStudyCaseDetailModel *caseDetailModel;
/**
 *是否可以作答
 */
@property (nonatomic, strong) NSNumber *canAnswer;
@property (nonatomic, strong) CSRadioModel *radioModel;

@property (nonatomic, assign) NSInteger section;

@end
