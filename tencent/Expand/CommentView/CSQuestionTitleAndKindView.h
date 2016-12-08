//
//  CSQuestionTitleAndKindView.h
//  tencent
//
//  Created by bill on 16/5/10.
//  Copyright © 2016年 cyh. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CSQuestionTitleAndKindView : UIView


/**
 *  实例化
 *
 *  @param frame   视图位置
 *  @param content 问题内容
 *  @param kind    问题类别
 *
 *  @return 实例化
 */
- (id)initWithFrame:(CGRect)frame
    QuestionContent:(NSString *)content
        QustionKind:(NSString *)kind;

/**
 *  重置View
 */
- (void)resetView;

@end
