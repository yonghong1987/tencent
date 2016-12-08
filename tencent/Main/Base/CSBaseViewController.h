//
//  CSBaseViewController.h
//  tencent
//
//  Created by sunon002 on 16/4/16.
//  Copyright © 2016年 cyh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CSBaseNavigationController.h"
@interface CSBaseViewController : UIViewController

/**
 *  切换项目
 */
@property (nonatomic, assign) BOOL changeProject;

/*
 **搜索按钮
 */
@property (nonatomic, strong) UIButton *searchBtn;

/**
 *返回按钮
 */
@property (nonatomic, strong) UIButton *backBtn;

/**
 *  关卡Id
 */
@property (nonatomic, strong) NSNumber *tollgateId;


@property (nonatomic, strong) CSBaseNavigationController *topNav;
-(void)backAction;
-(void)searchAction:(UIButton *)sender;
-(void)removeFromSuper;
@end
