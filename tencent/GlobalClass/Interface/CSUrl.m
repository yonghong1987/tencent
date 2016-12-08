//
//  CSUrl.m
//  tencent
//
//  Created by sunon002 on 16/4/16.
//  Copyright © 2016年 cyh. All rights reserved.
//


#import "CSUrl.h"

@implementation CSUrl

/**
 *  RELEASE：配置腾讯方服务器； DEBUG：内部测试服务器
 */
#ifdef RELEASE
NSString *const MIDDLE_CATE = @"/tencentapp";
NSString *const BASE_URL_STRING = @"http://learn.m.tencent.com";
#else


NSString *const MIDDLE_CATE = @"";
//NSString *const BASE_URL_STRING = @"http://10.1.1.240:8084";
NSString *const BASE_URL_STRING = @"http://10.1.1.194:8082";
//NSString *const BASE_URL_STRING = @"http://10.1.1.246:8082";
//NSString *const BASE_URL_STRING = @"http://183.60.120.86:8082";
#endif


NSString *const URL_CHECK_VERSION = @"/apkversion/getNewestAPK.action";

NSString *const URL_USER_LOGIN = @"/user/login.action";

NSString *const URL_USER_LOGINOUT = @"/user/loginOut.action";

NSString *const GET_PROJECTS = @"/project/getProjectListForType.action";

NSString *const SET_NORMAL_PROJECTS = @"/project/markProject.action";

NSString *const GET_PROJECT_LIST = @"/project/getProjectList.action";

NSString *const GET_FINE_COURSE = @"/catalog/getCatalogList.action";

NSString *const GET_COURSE_LIST = @"/course/getCourseListForType.action";

NSString *const GET_HOT_SPECIAL = @"/special/getHotSpecial.action";

NSString *const GET_SPECIAL_MENU = @"/catalog/getSeminarCatalogList.action";

NSString *const GET_SPECIAL_LIST = @"/course/getSeminarList.action";

NSString *const GET_SPECIAL_DETAIL = @"/course/getSeminarDetail.action";

NSString *const GET_DETAIL_COURSE = @"/course/getCourseContentList.action";

NSString *const GET_COMMENT_LIST = @"/comment/list.action";

NSString *const SAVE_COMMENT = @"/interfaceapi/comment/comment!save.action";

NSString *const GET_CHECKPOINT_STATUS = @"/mapp/getTollStatus.action";

NSString *const CLICK_PRAISE = @"/praise/saveOrCancelPraise.action";

NSString *const GET_STUDY_CASE_LIST = @"/interfaceapi/cases/getCaseList.action";

NSString *const GET_PRACTICE_SKILL_LIST = @"/interfaceapi/test/getTestList.action";

NSString *const GET_STUDY_MAP_LIST = @"/mapp/getMapList.action";

NSString *const CHECK_LIVEVIDEO = @"/resourse/getIsPlayer.action";

NSString *const GET_EXAMINATION_PAPER = @"/interfaceapi/test/getQuestionList.action";

NSString *const GET_CASE_DETAIL = @"/interfaceapi/cases/getCaseDetailById.action";
NSString *const GET_FORUM_LIST = @"/forum/getForumListForType.action";
NSString *const SEND_POST = @"/forum/save.action";
NSString *const GET_PORUM_DETAIL = @"/forum/getForumDetail.action";
NSString *const GET_CHECK_POINT_LIST = @"/mapp/getTollList.action";
NSString *const SAVE_GLOBAL_COMMENT = @"/comment/save.action";
NSString *const SAVE_GLOBAL_COLLECT = @"/collect/collect.action";
NSString *const DELETE_GLOBAL_COLLECT = @"/collect/deleteCollect.action";
NSString *const SAVE_CASE_ANSWER = @"/interfaceapi/cases/saveCaseAnswer.action";
NSString *const GET_CASE_LIST = @"/interfaceapi/cases/getCaseResourceList.action";

NSString *const START_GO_EXAM = @"/interfaceapi/test/startTest.action";
NSString *const SAVE_EXAM_ANSWER = @"/interfaceapi/test/saveTestAnswer.action";
NSString *const GET_EXAM_RESULT = @"/interfaceapi/test/getTestDetailById.action";
NSString *const STUDY_RECORD_LIST = @"/personal/getStudyRecords.action";
NSString *const MY_POST_LIST = @"/personal/getMyForum.action";
NSString *const MY_COLLECT_LIST = @"/personal/getMyCollect.action";
NSString *const CHECK_PAPER = @"/interfaceapi/test/getQuestionResultList.action";
NSString *const MY_COMMENT = @"/personal/getMyComment.action";
NSString *const MY_CASE = @"/personal/getMyCase.action";
NSString *const MY_SKILL = @"/personal/getMyExam.action";
NSString *const RESOURCE_BROWSE = @"/course/browse.action";
NSString *const COURSE_EXTENSION_READ = @"/course/getCourseListForType.action";
NSString *const TAG_COURSE = @"/special/getCourseForSpecial.action";
NSString *const RECORD_INFO = @"/course/recordInfo.action";
@end
