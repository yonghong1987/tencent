//
//  CSBaseRootViewController.h
//  tencent
//
//  Created by bill on 16/4/26.
//  Copyright © 2016年 cyh. All rights reserved.
//

#import "CSBaseViewController.h"
#import "CSProjectListView.h"

@interface CSBaseRootViewController : CSBaseViewController

@property (nonatomic, strong) UIView *projectBackView;
/**
 *  切换了当前项目
 */
- (void)changedProjectItem;


@end
