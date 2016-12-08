//
//  CSProjectCollectionViewCell.h
//  tencent
//
//  Created by bill on 16/4/26.
//  Copyright © 2016年 cyh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CSProjectItemModel.h"
#import "CSProjectListView.h"
@interface CSProjectCollectionViewCell : UICollectionViewCell


@property (strong, nonatomic) IBOutlet UIImageView *choiceMarkImg;
//常用项目显示形式
@property (nonatomic, assign) PROJECTTYPE showType;

- (void)setProjectModel:(CSProjectItemModel *)model;

@end
