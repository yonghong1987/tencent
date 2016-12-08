//
//  CSNavigationTitleView.h
//  tencent
//
//  Created by bill on 16/4/25.
//  Copyright © 2016年 cyh. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface CSNavigationTitleView : UIView

 
/**
 *  初始化TitleView
 *
 *  @param nomalName 普通状态下图片名
 *  @param ShowName  选中状态下图片名
 *
 */
- (id)initWithNomalImageName:(NSString *)nomalName
           SelectedImageName:(NSString *)selectedName;
/**
 *  TitleView的图片部分
 */
@property (nonatomic, strong) UIImageView *contentImg;

@end
