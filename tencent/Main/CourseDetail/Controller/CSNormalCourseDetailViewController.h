//
//  CSNormalCourseDetailViewController.h
//  tencent
//
//  Created by sunon002 on 16/4/27.
//  Copyright © 2016年 cyh. All rights reserved.
//

#import "CSBaseViewController.h"
#import "CSCourseDetailOPerationModel.h"

#import "CSUrl.h"
#import "MBProgressHUD+CYH.h"
#import "CSHttpRequestManager.h"

#import "UIImageView+AFNetworking.h"
#import "UIView+SDAutoLayout.h"

#import "CSSpecialBottomView.h"

//是否是从列表进去，并需要更改点赞数、浏览数
typedef NS_ENUM(NSInteger, CSChangePraiseAndBrowseType) {
CSChangeePraiseCountType = 101,
};
//判断是否有课后考试
typedef NS_ENUM(NSInteger, isHasAfCourseType) {
     hasAfCourseType = 100,
};

@interface CSNormalCourseDetailViewController : CSBaseViewController

typedef NS_ENUM( NSInteger, CALL_TYPE) {
    CALL_SELF,     //正常跳转
    CALL_WEIXIN,   //微信唤醒
    CALL_DOWNLOAD  //下载
};


/**
 *  调用方式
 */
@property (nonatomic, assign) CALL_TYPE openType;

/**
 *  点赞、分享、收藏
 */
@property (nonatomic,  assign) CSBottomViewType commonOperationType;
@property (nonatomic, strong) NSMutableArray *resources;
/**
 *  课程详情呈现
 */
@property (nonatomic, strong) UITableView *courseDetailTable;

/**
 *  资源操作模型：考试、文章、视频、直播
 */
@property (nonatomic, strong) CSCourseDetailOperationModel *operation;

/**
 *  课程Id
 */
@property (nonatomic, strong) NSNumber *courseId;
/**
 *资源或者考试id
 */
@property (nonatomic, assign) NSInteger resId;
/**
 *课后考试
 */
@property (nonatomic, assign) isHasAfCourseType afCourseType;
/**
 *课程详情对象
 */
@property (nonatomic, strong) CSCourseDetailModel *courseDetailModel;
@property (nonatomic, assign) CSStudyType studyType;
@property (nonatomic,strong)CSCourseResourceModel    *operateModel;
/**
 *  初始化
 *
 *  @param courseId   课程Id
 *  @param courseName 课程名
 *
 *  @return 课程详情实体
 */
@property (nonatomic,strong)NSManagedObjectID *resourceModelID;
@property (nonatomic,strong)NSIndexPath       *selectIndexPath;
/**
 *  关卡Id
 */
@property (nonatomic, strong) NSNumber *passTollgateId;
@property (nonatomic, copy) NSString *passTitleName;
/**
 *  下一关关卡闯关成功动画
 */
@property (nonatomic, strong) NSString *passNextLevelSuccessAnimation;

/**
 *  下一关关卡闯关失败动画
 */
@property (nonatomic, strong) NSString *passNextLevelFailAnimation;
/**
 *从下载进来
 */
@property (nonnull ,strong)id jsonModel;
/**
 *自己的点赞个数
 */
@property (nonatomic, assign) NSInteger praiseCount;
@property (nonatomic, assign) CSChangePraiseAndBrowseType changePraiseType;
- (id)initWithCourseId:(NSNumber *)courseId CoureseName:(NSString *)courseName;

- (void)addBottonView;
//往课程详情对象中加入关卡id
- (void)addTollgateId;

@property (nonatomic, copy) void (^passBrowse)(NSInteger browseCount, NSInteger praiseCount);
@end
