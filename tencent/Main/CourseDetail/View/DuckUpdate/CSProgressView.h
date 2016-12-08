//
//  CSProgressView.h
//  tencent
//
//  Created by duck on 2016/11/25.
//  Copyright © 2016年 cyh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TYDownLoadModel.h"
@interface CSProgressView : UIView

@property (nonatomic) float progress;//0~1之间的数

@property (nonatomic) TYDownloadState state;

@property (nonatomic ,copy)void(^touchUpInsideBlcok)(void);

@end
