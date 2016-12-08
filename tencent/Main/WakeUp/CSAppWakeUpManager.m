//
//  CSAppWakeUpManager.m
//  tencent
//
//  Created by cyh on 16/10/31.
//  Copyright © 2016年 cyh. All rights reserved.
//

#import "CSAppWakeUpManager.h"
#import "CSForumDetailViewController.h"


@implementation CSAppWakeUpManager

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

-(void)controllerMediator:(NSDictionary *)dicParam{
    CSForumDetailViewController *detail = [[CSForumDetailViewController alloc]init];
    [self.controlJump.navigationController pushViewController:detail animated:YES];
}
@end
