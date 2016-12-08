//
//  CSProjectModel.h
//  tencent
//
//  Created by sunon002 on 16/4/21.
//  Copyright © 2016年 cyh. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CSBaseModel.h"
#import "JSONModel.h"

@interface CSProjectModel : CSBaseModel

@property (nonatomic,strong) NSNumber *projectId;//项目id
@property (nonatomic,copy) NSString *name;//项目名称
@property (nonatomic,copy) NSString *img;//项目图片
@property (nonatomic,copy) NSString *appName;//app名称
@property (nonatomic,strong) NSNumber *addedInd;

@property (nonatomic,assign) BOOL isAddedInd;//是否是常用项目 (1：是，0：不是)
@property (assign, nonatomic) int isAll; // 用于判断是不是全部，显示本地图标
@property (nonatomic ,copy)NSString *commentReplyTotal;//评论回复总数
@property (nonatomic ,copy)NSString *requiredCourseTotal;//必修课总数
@property (nonatomic ,copy)NSString *goodCourseTotal; // 最新精选更新总数
@property (nonatomic ,strong)NSMutableArray *bannerArr;//banner数组
@property (nonatomic ,strong)NSMutableArray *courseArr;//推荐课程数组
- (id)initWithDictionary:(NSDictionary *)dictionary;

- (instancetype)initProjectDic:(NSDictionary *)projectDictionary;

@end
