//
//  CSTitleListCell.h
//  tencent
//
//  Created by cyh on 16/8/23.
//  Copyright © 2016年 cyh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CSTitleListModel.h"
@interface CSTitleListCell : UICollectionViewCell
@property (nonatomic, strong) CSTitleListModel *titleListModel;
@property (nonatomic, strong) NSIndexPath *indexPath;
@end
