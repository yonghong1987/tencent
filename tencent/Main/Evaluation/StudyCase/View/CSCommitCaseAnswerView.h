//
//  CSCommitCaseAnswerView.h
//  tencent
//
//  Created by cyh on 16/7/27.
//  Copyright © 2016年 cyh. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CSCommitCaseAnswerView : UIView
/**
 *提交案列按钮
 */
@property (nonatomic, strong) UIButton *commitCaseBtn;
@property (nonatomic, strong) NSNumber *canAnswer;
@property (nonatomic, copy) void (^commitAction)();
@end
