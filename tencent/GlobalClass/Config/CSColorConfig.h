//
//  CSColorConfig.h
//  tencent
//
//  Created by sunon002 on 16/4/18.
//  Copyright © 2016年 cyh. All rights reserved.
//

#ifndef CSColorConfig_h
#define CSColorConfig_h


#define ALPHA 0.3
/*
 **RGB颜色
 */
#define CSColorFromRGB(r, g, b) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1.0]
/*
**随机色
 */
#define CSRandomColor SMColorFromRGB(arc4random_uniform(256), arc4random_uniform(256), arc4random_uniform(256))
/*
 **十六进制
*/
#define CSColorFromHex(hexValue) [UIColor colorWithRed:((float)((hexValue & 0xFF0000) >> 16))/255.0 green:((float)((hexValue & 0xFF00) >> 8))/255.0 blue:((float)(hexValue & 0xFF))/255.0 alpha:1.0]
/*
 **主题颜色
 */
#define kCSThemeColor CSColorFromHex(0x46bc62)
/*
 **naviBar文字颜色
 */
#define kCSNaviBarTintColor CSColorFromHex(0x85868a)
/*
 **标题文字颜色
 */
#define kTitleColor CSColorFromRGB(51.0, 51.0, 51.0)
/*
**界面背景颜色
*/
#define kBGColor CSColorFromRGB(235.0, 235.0, 235.0)
/*
 **时间文字颜
*/
#define kTimeColor CSColorFromRGB(153.0, 153.0, 153.0)
/*
 ***点赞文字颜色
 */
#define kPraiseContent CSColorFromRGB(187.0, 186.0, 181.0)


#endif /* CSColorConfig_h */
