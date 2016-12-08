//
//  CSCaseDetailCellDataModel.h
//  tencent
//
//  Created by cyh on 16/8/11.
//  Copyright © 2016年 cyh. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "CSGlobalMacro.h"
#import "CSStudyCaseDetailModel.h"
#import "CSSubjectiveAnswerCell.h"
#import "CSRadioAnswerCell.h"
#import "CSMultiselectAnswerCell.h"
#import "CSJudgeCell.h"
#import "CSFillBlankCell.h"
#import "CSAskAndAnswerCell.h"
#import "CSRadioCell.h"
#import "CSMultiselectCell.h"
#import "CSJudgeCell.h"
#import "UITableView+SDAutoTableViewCellHeight.h"
#import "CSFrameConfig.h"
#import "CSJudgeAnswerCell.h"
@interface CSCaseDetailCellDataModel : NSObject<CSGetMultiseStringDelegate>

@property (nonatomic, strong) NSNumber *canAnswer;
//已经作答的案列cell
+ (UITableViewCell *)updateCellForRowWithCaseDetailModel:(CSStudyCaseDetailModel *)caseDetailModel tableView:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath;
//未作答的案列cell
- (UITableViewCell *)updateCellForRowNoAnswerWithCaseDetailModel:(CSStudyCaseDetailModel *)caseDetailModel tableView:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath;

//得到已经作答的案列cell高度
+ (CGFloat)getCellHeightWithCaseDetailModel:(CSStudyCaseDetailModel *)caseDetailModel tableView:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath;
//得到未作答的案列的cell高度
+ (CGFloat)getNoAnswerCellHeightWithCaseDetailModel:(CSStudyCaseDetailModel *)caseDetailModel tableView:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath;
//案列提交单选题时   得到选项id
+ (NSString *)getSingleStringWithTableView:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath;
//案列提交多选与不定项题时   得到选项id
+ (NSString *)getJudgeStringWithTableView:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath;
@end
