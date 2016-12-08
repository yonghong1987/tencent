//
//  CSPhotosView.h
//  tencent
//
//  Created by admin on 16/5/23.
//  Copyright © 2016年 cyh. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CSPhotosView : UIView

@property (nonatomic, strong) NSMutableArray *photosAry;
- (id)initWithFrame:(CGRect)frame photoViewSize:(CGSize)size UIEdgeInset:(UIEdgeInsets)edg;
@end
