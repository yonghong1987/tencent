//
//  CSDisplayPraiseView.h
//  tencent
//
//  Created by admin on 16/5/10.
//  Copyright © 2016年 cyh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CSToolButtonView.h"
@interface CSDisplayPraiseView : UIView
/*
 **点赞
 */
@property (nonatomic, strong) CSToolButtonView *praiseView;
/*
 **回复
 */
@property (nonatomic, strong) CSToolButtonView *replyView;
@property (nonatomic, strong) UIImageView *gapIV;



@end
