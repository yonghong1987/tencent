//
//  CSUrl.h
//  tencent
//
//  Created by sunon002 on 16/4/16.
//  Copyright © 2016年 cyh. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CSUrl : NSObject

FOUNDATION_EXPORT NSString *const URL_CHECK_VERSION;

FOUNDATION_EXPORT NSString *const URL_USER_LOGINOUT;
/*
 **服务器接口所用域名
 */
FOUNDATION_EXPORT NSString * const BASE_URL_STRING;
/*
 **是否需要修改版本号
 */
FOUNDATION_EXPORT NSString * const MIDDLE_CATE;
/*
 **登录
 */
FOUNDATION_EXPORT NSString * const URL_USER_LOGIN;

/**
 *  学习项目
 */
FOUNDATION_EXPORT NSString * const GET_PROJECTS;

/**
 *  设置常用项目
 */
FOUNDATION_EXPORT NSString *const SET_NORMAL_PROJECTS;

/*
 **获取首页课程列表和bananer
 */
FOUNDATION_EXPORT NSString * const GET_PROJECT_LIST;

/**
 *  获取知识库目录
 */
FOUNDATION_EXPORT NSString * const GET_FINE_COURSE;

/**
 *  课程列表
 */
FOUNDATION_EXPORT NSString *const GET_COURSE_LIST;

/**
 *  热门标签
 */
FOUNDATION_EXPORT NSString * const GET_HOT_SPECIAL;

/**
 *专题目录
 */
FOUNDATION_EXPORT NSString * const GET_SPECIAL_MENU;

/**
 *专题列表
 */
FOUNDATION_EXPORT NSString * const GET_SPECIAL_LIST;
 

/**
 *  专题详情
 */
FOUNDATION_EXPORT NSString * const GET_SPECIAL_DETAIL;

/**
 *  课程详情
 */
FOUNDATION_EXPORT NSString * const GET_DETAIL_COURSE;

/**
 *  评论列表
 */

FOUNDATION_EXPORT NSString * const GET_COMMENT_LIST;

/**
 *  保存评论
 */
FOUNDATION_EXPORT NSString * const SAVE_COMMENT;

/**
 *  查看关卡通过状态
 */
FOUNDATION_EXPORT NSString * const GET_CHECKPOINT_STATUS;
/**
 *  点赞
 */
FOUNDATION_EXPORT NSString * const CLICK_PRAISE;
/**
 *  学案例列表
 */
FOUNDATION_EXPORT NSString * const GET_STUDY_CASE_LIST;
/**
 *  练身手列表
 */
FOUNDATION_EXPORT NSString * const GET_PRACTICE_SKILL_LIST;
/**
 * 学习地图列表
 */
FOUNDATION_EXPORT NSString * const GET_STUDY_MAP_LIST;

/**
 *  检查是否能直播
 */
FOUNDATION_EXPORT NSString *const CHECK_LIVEVIDEO;
/**
 *  获取试卷详情
 */
FOUNDATION_EXPORT NSString *const GET_EXAMINATION_PAPER;
/**
 *  获取案列详情
 */
FOUNDATION_EXPORT NSString *const GET_CASE_DETAIL;
/**
 *  获取论坛列表
 */
FOUNDATION_EXPORT NSString *const GET_FORUM_LIST;
/**
 *  保存帖子
 */
FOUNDATION_EXPORT NSString *const SEND_POST;
/**
 *  获取帖子详情
 */
FOUNDATION_EXPORT NSString *const GET_PORUM_DETAIL;
/**
 *  获取关卡列表
 */
FOUNDATION_EXPORT NSString *const GET_CHECK_POINT_LIST;
/**
 *保存全局评论
 */
FOUNDATION_EXPORT NSString *const SAVE_GLOBAL_COMMENT;
/**
 *保存全局收藏
 */
FOUNDATION_EXPORT NSString *const SAVE_GLOBAL_COLLECT;
/**
 *删除全局收藏
 */
FOUNDATION_EXPORT NSString *const DELETE_GLOBAL_COLLECT;
/**
 *提交案列答案
 */
FOUNDATION_EXPORT NSString *const SAVE_CASE_ANSWER;
/**
 *得到案例延伸阅读
 */
FOUNDATION_EXPORT NSString *const GET_CASE_LIST;
/**
 *是否可以进入考试
 */
FOUNDATION_EXPORT NSString *const START_GO_EXAM;
/**
 *提交考试答案
 */
FOUNDATION_EXPORT NSString *const SAVE_EXAM_ANSWER;
/**
 *获取考试结果
 */
FOUNDATION_EXPORT NSString *const GET_EXAM_RESULT;
/**
 *学习记录
 */
FOUNDATION_EXPORT NSString *const STUDY_RECORD_LIST;
/**
 *我的帖子
 */
FOUNDATION_EXPORT NSString *const MY_POST_LIST;
/**
 *我的收藏
 */
FOUNDATION_EXPORT NSString *const MY_COLLECT_LIST;
/**
 *查看试卷（已考过的）
 */
FOUNDATION_EXPORT NSString *const CHECK_PAPER;
/**
 *我的评论
 */
FOUNDATION_EXPORT NSString *const MY_COMMENT;
/**
 *我的实战记录(学案例)
 */
FOUNDATION_EXPORT NSString *const MY_CASE;
/**
 *我的实战记录（练身手）
 */
FOUNDATION_EXPORT NSString *const MY_SKILL;
/**
 *资源浏览数记录
 */
FOUNDATION_EXPORT NSString *const RESOURCE_BROWSE;
/**
 *课程的延伸阅读
 */
FOUNDATION_EXPORT NSString *const COURSE_EXTENSION_READ;
/**
 *标签关联的课程
 */
FOUNDATION_EXPORT NSString *const TAG_COURSE;
/**
 *记录课程活动记录
 */
FOUNDATION_EXPORT NSString *const RECORD_INFO;

@end
