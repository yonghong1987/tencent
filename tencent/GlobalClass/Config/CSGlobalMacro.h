//
//  CSGlobalMacro.h
//  tencent
//
//  Created by cyh on 16/8/4.
//  Copyright © 2016年 cyh. All rights reserved.
//

#ifndef CSGlobalMacro_h
#define CSGlobalMacro_h

//评论
//课程评论
#define kCommentCourseType @"C"
//专题评论
#define kCommentSpecialType @"S"
//案列评论
#define kCommentCaseType @"N"
//论坛评论
#define kCommentForumType @"K"


//点赞
//课程点赞
#define kPraiseCourseType @"C"
//专题点赞
#define kPraiseSpecialType @"S"
//评论点赞
#define kPraiseCommentType @"P"

//题目类型
//判断题
#define kTopicJudgeType @"J"
//单选题
#define kTopicSingleType @"S"
//不定项选择题
#define kTopicNoItemType @"N"
//多项选择题
#define kTopicMultiSelectType @"M"
//问答题
#define kTopicQuestionType @"Q"
//填空题
#define kTopicFillType @"F"


//保存的单选题数组地址
#define kSingleArrayPathType @"Documents/examSingleAnswer.plist"
//保存的多选题数组地址
#define kMultiArrayPathType @"Documents/examMultiAnswer.plist"
//保存的不定项选题数组地址
#define kNoItemArrayPathType @"Documents/examNoItemAnswer.plist"
//保存的判断题数组地址
#define kJudgeArrayPathType @"Documents/examJudgeAnswer.plist"
//保存问答题数组地址
#define kQuestionArrayPathType @"Documents/examQuestionAnswer.plist"
//保存填空题数组地址
#define kFillArrayPathType @"Documents/examFillAnswer.plist"
//
#define kQuestionPath @"Documents/questionAnswer.plist"
#define kFillPath @"Documents/fillAnswer.plist"



#define OpenURLType         @"type"
#define URLParamOnline @"ONLINE"     //在线课程
#define URLParamExam   @"EXAM"       //在线考试
#define URLParamCase   @"CASE"       //训练营
#define URLParamForum  @"FORUM"      //论坛
#define URLParamTopic  @"SEMINAR"    //专题
#define URLParamMOnline @"MONLINE"   //地图课程
#define URLParamMap     @"MAP"       //地图

#define OpenURLProjectId    @"projectId"
#define OpenURLCourseId     @"courseId"
#define OpenURLActivityId   @"activityId"
#define OpenURLExamId       @"examId"
#define OpenURLCaseId       @"caseId"
#define OpenURLForumId      @"forumId"
#define OpenURLMapId        @"mapId"

#define OpenURLCompare @"sunontalentTencent://com.sunontalent.eLearning/"
#define OpenURLChangedApp @"OPENURLDESCRIPTION"
#endif /* CSGlobalMacro_h */
