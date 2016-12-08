//
//  CSAppVersionModel.h
//  tencent
//
//  Created by bill on 16/8/5.
//  Copyright © 2016年 cyh. All rights reserved.
//

#import "CSBaseModel.h"
#import <UIKit/UIKit.h>

@interface CSAppVersionModel : CSBaseModel

@property (nonatomic, strong) NSString *url;

@property (nonatomic, strong) NSString *code;

@property (nonatomic, strong) NSString *message;

@property (nonatomic, strong) NSString *name;

+ (CSAppVersionModel *)shareInstance;

/**
 *  版本检查
 *
 *  @param currentView 当前弹窗视图
 *  @param needShow    是否需要弹窗
 */
- (void)checkVersion:(UIView *)currentView ShowTip:(BOOL)needShow;

/**
 *  版本比较
 *
 *  @return 比较结果
 */
- (NSComparisonResult)compareVersion;

@end
