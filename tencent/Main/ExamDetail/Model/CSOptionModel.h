//
//  CSOptionModel.h
//  tencent
//
//  Created by admin on 16/5/17.
//  Copyright © 2016年 cyh. All rights reserved.
//

#import "CSBaseModel.h"

@interface CSOptionModel : CSBaseModel
/*
 **选项
 */
@property (nonatomic, copy) NSString *chopLabel;
/*
 **选项的答案
 */
@property (nonatomic, copy) NSString *chopText;
/*
 **选项的id
 */
@property (nonatomic, strong) NSNumber *chopId;
/**
 *选此选项的用户的比例
 */
@property (nonatomic, strong) NSNumber *chopRatio;
/**
 *是否是正确答案
 */
@property (nonatomic, strong) NSNumber *chopCorrect;
/**
 *是否已选择
 */
@property (nonatomic, strong) NSNumber *isChecked;
/**
 *用户答题时是否选中
 */
@property (nonatomic, assign) BOOL isSelected;


//练身手--用户是否选择
@property (nonatomic, strong) NSNumber *chopChecked;

//如果是填空题时
//该空的正确答案
@property (nonatomic, copy) NSString *chopCorrectAnswer;
//用户填写的答案
@property (nonatomic, copy) NSString *chopUserAnswer;
//该空可输入的最大长度
@property (nonatomic, strong) NSNumber *chopBlankLength;
/**
 *是否显示正确答案
 */
@property (nonatomic, strong) NSNumber *displayAnswer;
////显示用户的答案
//@property (nonatomic, strong) NSNumber *canDisplayUserAn;
@end
