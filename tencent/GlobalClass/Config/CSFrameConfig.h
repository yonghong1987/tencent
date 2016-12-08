//
//  CSFrameConfig.h
//  tencent
//
//  Created by sunon002 on 16/4/18.
//  Copyright © 2016年 cyh. All rights reserved.
//

#ifndef CSFrameConfig_h
#define CSFrameConfig_h

/*
 ***获取屏幕的宽度
 */
#define kCSScreenWidth ([UIScreen mainScreen].bounds.size.width)
/*
 **获取屏幕的高度
 */
#define kCSScreenHeight ([UIScreen mainScreen].bounds.size.height)
/*
 **获取屏幕的高度
 */
#define KNavigationHegiht 64
/*
 **获取banner的高度
 */
#define kCSBannerHeight (kCSScreenWidth * 180 / 320)
/*
 ***获取在不同屏幕的比例值
 */
#define kCSProportion(V) (CSScreenWidth * (V) / 320)
/**
 *tableView顶端间隙
 */
#define kCSTableViewTopPadding 35

#endif /* CSFrameConfig_h */
