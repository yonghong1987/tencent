//
//  CSSpecialMenuListViewController.h
//  tencent
//
//  Created by admin on 16/5/3.
//  Copyright © 2016年 cyh. All rights reserved.
//

#import "CSBaseViewController.h"
#import "SMBaseTableView.h"
@interface CSSpecialMenuListViewController : CSBaseViewController<UITableViewDelegate,UITableViewDataSource>
/*
 **专题id
 */
@property (nonatomic, strong) NSNumber *specialMenuid;
@property (nonatomic, strong) SMBaseTableView *specialTable;
@end
