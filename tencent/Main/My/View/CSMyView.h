//
//  CSMyView.h
//  tencent
//
//  Created by bill on 16/5/23.
//  Copyright © 2016年 cyh. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^selectedRowIndex)(NSInteger rowIndex);

@interface CSMyView : UIView

@property (nonatomic, strong) selectedRowIndex selectedRowIndex;
@property (nonatomic, strong) UITableView *myCenterTable;
- (void)setDataSourceInfo:(NSDictionary *)dataSource;
@property (nonatomic, strong) UIView *tableHeadView;

@end
