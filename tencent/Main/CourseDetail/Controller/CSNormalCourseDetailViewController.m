//
//  CSNormalCourseDetailViewController.m
//  tencent
//
//  Created by sunon002 on 16/4/27.
//  Copyright © 2016年 cyh. All rights reserved.
//

#import "UITableView+SDAutoTableViewCellHeight.h"
#import "CSNormalCourseDetailViewController.h"
#import "CSCourseDetailVideoTableViewCell.h"
#import "CSCourseDetailTestTableViewCell.h"
#import "CSCourseDetailLiveTableViewCell.h"
#import "CSCourseDetailArticleTableViewCell.h"
#import "CSCourseDetailModel.h"
#import "CSCourseResourceModel.h"
#import "CSDownLoadCourseModel.h"
#import "CSDownLoadResourceModel.h"
#import "CSCoreDataManager.h"
#import "CSUserDefaults.h"
#import "CSProjectDefault.h"
#import "CSSpecialBottomView.h"
#import "CSConfig.h"
#import "CSFrameConfig.h"
#import "CSColorConfig.h"
#import "CSSpecialCommentViewController.h"
#import "CSCourseAndExamConfig.h"
#import "CSCourseDetailModel.h"
#import "CSCourseDetailOperationModel.h"

#import "SMGlobalApi.h"
#import "MBProgressHUD+SMHUD.h"
#import "CSShareView.h"
#import "CSExtensionReadViewController.h"
#import "NSDictionary+convenience.h"
#import "CSProjectDefault.h"
#import "AppDelegate.h"
#import <TVKPlayer/TVKPlayer.h>
#import "CSUserDefaults.h"
#import "CSCoreDataManager.h"
#import "VideoPlayProgress.h"
#import "CSUserDefaults.h"
#import "UIAlertView+Utils.h"

#import "TYDownloadSessionManager.h"

#import "CSTencentCoreDataManager.h"
#import "NSDictionary+convenience.h"
#import "NSSring+MD5.h"
@interface CSNormalCourseDetailViewController ()<UITableViewDelegate,UITableViewDataSource,UIAlertViewDelegate,CourseDetailCellDelegate,TVKMediaPlaybackDelegate,TVKMediaUrlRequestDelegate,TYDownloadDelegate>
/**
 *  课程名字
 */
@property (nonatomic, strong) NSString *courseName;
/**
 *  底部视图
 */
@property (nonatomic, strong) CSSpecialBottomView *courseDetailBottomView;
@property (nonatomic, strong) NSMutableDictionary *upCellDic;
/*
 *保存点击的视频实体的url
 */
@property (nonatomic, copy) NSString *resourceUrl;
/**
 *保存视频播放的进度
 */
@property (nonatomic, assign) float vedioProgress;
/**
 *保存视频播放总时长
 */
@property (nonatomic, assign) NSTimeInterval timeDuration;
/*
 *保存点击的视频model
 */
@property (nonatomic, strong) CSCourseResourceModel* resourceModel;
@end

@implementation CSNormalCourseDetailViewController

#pragma mark life cycle
- (id)initWithCourseId:(NSNumber *)courseId CoureseName:(NSString *)courseName{
    self = [super init];
    if ( self ) {
        _courseId = courseId;
        _courseName = courseName;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = self.courseName;
    self.resources = [NSMutableArray  array];
    [self.view addSubview:self.courseDetailTable];
    self.studyType = CSStudyModelType;
    //从下载读取
    if( self.openType == CALL_DOWNLOAD ){
        [self loadInformationFromCoreData];
    }else{
        //从网络读取
        [self loadInformationFromCoreInternet];
    }
}


-(void)parserCoreData:(id)coreData{
    self.jsonModel = coreData;
    if ( [[coreData objectForKey:@"code"] integerValue] == 0 ) {
        NSMutableArray *projectAry = [NSMutableArray array];
        //将资源列表加入到数组中
        id courseModel = [coreData objectForKey:@"contentList"];
        if( ![courseModel isKindOfClass:[NSArray class]] ){
            return ;
        }
        
        for( NSDictionary *dic in courseModel ){
            //是否有课后考试
            NSString *afExam = [dic objectForKey:@"resCode"];
            NSInteger resId = [dic integerForKey:@"resId"];
            if ([afExam isEqualToString:@"AFCOURSE"]) {
                self.afCourseType = hasAfCourseType;
                self.resId = resId;
            }
            CSCourseResourceModel *resourceModel = [[CSCourseResourceModel alloc]initWithDictionary:dic error:nil];
            resourceModel.courseId = coreData[@"courseId"];
            [projectAry addObject:resourceModel];
        }
        //将直播列表加入到数组中
        id liveList = [coreData objectForKey:@"liveList"];
        if( ![liveList isKindOfClass:[NSArray class]] ){
            return ;
        }
        
        for( NSDictionary *liveDic in liveList ){
            CSCourseResourceModel *resourceModel = [[CSCourseResourceModel alloc]initWithDictionary:liveDic error:nil];
            resourceModel.courseId = coreData[@"courseId"];
            [projectAry addObject:resourceModel];
        }
        
        self.resources = [projectAry copy];
        self.courseDetailModel = [[CSCourseDetailModel alloc]initWithDictionary:coreData error:nil];
        self.courseDetailModel.tollgateId = self.passTollgateId;
        self.title = self.courseDetailModel.name;
        if (self.commonOperationType == CSMapCourseDetailBottomView) {
            self.title = self.passTitleName;
        }else{
            self.title = self.courseDetailModel.name;
        }
        self.operation = [[CSCourseDetailOperationModel alloc] initCSCourseDetailModel:self.courseDetailModel CSCourseResourceArray:[NSArray arrayWithArray:projectAry] parentViewController:self];
        [self addBottonView];
        [self.courseDetailTable reloadData];
    }
}
#pragma mark Logic
/**
 *  从服务端请求数据
 */
- (void)loadInformationFromCoreInternet{

    //只有有CourseId存在时，才能请求课程详情
    if( self.courseId ){
       NSDictionary *params = @{@"courseId":self.courseId};
        [MBProgressHUD showMessage:@"加载中..." toView:self.view];
        __block CSNormalCourseDetailViewController *weakSelf = self;
        [[CSHttpRequestManager shareManager] postDataFromNetWork:GET_DETAIL_COURSE parameters:params success:^(CSHttpRequestManager *manager, id model) {
           [MBProgressHUD hideHUDForView:weakSelf.view];
      
            [self parserCoreData:model];
        } failture:^(CSHttpRequestManager *manager, id nodel) {
            [MBProgressHUD hideHUDForView:self.view];
            [MBProgressHUD showError:@"请求超时"];
        }];
    }
}

/**
 *  从数据库获取数据
 */
- (void)loadInformationFromCoreData{
    [self parserCoreData:self.jsonModel];
}

#pragma mark delegate Method
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.operation.resourceModelAry count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    CSCourseResourceModel *resouceModel = self.operation.resourceModelAry[indexPath.row];
    CGFloat width = self.view.bounds.size.width - 106;
    CGSize size = CGSizeMake( width, MAXFLOAT);
    size = [resouceModel.resName  boundingRectWithSize:size
                                                    options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading
                                                 attributes:@{NSFontAttributeName :[UIFont systemFontOfSize:14]}
                                                     context:nil].size;
    return 60;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    CSCourseResourceModel *model = self.operation.resourceModelAry[indexPath.row];
    //VIDEO,视频;ARTICLE，图文;LIVEVIDEO,直播;PRECOURSE课前考试，AFCOURSE课后考试
    if ( [model.resCode isEqualToString:@"PRECOURSE"] || [model.resCode isEqualToString:@"AFCOURSE"] ) {
        CSCourseDetailTestTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CSCourseDetailTestTableViewCell"];
        [cell setResourceCell:model];
        
        cell.precourseBtn.tag = indexPath.row;
        SEL  examMethod = ( [model.resCode isEqualToString:@"PRECOURSE"] ) ?@selector(examBeforeCourse:) : @selector(examAfterCourse:);
        self.operation.studyType = self.studyType;
        self.operation.tollgateId = self.passTollgateId;
        self.operation.tollgateName = self.passTitleName;
        self.operation.courseId = self.courseDetailModel.courseId;
        self.operation.nextLevelSuccessAnimation = self.passNextLevelSuccessAnimation;
        self.operation.nextLevelFailAnimation = self.passNextLevelFailAnimation;
        [cell.precourseBtn addTarget:self.operation action:examMethod forControlEvents:UIControlEventTouchUpInside];
        return cell;
        
    }else if( [model.resCode isEqualToString:@"LIVEVIDEO"] ){
        CSCourseDetailLiveTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CSCourseDetailLiveTableViewCell"];
        [cell setResourceCell:model];
        
        cell.precourseBtn.tag = indexPath.row;
 
        [cell.precourseBtn addTarget:self.operation action:@selector(playLiveVideo:) forControlEvents:UIControlEventTouchUpInside];
        
        return cell;
        
    }else if( [model.resCode isEqualToString:@"VIDEO"] ){
        
        CSCourseDetailVideoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CSCourseDetailVideoTableViewCell"];
        cell.studyFlag = self.courseDetailModel.studyFlag;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.delegate = self;

        cell.resourceModel = model;
        cell.state = [[TYDownloadSessionManager manager]getDownloadState:model.resource];
        cell.progress = [[TYDownloadSessionManager manager] getCacheProgress:model.resource].progress;
        cell.precourseBtn.tag = indexPath.row;
        [cell.precourseBtn addTarget:self.operation action:@selector(playLiveVideo:) forControlEvents:UIControlEventTouchUpInside];
        [[TYDownloadSessionManager manager] restoreDownload:model.resource WithProgress:^(TYDownloadProgress *progress) {
            cell.progress = progress.progress;
        } state:^(TYDownloadState state, NSString *filePath, NSError *error) {
            cell.state = state;
    
        }];
        
        return cell;
    }else{
        CSCourseDetailArticleTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CSCourseDetailArticleTableViewCell"];
        [cell setResourceCell:model];

        cell.redBtn.tag = indexPath.row;
        [cell.redBtn addTarget:self.operation action:@selector(readArticle:) forControlEvents:UIControlEventTouchUpInside];
        return cell;
    }
}

#pragma mark-CourseDetailCellDelegate
-(void)downResource:(CSCourseResourceModel *)model cell:(CSCourseDetailVideoTableViewCell *)cell{
    //查询该项目下有多少门课程
    NSArray *courseArr =[CSTencentCoreDataManager queryCourseWithProjectId];
    if (courseArr.count < 3) {
        NSMutableArray *courses = [NSMutableArray array];
        for (NSDictionary *courseDic in courseArr) {
                NSInteger courseId = [courseDic[@"courseId"] integerValue];
                NSString *courseIdString = [NSString stringWithFormat:@"%d",courseId];
                if (courseId == [self.courseDetailModel.courseId integerValue]) {
                    
                }else{
                  [courses addObject:courseIdString];
                }
            }
            //数组中是否包含该数据
            if ([courses containsObject:[NSString stringWithFormat:@"%ld",[self.courseDetailModel.courseId integerValue]]]) {
                
            }else{
                ///保存数据库
                [CSTencentCoreDataManager savaCourseDetail:model.courseId withJson:self.jsonModel];
            }
        
    }else if (courseArr.count == 3){
        NSMutableArray *courses = [NSMutableArray array];
        for (NSDictionary *courseDic in courseArr) {
            NSInteger courseId = [courseDic[@"courseId"] integerValue];
            NSString *courseIdString = [NSString stringWithFormat:@"%d",courseId];
                [courses addObject:courseIdString];
        }
        if ([courses containsObject:[NSString stringWithFormat:@"%ld",[self.courseDetailModel.courseId integerValue]]]) {
            
        }else{
            [MBProgressHUD showToView:self.view text:@"该项目下最多只能下载3门课程" afterDelay:1.0 hideBlock:^(MBProgressHUD * _Nonnull hud) {
                
            }];
            return;
        }
    }

        ///下载
    if (cell.state == TYDownloadStateCompleted) {
        UIAlertView * alertView = [[UIAlertView alloc]initWithTitle:@"删除" message:[NSString  stringWithFormat:@"是否删除 %@",model.resName] delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:@"删除", nil];
        [alertView showAlertViewWithCompleteBlock:^(NSInteger buttonIndex) {
            
            if (buttonIndex ==1) {
                /// 下载完成
                [[TYDownloadSessionManager manager]deleteAllFileWithDownloadDirectory:model.resource];
                cell.state = TYDownloadStateNone;
                NSMutableArray *statusArr = [NSMutableArray array];
                for (UITableViewCell *cell in [self.courseDetailTable visibleCells]) {
                    if ([cell isKindOfClass:[CSCourseDetailVideoTableViewCell class]]) {
                        CSCourseDetailVideoTableViewCell *cell2 = (CSCourseDetailVideoTableViewCell *)cell;
                        if ([cell2.resourceModel.resCode isEqualToString:@"VIDEO"]) {
                            [statusArr addObject:cell2];
                        }
                    }
                }
                NSInteger count = 0;
                for (int i = 0; i < statusArr.count; i++) {
                    //如果是最后一个
                    if (i == statusArr.count - 1) {
                        CSCourseDetailVideoTableViewCell *cell = statusArr[i];
                        CSCourseDetailVideoTableViewCell *cell0 = statusArr[0];
                        if (cell.state == cell0.state) {
                            count += 1;
                        }
                    }else{
                        CSCourseDetailVideoTableViewCell *cell = statusArr[i];
                        CSCourseDetailVideoTableViewCell *cell0 = statusArr[i+1];
                        if (cell.state == cell0.state) {
                            count += 1;
                        }
                    }
                }
               //判断count与statusArr的值是否一致
                if (count == statusArr.count) {
                    //将课程相关信息删除
                    [CSTencentCoreDataManager deleteCourseDetail:self.courseDetailModel.courseId];
                }
            }
        }];
    }else{
        ///未下载、暂停下载、开始下载
        [[TYDownloadSessionManager manager]startWithDownloadUrl:model.resource WithProgress:^(TYDownloadProgress *progress) {
            
            cell.progress = progress.progress;
        } state:^(TYDownloadState state, NSString *filePath, NSError *error) {
            cell.state = state;
        }];
    }
}

#pragma mark-UIAlertViewDelegate
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex==1) {

    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    CGRect frame = self.view.bounds;
    [tableView dequeueReusableHeaderFooterViewWithIdentifier:@""];
 
    UIView *headView = [[UIView alloc] initWithFrame:CGRectMake( 8, 0, frame.size.width - 15, 270 + [self getCourseDescriptionHeight] + 147 * (CGRectGetWidth(self.view.frame)/320 - 1))];
    
    UILabel *courseNameLbl = [[UILabel alloc] initWithFrame:CGRectMake( 10, 15, 281, 16)];
    courseNameLbl.font = [UIFont systemFontOfSize:16];
    [headView addSubview:courseNameLbl];
    courseNameLbl.text = self.operation.courseDetailContent.name;
    
    UILabel *courseSpecialNameLbl = [[UILabel alloc] initWithFrame:CGRectMake( 10, 38, 281, 15)];
    courseSpecialNameLbl.font = [UIFont systemFontOfSize:14];
    [headView addSubview:courseSpecialNameLbl];
    courseSpecialNameLbl.text = self.operation.courseDetailContent.specialName;
    
    UIImageView *seplineImg = [[UIImageView alloc] initWithFrame:CGRectMake( 0, 61, CGRectGetWidth(headView.frame), 1)];
    seplineImg.image = [[UIImage imageNamed:@"line_dotline"] resizableImageWithCapInsets:UIEdgeInsetsMake( 0, 0, 0, 0)];
    [headView addSubview:seplineImg];
    
    UILabel *courseCreateTimeLbl = [[UILabel alloc] initWithFrame:CGRectMake( 13, 84, 281, 10)];
    courseCreateTimeLbl.font = [UIFont systemFontOfSize:10];
    [headView addSubview:courseCreateTimeLbl];
    courseCreateTimeLbl.text = self.operation.courseDetailContent.modifiedDate;
    
    UIImageView *courseImg = [[UIImageView alloc] initWithFrame:CGRectMake( 0, 109, CGRectGetWidth(headView.frame), 147 * CGRectGetWidth(self.view.frame)/320)];
    [headView addSubview:courseImg];
    [courseImg setImageWithURL:[NSURL URLWithString:self.operation.courseDetailContent.img]
              placeholderImage:[UIImage imageNamed:@"default_image"]];

    
    UIView *backDescriptionView = [[UIView alloc] initWithFrame:CGRectMake( 0, CGRectGetMaxY(courseImg.frame), CGRectGetWidth(headView.frame), [self getCourseDescriptionHeight] + 20)];
    backDescriptionView.backgroundColor = [UIColor whiteColor];
    [headView addSubview:backDescriptionView];
    
    UILabel *courseDescriptionLbl = [[UILabel alloc] initWithFrame:CGRectMake( 12, 10, CGRectGetWidth(backDescriptionView.frame) - 25, [self getCourseDescriptionHeight])];
    courseDescriptionLbl.font = [UIFont systemFontOfSize:14];
    courseDescriptionLbl.numberOfLines = 0;
    [backDescriptionView addSubview:courseDescriptionLbl];
    courseDescriptionLbl.text = self.operation.courseDetailContent.describe;
    
    
    UIView *bottomView = [[UIView alloc] initWithFrame:CGRectMake( 0, CGRectGetMaxY(backDescriptionView.frame) + 5, CGRectGetWidth(backDescriptionView.frame), 30)];
    bottomView.backgroundColor = [UIColor whiteColor];
    [headView addSubview:bottomView];

    UILabel *resourceTitleLbl = [[UILabel alloc] initWithFrame:CGRectMake( 10, 5, 281, 21)];
    resourceTitleLbl.font = [UIFont systemFontOfSize:16];
    [bottomView addSubview:resourceTitleLbl];
    resourceTitleLbl.text = @"课程内容";
    
    UIImageView *bottomSepLineImg = [[UIImageView alloc] initWithFrame:CGRectMake( 0, 29, CGRectGetWidth(bottomView.frame), 1)];
    bottomSepLineImg.backgroundColor = [UIColor lightGrayColor];
    bottomSepLineImg.alpha = ALPHA;
    [bottomView addSubview:bottomSepLineImg];
    
    return headView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (self.studyType == CSStudyMapType) {
        return  (310 + [self getCourseDescriptionHeight] + 147 * (CGRectGetWidth(self.view.frame)/320 - 1));
    }else {
        return  (310 + [self getCourseDescriptionHeight] + 147 * (CGRectGetWidth(self.view.frame)/320 - 1));
    }
    return 0;
}

/**
 *  计算课程描述的高度
 *
 *  @return 课程描述高度值
 */
- (CGFloat)getCourseDescriptionHeight{
    CGSize size = CGSizeMake( self.view.size.width - 40, MAXFLOAT);
    
    size = [self.operation.courseDetailContent.describe boundingRectWithSize:CGSizeMake(size.width, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName :[UIFont systemFontOfSize:14]} context:nil].size;
    
    return size.height;
}

#pragma mark init method
- (UITableView *)courseDetailTable{

    if ( !_courseDetailTable ) {
        
        CGRect frame = self.view.bounds;
        frame.origin.x = 8;
        frame.size.width -= 15;
        frame.size.height -= (64 + 49);
        _courseDetailTable = [[UITableView alloc] initWithFrame:frame style:UITableViewStyleGrouped];
        _courseDetailTable.delegate = self;
        _courseDetailTable.dataSource = self;

        _courseDetailTable.separatorStyle = UITableViewCellSeparatorStyleNone;
        
        _courseDetailTable.showsVerticalScrollIndicator = NO;
        [_courseDetailTable registerNib:[UINib nibWithNibName:@"CSCourseDetailVideoTableViewCell" bundle:nil]
                 forCellReuseIdentifier:@"CSCourseDetailVideoTableViewCell"];
        [_courseDetailTable registerNib:[UINib nibWithNibName:@"CSCourseDetailTestTableViewCell" bundle:nil]
                 forCellReuseIdentifier:@"CSCourseDetailTestTableViewCell"];
        [_courseDetailTable registerNib:[UINib nibWithNibName:@"CSCourseDetailLiveTableViewCell" bundle:nil]
                 forCellReuseIdentifier:@"CSCourseDetailLiveTableViewCell"];
        [_courseDetailTable registerNib:[UINib nibWithNibName:@"CSCourseDetailArticleTableViewCell" bundle:nil]
                 forCellReuseIdentifier:@"CSCourseDetailArticleTableViewCell"];
        
    }
    return _courseDetailTable;
}

- (NSMutableDictionary *)upCellDic{

    if ( !_upCellDic ) {
        _upCellDic = [NSMutableDictionary dictionary];
    }
    return _upCellDic;
}

- (void)addBottonView{
    /**
     *  如果没有赋值，则默认使用普通课程。
     */
    if ( !self.commonOperationType ) {
        self.commonOperationType = CSNormalCourseDetailBottomView;
    }
    _courseDetailBottomView = [[CSSpecialBottomView alloc] init];
    _courseDetailBottomView.frame = CGRectMake(0, kCSScreenHeight - 49 - 64, kCSScreenWidth, 49);
    _courseDetailBottomView.buttonViewType = self.commonOperationType;
    [self.view addSubview:_courseDetailBottomView];
    _courseDetailBottomView.detailModel = self.operation.courseDetailContent;
    WS(weakSelf);
    //延伸阅读
    _courseDetailBottomView.redActionBlock = ^(){
       CSExtensionReadViewController *readVC = [[CSExtensionReadViewController alloc]init];
        readVC.courseId = weakSelf.operation.courseDetailContent.courseId;
        readVC.extensionReadType = CSExtensionReadCourseType;
         [weakSelf.navigationController pushViewController:readVC animated:YES];
    };
    //评论
    _courseDetailBottomView.commentActionBlock = ^(){
        CSSpecialCommentViewController *commentVC = [[CSSpecialCommentViewController alloc] init];
        commentVC.targetid =
        weakSelf.operation.courseDetailContent.courseId ;
        commentVC.commentType = kCommentCourse;
        
        [weakSelf.navigationController pushViewController:commentVC animated:YES];
    };
    //点赞
    _courseDetailBottomView.praiseActionBlock = ^ (){
        SMClickGlobaPraise *commentPraise = [[SMClickGlobaPraise alloc]init];
        commentPraise.targetId = weakSelf.operation.courseDetailContent.courseId;
        commentPraise.targetType = SMGlobalApiCoursePraise;
        [commentPraise startWithPraiseId:weakSelf.operation.courseDetailContent.praiseId completionBlockWithSuccess:^(id responseJSONObject, NSInteger responseCode) {
            if (responseCode == 0) {
                weakSelf.operation.courseDetailContent.praiseId = responseJSONObject[@"praiseId"];
                if ([weakSelf.operation.courseDetailContent.praiseId integerValue] > 0) {
                    weakSelf.praiseCount += 1;
                    [MBProgressHUD showToView:weakSelf.view text:@"点赞成功" afterDelay:1.0 hideBlock:^(MBProgressHUD * _Nonnull HUD) {
                        
                    }];
                    [weakSelf.courseDetailBottomView.praiseBtn setImage:[UIImage imageNamed:@"icon_yidianzan"] forState:UIControlStateNormal];
                }else{
                    weakSelf.praiseCount -= 1;
                    [MBProgressHUD showToView:weakSelf.view text:@"取消点赞成功" afterDelay:1.0 hideBlock:^(MBProgressHUD * _Nonnull HUD) {
                        
                    }];
                    [weakSelf.courseDetailBottomView.praiseBtn setImage:[UIImage imageNamed:@"icon_dianzan"] forState:UIControlStateNormal];
                }
            }
 
        } withFailure:^(NSError *error) {
             [MBProgressHUD hideToView:weakSelf.view];
        }];
    };
    //分享
    _courseDetailBottomView.shareActionBlock = ^(){
        CSShareView *shareView = [[CSShareView alloc] init];
        shareView.viewController = weakSelf;
        [shareView showShareView];
    };
    //收藏
    _courseDetailBottomView.collectActionBlock = ^(){
        SMGlobalCollect *collect = [[SMGlobalCollect alloc]init];
        collect.targetId = weakSelf.operation.courseDetailContent.courseId;
        collect.targetType = SMGlobalApiCourseCollect;
        if ([weakSelf.operation.courseDetailContent.collectId integerValue] > 0) {
            
        }else{
            collect.titleString = weakSelf.operation.courseDetailContent.name;
        }
        [collect startWithCollectId:weakSelf.operation.courseDetailContent.collectId completionBlockWithSuccess:^(id responseJSONObject, NSInteger responseCode) {
            if (responseCode == 0) {
                weakSelf.operation.courseDetailContent.collectId = responseJSONObject[@"collectId"];
                if ([weakSelf.operation.courseDetailContent.collectId integerValue] > 0) {
                    [MBProgressHUD showToView:weakSelf.view text:@"收藏成功" afterDelay:1.0 hideBlock:^(MBProgressHUD * _Nonnull HUD) {
                        
                    }];

                    [weakSelf.courseDetailBottomView.collectBtn setImage:[UIImage imageNamed:@"icon_yishoucang"] forState:UIControlStateNormal];
                }else{
                    [MBProgressHUD showToView:weakSelf.view text:@"取消收藏成功" afterDelay:1.0 hideBlock:^(MBProgressHUD * _Nonnull HUD) {
                        
                    }];
                    [weakSelf.courseDetailBottomView.collectBtn setImage:[UIImage imageNamed:@"icon_shoucang"] forState:UIControlStateNormal];
                }
            }
        } withFailure:^(NSError *error) {
            [MBProgressHUD hideToView:weakSelf.view];
        }];
    };
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    NSInteger count = 1;
    if (self.changePraiseType == CSChangeePraiseCountType) {
        self.passBrowse(count,self.praiseCount);
    }
}



@end
