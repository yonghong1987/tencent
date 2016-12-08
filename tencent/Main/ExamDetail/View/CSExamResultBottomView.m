//
//  CSExamResultBottomView.m
//  tencent
//
//  Created by cyh on 16/8/20.
//  Copyright © 2016年 cyh. All rights reserved.
//

#import "CSExamResultBottomView.h"
#import "CSFrameConfig.h"
#import "CSConfig.h"
#import "UIColor+HEX.h"
#define kColumn 4
#define kPadding 30
@implementation CSExamResultBottomView

-(instancetype)init{
    if (self = [super init]) {
    }
    return self;
}

-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
    }
    return self;
}

-(void)setResultViewType:(CSExamResultViewType)resultViewType{
    _resultViewType = resultViewType;
     self.backgroundColor = [[UIColor colorWithHexString:@"#f8f8f8"] colorWithAlphaComponent:0.9];
    NSInteger column;
    CGFloat padding;
    CGFloat width = 46;
    if (self.resultViewType == CSExamResultPassType) {
        column = 4;
        padding = (kCSScreenWidth - width * column) / (2 *column);
        for (int i = 0; i < column; i ++) {
            CSToolBtn *button = [[CSToolBtn alloc]initWithFrame:CGRectMake((2 * i) * padding + padding + i * width, 10, width, width + 40)];
            if (i == 0) {
                button.iconIV.image = [UIImage imageNamed:@"icon_again"];
                button.titleLabel.text = @"再来一次";
                self.againBtn = button;
            }else if (i == 1){
                button.iconIV.image = [UIImage imageNamed:@"icon_testPape"];
                button.titleLabel.text = @"看试卷";
                self.lookPaperBtn = button;
            }else if (i == 2){
                button.iconIV.image = [UIImage imageNamed:@"icon_error"];
                button.titleLabel.text = @"看错题";
                self.lookFalse = button;
            }else if (i == 3){
                button.iconIV.image = [UIImage imageNamed:@"icon_nextStep"];
                button.titleLabel.text = @"下一步";
                self.nextBtn = button;
            }
            [self addSubview:button];
            button.passToolBtn = ^(CSToolBtn *toolBtn){
                switch (i) {
                    case 0:
                        if (self.againCallBackAction) {
                            self.againCallBackAction();
                        }
                        break;
                    case 1:
                        if (self.lookPaperCallBackAction) {
                            self.lookPaperCallBackAction();
                        }
                        break;
                    case 2:
                        if (self.lookFalseCallBackAction) {
                            self.lookFalseCallBackAction();
                        }
                        break;
                    case 3:
                        if (self.nextCallBackAction) {
                            self.nextCallBackAction();
                        }
                        break;
                    default:
                        break;
                }
            };
        }

    }else if (self.resultViewType == CSExamResultEvaluationType){
        column = 2;
        padding = (kCSScreenWidth - width * column) / (2 *column);
        for (int i = 0; i < column; i ++) {
            CSToolBtn *button = [[CSToolBtn alloc]initWithFrame:CGRectMake((2 * i) * padding + padding + i * width, 10, width, width + 40)];
                if (i == 0){
                button.iconIV.image = [UIImage imageNamed:@"icon_error"];
                button.titleLabel.text = @"看错题";
                self.lookFalse = button;
            }else if (i == 1){
                button.iconIV.image = [UIImage imageNamed:@"icon_nextStep"];
                button.titleLabel.text = @"下一步";
                self.nextBtn = button;
            }
            [self addSubview:button];
            button.passToolBtn = ^(CSToolBtn *toolBtn){
                switch (i) {
                    case 0:
                        if (self.lookFalseCallBackAction) {
                            self.lookFalseCallBackAction();
                        }
                        break;
                    case 1:
                        if (self.nextCallBackAction) {
                            self.nextCallBackAction();
                        }
                        break;
                    default:
                        break;
                }
            };
        }

    }
}

@end
