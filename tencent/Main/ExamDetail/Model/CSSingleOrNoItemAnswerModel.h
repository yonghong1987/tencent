//
//  CSSingleOrNoItemAnswerModel.h
//  tencent
//
//  Created by cyh on 16/8/18.
//  Copyright © 2016年 cyh. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CSSingleOrNoItemAnswerModel : NSObject
/**
 *用于保存答案的key
 */
@property (nonatomic, copy) NSString *answerKey;
/**
 *用于保存答案的value
 */
@property (nonatomic,copy) NSString *answerValue;
@end
