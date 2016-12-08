//
//  CSSpecialCommentViewController.h
//  tencent
//
//  Created by admin on 16/5/6.
//  Copyright © 2016年 cyh. All rights reserved.
//

#import "CSBaseViewController.h"

@interface CSSpecialCommentViewController : CSBaseViewController<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) UITableView *commentTable;
/*
 ***目标id
 */
@property (nonatomic, strong) NSNumber *targetid;
/*
 **评论类型
 */
@property (nonatomic, copy) NSString *commentType;
@end
