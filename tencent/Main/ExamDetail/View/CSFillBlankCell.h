//
//  CSFillBlankCell.h
//  tencent
//
//  Created by cyh on 16/7/27.
//  Copyright © 2016年 cyh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XHMessageTextView.h"
#import "CSOptionModel.h"
@interface CSFillBlankCell : UITableViewCell<UITextViewDelegate>
@property (nonatomic, strong) UILabel *fillPromptLabel;
@property (nonatomic, strong) XHMessageTextView *fillContentTextView;
@property (nonatomic, strong) NSNumber *canAnswer;
@property (nonatomic, strong) CSOptionModel *optionModel;
@property (nonatomic, copy) void (^ passTextViewIndex)();
@end
