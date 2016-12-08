//
//  SMGlobalApi.h
//  sunMobile
//
//  Created by duck on 16/4/19.
//  Copyright © 2016年 www.sunontalent.com. All rights reserved.
//

#import "SMUploadImageApi.h"
//可以赞的地方：D-同学圈中动态；C-课程；K-知识；N-笔记；Q-问题；I-资讯；P-人; M-评论(课程/论坛/训练营中评论的赞);W-微课;S-分享;
//T-群组话题;R-话题回复；总共10种类别。

//可以评论的地方：D-同学圈中动态；C-课程；K-知识；N-笔记；Q-问题答案；I-资讯，总共6种类别。


//收藏对象可收藏的对象有：C-课程；K-知识；N-笔记；Q-问题

typedef NS_ENUM(NSInteger , SMGlobalApiType) {
    
    
    /**
     *  默认
     */
    SMGlobalApiTypeDefault = 0,
    /**
     *  同学圈动态
     */
    SMGlobalApiTypeCircle,
    /**
     *  课程
     */
    SMGlobalApiTypeCourse,
    /**
     *  知识
     */
    SMGlobalApiTypeKnowledge,
    /**
     *  笔记
     */
    SMGlobalApiTypeNotes,
    /**
     *  问题
     */
    SMGlobalApiTypeProblem,
    /*
     *  咨询
     */
    SMGlobalApiTypeConsult,
    /**
     *  人
     */
    SMGlobalApiTypePople,
    /**
     *  评论(课程/论坛/训练营中评论的赞)
     */
    SMGlobalApiTypeComments,
    /**
     *  分享
     */
    SMGlobalApiTypeShare,
    /**
     *  群主话题
     */
    SMGlobalApiTypeGroupTopic,
    /**
     *  话题回复
     */
    SMGlobalApiTypeGroupReply,
    
    
    //评论中的赞
    SMGlobalApiCommentPraise,
    //课程中的赞
    SMGlobalApiCoursePraise,
    //专题中的赞
    SMGlobalApiSpecialPraise,
    //关卡的收藏
    SMGlobalApiCheckPointCollect,
    //课程的收藏
    SMGlobalApiCourseCollect,
    //专题的收藏
    SMGlobalApiSpecialCollect,
};
#pragma mark - 全局
/**
 *  基类
 */
@interface SMGlobalApi : SMUploadImageApi
/**
 *  对象类型
 */
@property (nonatomic ,assign)SMGlobalApiType targetType;
/**
 *  对象类型
 */
@property (nonatomic, copy) NSString *targetTypee;
@end

#pragma mark - 全局点赞
/**
 *  全局点赞
 */
@interface  SMClickGlobaPraise: SMGlobalApi

@property (nonatomic ,copy)NSNumber* targetId;
@property (nonatomic, strong) NSNumber *praiseId;

- (void)startWithPraiseId:(NSNumber *)praiseId completionBlockWithSuccess:(SMRequestSuccessBlock)success withFailure:(SMRequestFailureBlock)failure;
@end

#pragma mark - 全局获取收藏标签列表
/**
 *  全局获取收藏列表
 */
@interface  SMGetGlobalCollectList: SMGlobalApi

@end

#pragma mark - 全局收藏标签
/**
 *  全局收藏
 */
@interface  SMGlobalCollect: SMGlobalApi
/**
 *  收藏对象的ID
 */
@property (nonatomic ,strong) NSNumber * targetId;
/**
 *  收藏标题
 */
@property (nonatomic ,copy) NSString *titleString;

- (void)startWithCollectId:(NSNumber *)collectId completionBlockWithSuccess:(SMRequestSuccessBlock)success withFailure:(SMRequestFailureBlock)failure;
@end

#pragma mark - 全局添加标签
/**
 *  添加标签
 */
@interface  SMGlobalAddTagCollect: SMGlobalApi
/**
 *  收藏id
 */
@property (nonatomic ,copy)NSNumber * collectId;
/**
 *  标签标题
 */
@property (nonatomic ,strong)NSString * tagName;

@end
#pragma mark - 全局删除标签
/**
 *  删除标签
 */
@interface  SMGlobalDeleteTagCollect: SMGlobalApi
/**
 *  标签id
 */
@property (nonatomic ,copy)NSNumber * tagId;

@end

#pragma mark - 全局分享
/**
 *  全局分享
 */
@interface SMGlobalShare : SMGlobalApi
/**
 *  动态内容
 */
@property (nonatomic ,copy) NSString * content;
/**
 *  动态图片
 */
@property (nonatomic ,copy) NSString * fileImg;
/**
 *  动态图片列名称
 */
@property (nonatomic ,copy) NSString * fileImgFileName;
/**
 *  分享(课程  问题 笔记 等ID)/如果是取消分享 就是分享id
 */
@property (nonatomic ,copy) NSNumber * targetId;

/**
 *  取消/分享
 */
@property (nonatomic ,assign) BOOL alreadyShare;

@end


#pragma mark - 全局评论
/**
 *  全局评论
 */
@interface  SMGlobalComment: SMGlobalApi

@property (nonatomic ,copy)NSNumber * targetId;
/**
 *  被评论人id
 */
@property (nonatomic ,copy)NSNumber * becommentuserid;

@property (nonatomic ,copy)NSNumber * parentid;
@property (nonatomic ,copy)NSNumber * rootparentid;
@property (nonatomic ,copy)NSString * content;

@end




