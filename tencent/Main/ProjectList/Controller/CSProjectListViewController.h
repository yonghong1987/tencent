//
//  CSProjectListViewController.h
//  tencent
//
//  Created by bill on 16/4/26.
//  Copyright © 2016年 cyh. All rights reserved.
//

#import "CSBaseViewController.h"

@interface CSProjectListViewController : CSBaseViewController
//用于装载已被设置为常用项目的集合
@property (nonatomic, strong) NSMutableDictionary *projectDic;
@end
