//
//  CSForumDetailViewController.h
//  tencent
//
//  Created by admin on 16/5/23.
//  Copyright © 2016年 cyh. All rights reserved.
//

#import "CSBaseViewController.h"
#import "CSPostListModel.h"
@interface CSForumDetailViewController : CSBaseViewController
@property (nonatomic, strong) CSPostListModel *postListModel;
@property (nonatomic, strong) NSNumber *forumId;
@end
