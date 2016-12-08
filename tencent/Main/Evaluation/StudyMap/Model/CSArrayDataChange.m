//
//  CSArrayDataChange.m
//  tencent
//
//  Created by cyh on 16/8/3.
//  Copyright © 2016年 cyh. All rights reserved.
//

#import "CSArrayDataChange.h"
@implementation CSArrayDataChange


-(NSMutableArray *)dataChangeIndexWithArray:(NSMutableArray *)dataArr count:(NSInteger)count{
    NSMutableArray *array=[NSMutableArray array];
    int i=0;
    NSMutableArray *subArray=nil;
    for (id obj in dataArr) {
        if (i%count==0) {
            subArray=[NSMutableArray array];
        }
        [subArray addObject:obj];
        if ((i+1)%count==0||i==dataArr.count-1) {
            [array addObject:subArray];
        }
        i++;
    }
    return array;
}

@end
