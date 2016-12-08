//
//  CSHotForumListViewController.h
//  tencent
//
//  Created by cyh on 16/7/25.
//  Copyright © 2016年 cyh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CSBaseViewController.h"
@interface CSHotForumListViewController : CSBaseViewController
/*
 ***论坛类型
 */
@property (nonatomic, copy) NSString *forumType;
- (void)changedProjectMenuItem;
@end
