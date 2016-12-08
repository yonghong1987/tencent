//
//  CSCourseDetailOPerationModel.m
//  tencent
//
//  Created by bill on 16/5/9.
//  Copyright © 2016年 cyh. All rights reserved.
//

#import "CSCourseDetailOperationModel.h"

#import "CSExamContentViewController.h"
#import "CSExamResultViewController.h"
#import "CSReadArticleViewController.h"

#import "CSProjectDefault.h"
#import "CSCoreDataManager.h"
#import "CSDownLoadCourseModel.h"
#import "CSDownLoadResourceModel.h"

#import "CSUrl.h"
#import "CSMd5.h"
#import "CSConfig.h"
#import "CSImagePath.h"
#import "MBProgressHUD+CYH.h"
#import "CSUserDefaults.h"
#import "CSHttpRequestManager.h"
#import "NSDictionary+convenience.h"
#import <TVKPlayer/TVKPlayer.h>
#import "MBProgressHUD+SMHUD.h"
#import "CSTencentCoreDataManager.h"
#import "TYDownloadSessionManager.h"
#import "AppDelegate.h"
#import "CSTencentCoreDataManager.h"
//测试用privatekey
#define SDK_PRODUCT_PRIVATEKEY  @"f3f1b37dd82f9f2a3f1aaf232d903c2a4fb2b8faa548e72512ad12d72d6a6906a148885451d64d35aa81e862cc421d302776cb4752e0065c3a9af6ed9ce28009"
#define SDK_PRODUCT_APPKEY @"a4XkSJJmpd7frpOVeKchVCBu5Ag2fioCn0cgSyxK5CJP/CH3bJTy12410lS7I18/M1LN2g46qHtsHiihmPhI+xO1lhG2GTu+2lDXS33lgiSGXF07lstPiePfmVWheW9aoGZLbuy7kmzYDY4paY2qQ8+wCfl2wgFcGs3OL8zKp/U="

@interface CSCourseDetailOperationModel ()<UIAlertViewDelegate,TVKMediaPlaybackDelegate,TVKMediaUrlRequestDelegate>


/**
 *  资源模型Id
 */
@property (nonatomic, strong) NSManagedObjectID *resourceModelID;

/**
 *  删除资源的Url
 */
@property (nonatomic, strong) NSString *deleteResourceUrl;

/**
 *  下载的资源模型
 */
@property (nonatomic, strong) CSDownLoadCourseModel *downloadCourseModel;


@end

@implementation CSCourseDetailOperationModel


#pragma mark --
#pragma mark init method
- (id)initCSCourseDetailModel:(CSCourseDetailModel *)detailModel
          CSCourseResourceArray:(NSArray *)resourceAry
           parentViewController:(UIViewController *)parentVC{
    self = [super init];
    if ( self ) {
        self.controlJump = parentVC;
        self.resourceModelAry = resourceAry;
        self.courseDetailContent = detailModel;
    }
    return self;
}

- (NSArray *)resourceModelAry{
    if ( !_resourceModelAry ) {
        _resourceModelAry = [NSArray array];
    }
    return _resourceModelAry;
}


- (NSMutableDictionary *)updateProgessDic{
    if ( !_updateProgessDic ) {
        _updateProgessDic = [NSMutableDictionary dictionary];
    }
    return _updateProgessDic;
}

+ (void)configurationTVKSDK{
    //注册SDK（必须）
    BOOL regSuc = [[TVKSDKManager sharedInstance] registerWithAppKey:SDK_PRODUCT_APPKEY];

    if (regSuc){
        //设置privatekey（必须）
        [TVKSDKManager sharedInstance].productPrivateKey = SDK_PRODUCT_PRIVATEKEY;
 
        //初始化播放（必须）
        [TVKMediaPlayer initializeTVKPlayer];
        
        [[TVKMediaPlayer sharedInstance] enablePlayerFuncWithItem:TVKMediaPlayerFunc_FlyScreen];
        [[TVKMediaPlayer sharedInstance] setIsBanabaSwitchOn:YES];
        [[TVKMediaPlayer sharedInstance] enablePlayerFuncWithItem:TVKMediaPlayerFunc_Download];
        [[TVKMediaPlayer sharedInstance] enablePlayerFuncWithItem:TVKMediaPlayerFunc_JumpNext];
        [[TVKMediaPlayer sharedInstance] enablePlayerFuncWithItem:TVKMediaPlayerFunc_ChooseFormat];
        [[TVKMediaPlayer sharedInstance] enablePlayerFuncWithItem:TVKMediaPlayerFunc_Recomment];
        [[TVKMediaPlayer sharedInstance] enablePlayerFuncWithItem:TVKMediaPlayerFunc_MoreMenu];
        [[TVKMediaPlayer sharedInstance] enablePlayerFuncWithItem:TVKMediaPlayerFunc_DLNA];
        [[TVKMediaPlayer sharedInstance] enablePlayerFuncWithItem:TVKMediaPlayerFunc_AirPlay];
        [[TVKMediaPlayer sharedInstance] enablePlayerFuncWithItem:TVKMediaPlayerFunc_Gesture];
        
    }
    else{
        NSLog(@"registerWithAppKey failed:%d", [TVKSDKManager sharedInstance].authStatus);
    }
    
    //////////////////////////////////////////////////////////////////////
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(pausePlayWithEnterBackground:)
                                                 name:UIApplicationWillResignActiveNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(continuePlayWithEnterBackground:)
                                                 name:UIApplicationDidBecomeActiveNotification
                                               object:nil];
}


//若需要自己控制前后台暂停播放，请做如下操作，否则播放器退后台会自动暂停，进前台会自动播放
+ (void)pausePlayWithEnterBackground:(NSNotification*)noti
{
    //    if (![TVKMediaPlayer sharedInstance].isDLNAActive && ![TVKMediaPlayer sharedInstance].isAirPlayActive) {
    //        [[TVKMediaPlayer sharedInstance] pause];
    //    }
}

+ (void)continuePlayWithEnterBackground:(NSNotification*)noti
{
    //    [[TVKMediaPlayer sharedInstance] play];
}
//


/**
 *  判读能否开始学习
 *
 *  @return 判读结果
 */
- (BOOL)canLearn{
    if ( self.courseDetailContent.studyFlag == 0 ) {
        [MBProgressHUD showSuccess:@"请先通过课前测验" toView:self.controlJump.view];
        return NO;
    }
    return YES;
}

#pragma mark --
#pragma mark 考试
/**
 *  课前测验
 *
 *  @param sender 点击按钮
 */
- (void)examBeforeCourse:(UIButton *)sender{
    
    CSCourseResourceModel *resource = self.resourceModelAry[sender.tag];
    //查询该跳转到哪个界面
    //如果toPage的值为空，则什么都不做
    if ([resource.toPage isEqualToString:@""]) {
        
    }else if ([resource.toPage isEqualToString:@"EXAMRESULT"]){
        CSExamResultViewController *examResultVC = [[CSExamResultViewController alloc]init];
        examResultVC.hidesBottomBarWhenPushed = YES;
        if (self.studyType == CSStudyModelType) {
            examResultVC.examReultType = CSStudyResultBeforeType;
            examResultVC.comeType = CSNormalDetailVcComeType;
        }else if (self.studyType == CSStudyMapType){
           examResultVC.examReultType = CSExamResultBeforeType;
            examResultVC.comeType = CSMapDetailVcComeType;
        }
        //调用资源浏览记录接口
        [self resourceBrowseWithResource:resource];
        examResultVC.tollgateId = self.tollgateId;
        examResultVC.tollgateName = self.tollgateName;
        examResultVC.courseId = self.courseId;
        examResultVC.nextLevelFailAnimation = self.nextLevelFailAnimation;
        examResultVC.nextLevelSuccessAnimation = self.nextLevelSuccessAnimation;
        examResultVC.examActivityId = resource.examActivityId;
        [self.controlJump.navigationController pushViewController:examResultVC animated:YES];
        //如果toPage的值为QUESTIONLIST，则进入考试题目页
    }else if ([resource.toPage isEqualToString:@"QUESTIONLIST"]){
      //如果canTest大于0，则可以进行考试，可以提交
//        if ([resource.canTest integerValue] > 0) {
            NSMutableDictionary *params = [NSMutableDictionary dictionary];
            [params setValue:resource.examActivityId forKey:@"examActivityId"];
            [[CSHttpRequestManager shareManager] postDataFromNetWork:START_GO_EXAM parameters:params success:^(CSHttpRequestManager *manager, id model) {
                NSNumber *canTest = model[@"canTest"];
                if ([canTest integerValue] > 0 ) {
                    //调用资源浏览记录接口
                    [self resourceBrowseWithResource:resource];
                    CSExamContentViewController *examContentVC = [[CSExamContentViewController alloc] init];
//                    examContentVC.testId = resource.examActivityId;
                    examContentVC.examActivityId = resource.examActivityId;
                    examContentVC.tollgateId = self.tollgateId;
                    examContentVC.tollgateName = self.tollgateName;
                    examContentVC.courseId = self.courseId;
                    examContentVC.nextLevelFailAnimation = self.nextLevelFailAnimation;
                    examContentVC.nextLevelSuccessAnimation = self.nextLevelSuccessAnimation;
                    examContentVC.actTestHistoryId = [model numberForKey:@"actTestHistoryId"];
                    examContentVC.actTestAttId = [model numberForKey:@"actTestAttId"];
                    examContentVC.startTimestamp = [model numberForKey:@"startTimestamp"];
                    if (self.studyType == CSStudyModelType) {
                        examContentVC.examReultType = CSStudyResultBeforeType;
                    }else if (self.studyType == CSStudyMapType){
                        examContentVC.examReultType = CSExamResultBeforeType;
                    }

                    NSInteger examType = 0;
                    examContentVC.examType = [NSNumber numberWithInteger:examType];
                    examContentVC.canTest = canTest;
                    examContentVC.hidesBottomBarWhenPushed = YES;
                    [self.controlJump.navigationController pushViewController:examContentVC animated:YES];
                }else{
                    
                    CSExamResultViewController *examResultVC = [[CSExamResultViewController alloc]init];
                    examResultVC.hidesBottomBarWhenPushed = YES;
                    if (self.studyType == CSStudyModelType) {
                        examResultVC.examReultType = CSStudyResultBeforeType;
                        examResultVC.comeType = CSNormalDetailVcComeType;
                    }else if (self.studyType == CSStudyMapType){
                        examResultVC.examReultType = CSExamResultBeforeType;
                        examResultVC.comeType = CSMapDetailVcComeType;
                    }
                    //调用资源浏览记录接口
                    [self resourceBrowseWithResource:resource];
                    examResultVC.tollgateId = self.tollgateId;
                    examResultVC.tollgateName = self.tollgateName;
                    examResultVC.courseId = self.courseId;
                    examResultVC.nextLevelFailAnimation = self.nextLevelFailAnimation;
                    examResultVC.nextLevelSuccessAnimation = self.nextLevelSuccessAnimation;
                    examResultVC.examActivityId = resource.examActivityId;
                    [self.controlJump.navigationController pushViewController:examResultVC animated:YES];
//                [MBProgressHUD showToView:self.controlJump.view text:model[@"tip"] afterDelay:2.0 hideBlock:^(MBProgressHUD * _Nonnull hud) {
//                    
//                }];
                }
            } failture:^(CSHttpRequestManager *manager, id nodel) {
                
            }];

    }
}

/**
 *  课后测验
 *
 *  @param sender 点击按钮
 */
- (void)examAfterCourse:(UIButton *)sender{
    
    if( 0 == self.courseDetailContent.studyFlag ){
        [MBProgressHUD showSuccess:@"请先通过课前测验" toView:self.controlJump.view];
    }else{
    
        CSCourseResourceModel *resource = self.resourceModelAry[sender.tag];
       
        //查询该跳转到哪个界面
        //如果toPage的值为空，则什么都不做
        if ([resource.toPage isEqualToString:@""]) {
            
        }else if ([resource.toPage isEqualToString:@"EXAMRESULT"]){
            //调用资源浏览记录接口
            [self resourceBrowseWithResource:resource];
            CSExamResultViewController *examResultVC = [[CSExamResultViewController alloc]init];
            examResultVC.hidesBottomBarWhenPushed = YES;
            if (self.studyType == CSStudyModelType) {
                examResultVC.examReultType = CSStudyResultAfterType;
                examResultVC.comeType = CSNormalDetailVcComeType;
            }else if (self.studyType == CSStudyMapType){
                examResultVC.examReultType = CSExamResultAfterType;
                examResultVC.comeType = CSMapDetailVcComeType;
            }
            
            examResultVC.examActivityId = resource.examActivityId;
            examResultVC.tollgateId = self.tollgateId;
            examResultVC.tollgateName = self.tollgateName;
            examResultVC.courseId = self.courseId;
            examResultVC.nextLevelFailAnimation = self.nextLevelFailAnimation;
            examResultVC.nextLevelSuccessAnimation = self.nextLevelSuccessAnimation;
            [self.controlJump.navigationController pushViewController:examResultVC animated:YES];
            //如果toPage的值为QUESTIONLIST，则进入考试题目页
        }else if ([resource.toPage isEqualToString:@"QUESTIONLIST"]){
            //如果canTest大于0，则可以进行考试，可以提交
            if ([resource.canTest integerValue] > 0) {
                NSMutableDictionary *params = [NSMutableDictionary dictionary];
                [params setValue:resource.examActivityId forKey:@"examActivityId"];
                [[CSHttpRequestManager shareManager] postDataFromNetWork:START_GO_EXAM parameters:params success:^(CSHttpRequestManager *manager, id model) {
                    NSNumber *canTest = model[@"canTest"];
                    if ([canTest integerValue] > 0 ) {
                        //调用资源浏览记录接口
                        [self resourceBrowseWithResource:resource];
                        CSExamContentViewController *examContentVC = [[CSExamContentViewController alloc] init];
                        examContentVC.testId = resource.examActivityId;
                        examContentVC.examActivityId = resource.examActivityId;
                        examContentVC.actTestHistoryId = [model numberForKey:@"actTestHistoryId"];
                        //                    examContentVC.whichRow = indexPath.row;
                        examContentVC.actTestAttId = [model numberForKey:@"actTestAttId"];
                        examContentVC.startTimestamp = [model numberForKey:@"startTimestamp"];
                        if (self.studyType == CSStudyModelType) {
                            examContentVC.examReultType = CSStudyResultAfterType;
                        }else if (self.studyType == CSStudyMapType){
                            examContentVC.examReultType = CSExamResultAfterType;
                        }

                        NSInteger examType = 0;
                        examContentVC.tollgateId = self.tollgateId;
                        examContentVC.tollgateName = self.tollgateName;
                        examContentVC.courseId = self.courseId;
                        examContentVC.nextLevelFailAnimation = self.nextLevelFailAnimation;
                        examContentVC.nextLevelSuccessAnimation = self.nextLevelSuccessAnimation;
                        examContentVC.examType = [NSNumber numberWithInteger:examType];
                        examContentVC.canTest = canTest;
                        examContentVC.hidesBottomBarWhenPushed = YES;
                        [self.controlJump.navigationController pushViewController:examContentVC animated:YES];
                    }else{
                     [MBProgressHUD showToView:self.controlJump.view text:@"不能参加课后考试" afterDelay:2.0 hideBlock:^(MBProgressHUD * _Nonnull hud) {
                         
                     }];
                    }
                } failture:^(CSHttpRequestManager *manager, id nodel) {
                    
                }];
                //如果canTest等于0，则只可以查看，不能提交
            }else{
                //调用资源浏览记录接口
                [self resourceBrowseWithResource:resource];
                CSExamContentViewController *examContentVC = [[CSExamContentViewController alloc] init];
                examContentVC.testId = resource.examActivityId;
                examContentVC.examActivityId = resource.examActivityId;
                NSInteger examType = 0;
                examContentVC.canTest = resource.canTest;
                examContentVC.tollgateId = self.tollgateId;
                examContentVC.examType = [NSNumber numberWithInteger:examType];
                if (self.studyType == CSStudyModelType) {
                    examContentVC.examReultType = CSStudyResultAfterType;
                }else if (self.studyType == CSStudyMapType){
                    examContentVC.examReultType = CSExamResultAfterType;
                }
                examContentVC.hidesBottomBarWhenPushed = YES;
                [self.controlJump.navigationController pushViewController:examContentVC animated:YES];
            }
        }
    }
}


#pragma mark 浏览文章和课件
/**
 *  阅读文章
 *
 *  @param sender 点击按钮
 */
- (void)readArticle:(UIButton *)sender{
    
    if ( [self canLearn] ) {

        CSCourseResourceModel *model = self.resourceModelAry[sender.tag];
        //调用资源浏览记录接口
        [self resourceBrowseWithResource:model];
        CSReadArticleViewController *readArticleVC = [[CSReadArticleViewController alloc] init];
        readArticleVC.resourceId = model.resId;
        readArticleVC.resourceTitle = model.resName;
        readArticleVC.resourceContent = model.resourceContent;
        [self.controlJump.navigationController pushViewController:readArticleVC animated:YES];
    }
}

#pragma mark 视频相关的操作
#pragma mark 直播和点播视频；视频下载和删除
/**
 *  点播视频
 *
 *  @param sender 点击按钮
 */
- (void)playVideo:(UIButton *)sender{
    if( [self canLearn] ){
 
        CSCourseResourceModel *model = self.resourceModelAry[sender.tag];
        [self playVideoInfo:model];
    }
}

/**
 *  直播视频
 *
 *  @param sender 点击按钮
 */
- (void)playLiveVideo:(UIButton *)sender{
    
    if ( [self canLearn] ) {
        CSCourseResourceModel *model = self.resourceModelAry[sender.tag];
        //调用资源浏览记录接口
//        [self resourceBrowseWithResource:model];
        [self playVideoInfo:model];

    }
}


/**
 *  播放视频
 *
 *  @param model 资源模型
 */
- (void)playVideoInfo:(CSCourseResourceModel *)resourceModel{
    //调用资源浏览记录接口
    [self resourceBrowseWithResource:resourceModel];
    //初始化播放器
    TVKMediaPlayer* player = [TVKMediaPlayer sharedInstance];
    player.videoTitle = resourceModel.resName;
    player.delegate = self;
    [player presentMediaPlayerWithViewController:self];
    
    if ( [resourceModel.resCode isEqualToString:@"VIDEO"] ){
        /**
         *  视频点播：若已下载到本地则打开本地文件；若没有成功下载则播放服务器端文件
         */
        self.resourceUrl = resourceModel.resource;
        self.resourceModel = resourceModel;
        //取出播放时长
        float playProgress = [CSTencentCoreDataManager queryVedioPlayProgressWithResourceUrl:self.resourceUrl];
        TYDownloadState  state =  [[TYDownloadSessionManager manager]getDownloadState:resourceModel.resource];
        if (self.courseDetailContent.studyFlag == 1) {
            if (state == TYDownloadStateCompleted) {
                TYDownloadProgress * progress = [[TYDownloadSessionManager manager]getCacheProgress:resourceModel.resource];
                [self playVideoUrl:progress.filePath videoID:@"" type:resourceModel.resCode title:resourceModel.resName startPostion:playProgress];
            }else{
                [self playVideoUrl:resourceModel.resource videoID:@"" type:resourceModel.resCode title:resourceModel.resName startPostion:playProgress];
            }
        }else{
            [MBProgressHUD showToView:self.controlJump.view text:@"请先学习课前测验" afterDelay:1.0 hideBlock:^(MBProgressHUD * _Nonnull hud) {
                
            }];
            return;
        }
    }else if( [resourceModel.resCode isEqualToString:@"LIVEVIDEO"] ){
        /**
         *  根据Video测试视频直播功能
         */
        BOOL isTestLiveVideo = YES;
        if( isTestLiveVideo ){
            [player openMediaPlayerWithChannelID:@"100105500"];
        }else{

            
            NSMutableDictionary *params = [NSMutableDictionary dictionaryWithDictionary:
                                           @{@"resId":resourceModel.resId}];
            [MBProgressHUD showMessage:@"加载中..." toView:self.controlJump.view];
            
            __weak CSCourseDetailOperationModel *weakSelf = self;
            [[CSHttpRequestManager shareManager] postDataFromNetWork:CHECK_LIVEVIDEO parameters:params success:^(CSHttpRequestManager *manager, id model) {
                [MBProgressHUD hideHUDForView:weakSelf.controlJump.view];

                switch ( [model integerForKey:@"isPlay"] ) {
                    case 1:{
                        [MBProgressHUD showMessage:@"直播已结束" toView:weakSelf.controlJump.view];
                    }
                        break;
                    case 2:{
                        [MBProgressHUD showMessage:@"还没到开始时间" toView:weakSelf.controlJump.view];
                    }
                        break;
                    case 3:{
                        [player openMediaPlayerWithUrl:resourceModel.resource live:YES videoID:@"" startPosition:0.0];
                    }
                        break;
                    default:{
                        [MBProgressHUD showMessage:@"网络君好像喝茶去了，再刷新下试试!" toView:weakSelf.controlJump.view];
                    }
                        break;
                }
            } failture:^(CSHttpRequestManager *manager, id nodel) {
                [MBProgressHUD hideHUDForView:weakSelf.controlJump.view];
                [MBProgressHUD showError:@"直播出错"];
            }];
        }
    }
}

-(void)playVideoUrl:(NSString *)url videoID:(NSString *)videoID type:(NSString *)type title:(NSString *)title startPostion:(float)postion
{
    TVKMediaPlayer* player = [TVKMediaPlayer sharedInstance];
    player.videoTitle = title;
    player.videoTitleMark = @"";
    player.delegate = self;
    NSLog(@"[CSAppDelegate sharedInstance].timeDuration:%f",[AppDelegate sharedInstance].timeDuration);
    if ((int)postion==(int)[AppDelegate sharedInstance].timeDuration) {
        postion=0;
    }
    //在播放前打开播放器界面
    [player presentMediaPlayerWithViewController:self.controlJump];
    if ([type isEqualToString:@"VIDEO"]) {
        [player openMediaPlayerWithUrl:url live:NO videoID:nil startPosition:postion];
    }else if([type isEqualToString:@"LIVEVIDEO"]){
        [player openMediaPlayerWithChannelID:videoID];
    }
    [player removeCustomViewWithLayerID:TVKMediaPlayerCustomLayerIDBegin+1 smallOrMainPlayer:NO];
    [player removeCustomViewWithLayerID:TVKMediaPlayerCustomLayerIDBegin+2 smallOrMainPlayer:NO];
    NSString *str=[[CSUserDefaults shareUserDefault] getUserName];
    if (str.length>0) {
        NSMutableString* muStr=[NSMutableString string];
        CGSize muSize=[muStr sizeWithFont:[UIFont systemFontOfSize:22.0]];
        while (muSize.width<600.0) {
            [muStr appendString:str];
            muSize=[muStr sizeWithFont:[UIFont systemFontOfSize:22.0]];
        }
        UILabel* lb=[[UILabel alloc] initWithFrame:CGRectMake(-100.0,-10.0,600.0, 30.0)];
        lb.backgroundColor=[UIColor clearColor];
        lb.textColor = [UIColor colorWithRed:200.0/255.0 green:200.0/255.0 blue:200.0/255.0 alpha:0.8];
        lb.font = [UIFont fontWithName:@"Verdana" size:17];
        lb.textAlignment=NSTextAlignmentCenter;
        
        lb.text=[NSString stringWithFormat:@"%@",muStr];
        lb.transform=CGAffineTransformMakeRotation(M_PI/180.0*(-20.0));
        UILabel* twoLb=[[UILabel alloc] initWithFrame:CGRectMake(40.0,300.0,600.0, 30.0)];
        twoLb.backgroundColor=[UIColor clearColor];
        twoLb.textColor=[UIColor colorWithRed:200.0/255.0 green:200.0/255.0 blue:200.0/255.0 alpha:0.8];
        twoLb.font=[UIFont fontWithName:@"Verdana" size:17];
        twoLb.textAlignment=NSTextAlignmentCenter;
        twoLb.text =[NSString stringWithFormat:@"%@",muStr];
        twoLb.transform=CGAffineTransformMakeRotation(M_PI/180.0*(-20.0));
        
        [player addCustomView:lb withLayerID:TVKMediaPlayerCustomLayerIDBegin+1 smallOrMainPlayer:NO];
        [player addCustomView:twoLb withLayerID:TVKMediaPlayerCustomLayerIDBegin+2 smallOrMainPlayer:NO];
    }
}
#pragma mark - TVKMediaPlaybackDelegate
- (NSString*)mediaPlayer:(TVKMediaPlayer*)mediaPlayer willPlayUrl:(NSString*)url
{
    NSLog(@"willPlayUrl:%@", url);
    return url;
}

- (void)mediaPlayer:(TVKMediaPlayer*)mediaPlayer stateChanged:(TVKMediaPlayerState)state withError:(NSError*)error
{
    if(state==11){
        [self recordeInfo];
    }else if(state==14){
        [self recordeInfo];
    }
}

//记录视频播放时间，并传给后台
-(void)recordeInfo{
    [CSTencentCoreDataManager saveVedioPlayTime:self.vedioProgress resourceUrl:self.resourceUrl];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setValue:self.courseDetailContent.courseId forKey:@"courseId"];
    [params setValue:self.resourceModel.resId forKey:@"resId"];
    [params setValue:self.resourceModel.modId forKey:@"modId"];
    NSInteger attemptPeriod = roundf(self.vedioProgress * 1000);
    NSInteger totalPeriod = roundf(self.timeDuration * 1000);
    [params setValue:@(attemptPeriod) forKey:@"attemptPeriod"];
    [params setValue:@(totalPeriod) forKey:@"totalPeriod"];
    [[CSHttpRequestManager shareManager] postDataFromNetWork:RECORD_INFO parameters:params success:^(CSHttpRequestManager *manager, id model) {
        
    } failture:^(CSHttpRequestManager *manager, id nodel) {
        
    }];
}
- (void)mediaPlayer:(TVKMediaPlayer*)mediaPlayer screenChanged:(BOOL)fullScreen
{
    NSLog(@"self.view:%@",self.controlJump.view);
    NSLog(@"screenChanged:%d", fullScreen);
}

- (void)mediaPlayer:(TVKMediaPlayer*)mediaPlayer eventOccur:(TVKMediaPlayerEvent)event userInfo:(NSDictionary*)userInfo
{
    NSLog(@"eventOccur:%d userInfo:%@", event, userInfo);
    if (event == TVKMediaPlayerEventSkipAD) {
        [mediaPlayer skipAdertisement];
    }else if (event == TVKMediaPlayerEventChangeVideo) {
        NSLog(@"%@", userInfo);
    }
}

- (void)mediaPlayer:(TVKMediaPlayer*)mediaPlayer progressUpdated:(NSTimeInterval)currentTime duration:(NSTimeInterval)duration
{
    
    self.vedioProgress = (float)currentTime;
    [AppDelegate sharedInstance].timeDuration=duration;
    self.timeDuration = duration;
    NSLog(@"progressUpdated:%lf duration:%lf", currentTime, duration);
    
}

#pragma mark - TVKMediaUrlRequestDelegate
- (void)didMediaUrlRequestFinished:(TVKMediaUrlRequest*)request videoUrls:(NSArray*)videoUrls viedoDurations:(NSArray*)videoDurations
{
    NSLog(@"videoUrls:%@", videoUrls);
    NSLog(@"videoDurations:%@", videoDurations);
}

- (void)didMediaUrlRequestUpdated:(TVKMediaUrlRequest*)request videoUrls:(NSArray*)videoUrls viedoDurations:(NSArray*)videoDurations
{
    NSLog(@"videoUrls:%@", videoUrls);
    NSLog(@"videoDurations:%@", videoDurations);
}

- (void)didMediaUrlRequestFailed:(TVKMediaUrlRequest*)request error:(NSError*)error
{
    NSLog(@"%@", error);
}

 //调用资源浏览数记录接口
-(void)resourceBrowseWithResource:(CSCourseResourceModel *)resource
{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setValue:resource.resId forKey:@"resId"];
    [params setValue:resource.modId forKey:@"modId"];
    [params setValue:self.courseDetailContent.courseId forKey:@"courseId"];
[[CSHttpRequestManager shareManager] postDataFromNetWork:RESOURCE_BROWSE parameters:params success:^(CSHttpRequestManager *manager, id model) {
    
} failture:^(CSHttpRequestManager *manager, id nodel) {
    
}];
}
@end
