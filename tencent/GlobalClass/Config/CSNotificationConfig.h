//
//  CSNotificationConfig.h
//  tencent
//
//  Created by bill on 16/5/10.
//  Copyright © 2016年 cyh. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CSNotificationConfig : NSObject

/**
 *  浏览文章
 */
#define NOTIFICATION_VIDEOORARTICAL_PLAY @"NOTIFICATION_VIDEOORARTICAL_PLAY"


/**
 *  切换项目
 */
#define kChangeProjectNotifycation @"CHANGEPROJECT"
//下载页的刷新
#define kNotificationDownLoadRefresh @"kNotificationDownLoadRefresh"
//发帖成功
#define kNotificationSavePostSuccess @"kNotificationSavePostSuccess"
//首页的帖子数与评论数的传递
#define kNotificationCommentCountAndForumCount @"kNotificationCommentCountAndForumCount"
#define passToPage @"passToPage"
//传递课前测验的考试结果
#define kNotificationPrecourceStatus @"precourceStatus"
@end
