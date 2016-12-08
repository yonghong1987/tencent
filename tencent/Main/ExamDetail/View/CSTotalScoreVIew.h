//
//  CSTotalScoreVIew.h
//  tencent
//
//  Created by cyh on 16/10/28.
//  Copyright © 2016年 cyh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CSExamResultModel.h"
@interface CSTotalScoreVIew : UIView
/**
 *总分label
 */
@property (nonatomic, strong) UILabel *totlaScoreLabel;
/**
 *合格分label
 */
@property (nonatomic, strong) UILabel *qualifiedLabel;
@property (nonatomic, strong) UILabel *gapLabel;
@property (nonatomic, strong) UIImageView *trueIV;
@property (nonatomic, strong) UILabel *gapLabel2;
/**
 *考试是否通过的提示
 */
@property (nonatomic, strong) UILabel *promptLabel;
/**
 *考试成绩对象
 */
@property (nonatomic, strong) CSExamResultModel *examResultModel;
@end
