//
//  CSMapCourseDetailViewController.h
//  tencent
//
//  Created by bill on 16/5/4.
//  Copyright © 2016年 cyh. All rights reserved.
//

#import "CSBaseViewController.h"
#import "CSNormalCourseDetailViewController.h"
#import "CSExamResultViewController.h"
@interface CSMapCourseDetailViewController : CSNormalCourseDetailViewController

/**
 *  关卡Id
 */
@property (nonatomic, strong) NSNumber *tollgateId;
/**
 *关卡名
 */
@property (nonatomic, copy) NSString *titleName;
/**
 *  当前关卡闯关成功动画
 */
@property (nonatomic, strong) NSString *currentLevelSuccessAnimation;

/**
 *  当前关卡闯关失败动画
 */
@property (nonatomic, strong) NSString *currentLevelFailAnimation;

/**
 *  下一关关卡闯关成功动画
 */
@property (nonatomic, strong) NSString *nextLevelSuccessAnimation;

/**
 *  下一关关卡闯关失败动画
 */
@property (nonatomic, strong) NSString *nextLevelFailAnimation;

@property (nonatomic, assign) CSExamResultType examReultType;
 

@end
