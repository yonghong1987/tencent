//
//  CSProjectModel.h
//  Tencent
//
//  Created by sunon002 on 16/4/21.
//  Copyright © 2016年 cyh. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CSProjectModel : NSObject<NSCoding>

@property (nonatomic,assign) int projectid;//项目id
@property (nonatomic,copy) NSString *projectName;//项目名称
@property (nonatomic,copy) NSString *projectImg;//项目图片
@property (nonatomic,copy) NSString *appName;//app名称
@property (nonatomic,assign) BOOL isAddedInd;//是否是常用项目 (1：是，0：不是)
@property (assign, nonatomic) int isAll; // 用于判断是不是全部，显示本地图标
- (id)initWithDictionary:(NSDictionary *)dictionary;

@end
