//
//  CSExamResultBottomView.h
//  tencent
//
//  Created by cyh on 16/8/20.
//  Copyright © 2016年 cyh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CSToolBtn.h"

typedef NS_ENUM(NSInteger, CSExamResultViewType) {
   CSExamResultEvaluationType,
   CSExamResultPassType,
};
@interface CSExamResultBottomView : UIView
/**
 *再来一次
 */
@property (nonatomic, strong) CSToolBtn *againBtn;
/**
 *看试卷
 */
@property (nonatomic, strong) CSToolBtn *lookPaperBtn;
/**
 *看错题
 */
@property (nonatomic, strong) CSToolBtn *lookFalse;
/**
 下一步
 */
@property (nonatomic, strong) CSToolBtn *nextBtn;

@property (nonatomic, assign) CSExamResultViewType resultViewType;
@property (nonatomic, copy) void (^againCallBackAction)();
@property (nonatomic, copy) void (^lookPaperCallBackAction)();
@property (nonatomic, copy) void (^lookFalseCallBackAction)();
@property (nonatomic, copy) void (^nextCallBackAction)();
@end
