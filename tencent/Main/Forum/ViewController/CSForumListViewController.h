//
//  CSForumListViewController.h
//  tencent
//
//  Created by sunon002 on 16/4/26.
//  Copyright © 2016年 cyh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CSBaseViewController.h"
@interface CSForumListViewController : CSBaseViewController
/*
 ***论坛类型
 */
@property (nonatomic, copy) NSString *forumType;

- (void)changedProjectMenuItem;
@end
