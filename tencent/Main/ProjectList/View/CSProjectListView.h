//
//  CSProjectListView.h
//  tencent
//
//  Created by bill on 16/4/26.
//  Copyright © 2016年 cyh. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "CSConfig.h"
#import "CSProjectItemModel.h"

typedef NS_ENUM(NSInteger, PROJECTTYPE) {
    TYPE_SHOWPROJ,     //更新当前项目
    TYPE_CHOICEPROJ,   //设置常用项目
};


// 0 -- 设置默认项目  1 -- 点击的是当前项目  2 -- 更换当前项目
typedef void(^choiceProject)(NSInteger projectId);

@interface CSProjectListView : UIView

@property (nonatomic, strong) NSMutableArray *dataSourceAry;

@property (nonatomic, strong) NSMutableDictionary *choiceMarkDic;


@property (nonatomic, assign) PROJECTTYPE showType;

@property (nonatomic, strong) choiceProject choiceProject;

@property (nonatomic, weak) UIViewController * delegate;

- (void)reloadData;

@end
