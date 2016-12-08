//
//  CSCaseDetailCellDataModel.m
//  tencent
//
//  Created by cyh on 16/8/11.
//  Copyright © 2016年 cyh. All rights reserved.
//

#import "CSCaseDetailCellDataModel.h"
#import "CSConfig.h"
@implementation CSCaseDetailCellDataModel

+ (UITableViewCell*)updateCellForRowWithCaseDetailModel:(CSStudyCaseDetailModel *)caseDetailModel tableView:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath{
    NSString *answerCellIdentifier = @"answerCell";
    NSString *radioAnswerCellIdentifier = @"radioAnswerCell";
    NSString *multiselectAnswerCellIdentifier = @"multiselectAnswerCell";
    NSString *judgeAnswerCellIdentifier = @"judgeAnswerCell";
    NSString *fillBlankCellIdentifier = @"fillBlankCell";
    //显示选项内容或者填的空
    //如果是问答题
    if ([caseDetailModel.caseQuestionType isEqualToString:kTopicQuestionType]) {
        CSSubjectiveAnswerCell *cell = [tableView dequeueReusableCellWithIdentifier:answerCellIdentifier];
        cell.answerLabel.text = caseDetailModel.userAnswer;
        cell.answerPromptLabel.text = @"我的回答：";
        return cell;
    }else{//如果不是问答题
        //如果是单选题
        if ([caseDetailModel.caseQuestionType isEqualToString:kTopicSingleType]) {
            CSRadioAnswerCell *cell = [tableView dequeueReusableCellWithIdentifier:radioAnswerCellIdentifier];
            cell.optionTextLabel.textColor = [UIColor blackColor];
            cell.optionModel = caseDetailModel.optionArray[indexPath.row];
            return cell;
            //如果是不定项选择或者多项选择题
        }else if ([caseDetailModel.caseQuestionType isEqualToString:kTopicNoItemType] || [caseDetailModel.caseQuestionType isEqualToString:kTopicMultiSelectType]){
            CSMultiselectAnswerCell *cell = [tableView dequeueReusableCellWithIdentifier:multiselectAnswerCellIdentifier];
            cell.optionTextLabel.textColor = [UIColor blackColor];
            cell.optionImg.image = [UIImage imageNamed:@"rounded-rectangle"];
            cell.optionModel = caseDetailModel.optionArray[indexPath.row];
            return cell;
            //如果是判断题
        }else if ([caseDetailModel.caseQuestionType isEqualToString:kTopicJudgeType]){
            CSJudgeAnswerCell *cell = [tableView dequeueReusableCellWithIdentifier:judgeAnswerCellIdentifier];
             cell.optionTextLabel.textColor = [UIColor blackColor];
             cell.optionImg.image = [UIImage imageNamed:@"rounded-rectangle"];
             cell.optionModel = caseDetailModel.optionArray[indexPath.row];
            return cell;
            //如果是填空题
        }else if ([caseDetailModel.caseQuestionType isEqualToString:kTopicFillType]){
            CSFillBlankCell *cell = [tableView dequeueReusableCellWithIdentifier:fillBlankCellIdentifier];
            return cell;
        }
    }
    return 0;
}

- (UITableViewCell *)updateCellForRowNoAnswerWithCaseDetailModel:(CSStudyCaseDetailModel *)caseDetailModel tableView:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath{
    NSString *askAndAnswerCellIdentifier = @"askAndAnswerCell";
    NSString *radioCellIdentifier = @"radioCell";
    NSString *multiselectCellIdentifier = @"multiselectCell";
    NSString *judgeCellIdentifier = @"judgeCell";
    
    if ([caseDetailModel.caseQuestionType isEqualToString:kTopicQuestionType]) {
        CSAskAndAnswerCell *cell = [tableView dequeueReusableCellWithIdentifier:askAndAnswerCellIdentifier];
        return cell;
    }else{//如果不是问答题
        //如果是单选题
        if ([caseDetailModel.caseQuestionType isEqualToString:kTopicSingleType]) {
            CSRadioCell *cell = [tableView dequeueReusableCellWithIdentifier:radioCellIdentifier];
            cell.canAnswer = self.canAnswer;
            cell.optionModel = caseDetailModel.optionArray[indexPath.row];
            NSLog(@"seleted:%d vrowrow:%d",cell.optionModel.isSelected,indexPath.row);
            return cell;
            //如果是不定项选择或者如果是多项选择
        }else if ([caseDetailModel.caseQuestionType isEqualToString:kTopicNoItemType] || [caseDetailModel.caseQuestionType isEqualToString:kTopicMultiSelectType]){
            CSMultiselectCell *cell = [tableView dequeueReusableCellWithIdentifier:multiselectCellIdentifier];
            cell.delega = self;
            cell.optionModel = caseDetailModel.optionArray[indexPath.row];
            return cell;
            //如果是判断题
        }else if ([caseDetailModel.caseQuestionType isEqualToString:kTopicJudgeType]){
            CSJudgeCell *cell = [tableView dequeueReusableCellWithIdentifier:judgeCellIdentifier];
            cell.optionModel = caseDetailModel.optionArray[indexPath.row];
            return cell;
            //如果是填空题
        }else if ([caseDetailModel.caseQuestionType isEqualToString:kTopicFillType]){
            
        }
    }
    return 0;
}

+ (CGFloat)getCellHeightWithCaseDetailModel:(CSStudyCaseDetailModel *)caseDetailModel tableView:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath{
    //问答题
    if ([caseDetailModel.caseQuestionType isEqualToString:kTopicQuestionType]) {
        CGFloat height = 80;
        CGSize size = CGSizeMake(kCSScreenWidth - 20 , 2000);
        CGSize labelSize = [caseDetailModel.userAnswer sizeWithFont:[UIFont systemFontOfSize:14] constrainedToSize:size lineBreakMode:NSLineBreakByWordWrapping];
        height += labelSize.height;
        
        return height;
        //其他  单选
    }else if ([caseDetailModel.caseQuestionType isEqualToString:kTopicSingleType]){
        CSOptionModel *optionModel = caseDetailModel.optionArray[indexPath.row];
        return [tableView cellHeightForIndexPath:indexPath model:optionModel keyPath:@"optionModel" cellClass:[CSRadioAnswerCell class] contentViewWidth:kCSScreenWidth];
        //判断题
    }else if ([caseDetailModel.caseQuestionType isEqualToString:kTopicJudgeType]){
        CSOptionModel *optionModel = caseDetailModel.optionArray[indexPath.row];
        return [tableView cellHeightForIndexPath:indexPath model:optionModel keyPath:@"optionModel" cellClass:[CSJudgeAnswerCell class] contentViewWidth:kCSScreenWidth];
        //多选与不定项选择
    }else if ([caseDetailModel.caseQuestionType isEqualToString:kTopicMultiSelectType] ||[caseDetailModel.caseQuestionType isEqualToString:kTopicNoItemType]){
        CSOptionModel *optionModel = caseDetailModel.optionArray[indexPath.row];
        return [tableView cellHeightForIndexPath:indexPath model:optionModel keyPath:@"optionModel" cellClass:[CSMultiselectAnswerCell class] contentViewWidth:kCSScreenWidth];
    }
    return 0;
}

+ (CGFloat)getNoAnswerCellHeightWithCaseDetailModel:(CSStudyCaseDetailModel *)caseDetailModel tableView:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath{
    if ([caseDetailModel.caseQuestionType isEqualToString:kTopicQuestionType]) {
        return 220;
        //单选
    }else if ([caseDetailModel.caseQuestionType isEqualToString:kTopicSingleType]){
        CSOptionModel *optionModel = caseDetailModel.optionArray[indexPath.row];
        return [tableView cellHeightForIndexPath:indexPath model:optionModel keyPath:@"optionModel" cellClass:[CSRadioCell class] contentViewWidth:kCSScreenWidth];
        //判断题
    }else if ([caseDetailModel.caseQuestionType isEqualToString:kTopicJudgeType]){
        CSOptionModel *optionModel = caseDetailModel.optionArray[indexPath.row];
        return [tableView cellHeightForIndexPath:indexPath model:optionModel keyPath:@"optionModel" cellClass:[CSJudgeCell class] contentViewWidth:kCSScreenWidth];
        //多选与不定项选择
    }else if ([caseDetailModel.caseQuestionType isEqualToString:kTopicMultiSelectType] ||[caseDetailModel.caseQuestionType isEqualToString:kTopicNoItemType]){
        CSOptionModel *optionModel = caseDetailModel.optionArray[indexPath.row];
        return [tableView cellHeightForIndexPath:indexPath model:optionModel keyPath:@"optionModel" cellClass:[CSMultiselectCell class] contentViewWidth:kCSScreenWidth];
    }
    return 0;
}
+ (NSString *)getSingleStringWithTableView:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath{
    for (UITableViewCell *allCell in tableView.visibleCells) {
        if ([allCell isMemberOfClass:[CSRadioCell class]]) {
            CSRadioCell *radioCell = (CSRadioCell *)allCell;
            [radioCell.optionImgBtn setBackgroundImage:[UIImage imageNamed:@"rounded-rectangle"] forState:UIControlStateNormal];
            radioCell.optionModel.isSelected = NO;
        }
    }
    
    CSRadioCell *cell = (CSRadioCell *)[tableView cellForRowAtIndexPath:indexPath];
    cell.optionModel.isSelected = YES;
    [cell.optionImgBtn setBackgroundImage:[UIImage imageNamed:@"rounded-rectangle_check"] forState:UIControlStateNormal];
    return [NSString stringWithFormat:@"%ld",[cell.optionModel.chopId integerValue]];
}

+ (NSString *)getJudgeStringWithTableView:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath{
    for (UITableViewCell *allCell in tableView.visibleCells) {
        if ([allCell isMemberOfClass:[CSJudgeCell class]]) {
            CSJudgeCell *judgeCell = (CSJudgeCell *)allCell;
            [judgeCell.optionImgBtn setImage:[UIImage imageNamed:@"rounded-rectangle"] forState:UIControlStateNormal];
            judgeCell.optionModel.isSelected = NO;
        }
    }
    CSJudgeCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    cell.optionModel.isSelected = YES;
    [cell.optionImgBtn setImage:[UIImage imageNamed:@"rounded-rectangle_check"] forState:UIControlStateNormal];
    return cell.optionModel.chopLabel;
}
@end
