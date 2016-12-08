//
//  CSExamResultViewController.m
//  tencent
//
//  Created by bill on 16/5/9.
//  Copyright © 2016年 cyh. All rights reserved.
//

#import "CSExamResultViewController.h"
#import "CSExamResultBottomView.h"
#import "CSFrameConfig.h"
#import "CSUrl.h"
#import "CSHttpRequestManager.h"
#import "CSLookPaperViewController.h"
#import "CSConfig.h"
#import "CSExamResultModel.h"
#import "CSExamResultView.h"
#import "UIView+SDAutoLayout.h"
#import "CSExamContentViewController.h"
#import "NSDictionary+convenience.h"
#import "CSPracticeSkillViewController.h"
#import "CSNotificationConfig.h"
#import "MBProgressHUD+SMHUD.h"
#import "UIBarButtonItem+Common.h"
#import "CSShareView.h"
#import "CSMapCourseDetailViewController.h"
#import "CSNormalCourseDetailViewController.h"
#import "CSCheckPointModel.h"
#import "CSImagePath.h"
#import "CSNotificationConfig.h"
@interface CSExamResultViewController ()<UIScrollViewDelegate>
/**
 *底部view
 */
@property (nonatomic, strong) CSExamResultBottomView *examResultBottomView;
@property (nonatomic, strong) CSExamResultModel *examResultModel;
/**
 *考试结果
 */
@property (nonatomic, strong) CSExamResultView *examResultView;
@property (nonatomic, strong) UIScrollView *scrollView;
@end

@implementation CSExamResultViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"练身手";
    WS(weakSelf);
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem itemWithIcon:@"shareqq" highlightedIcon:@"shareqq" showBadge:NO count:0 actionBolock:^(UIBarButtonItem *item) {
        [weakSelf showShareView];
    }];
    [self loadData];
    // Do any additional setup after loading the view.
}

-(void)backAction{
    
    if (self.examReultType == CSExamResultDataType) {
        if (self.examResultModel.statusName.length > 0) {
            [[NSNotificationCenter defaultCenter] postNotificationName:passToPage object:self userInfo:@{@"whichRow":[NSString stringWithFormat:@"%ld",self.whichRow],@"toPage":self.examResultModel.toPage,@"statusName":self.examResultModel.statusName}];
        }
        if (self.examContentType == CSSkillListType) {
            [self.navigationController popViewControllerAnimated:YES];
        }else{
            [self.navigationController popToRootViewControllerAnimated:YES];
        }
    }else if (self.examReultType == CSExamResultBeforeType || self.examReultType == CSExamResultAfterType){
        [self popToMapDetailVC];
    }else if (self.examReultType == CSStudyResultBeforeType || self.examReultType == CSStudyResultAfterType){
        [self popToCourseDetailVC];
    }else{
        [self.navigationController popViewControllerAnimated:YES];
    }
    
}
//返回到地图关卡详情
-(void)popToMapDetailVC{
    if (self.comeType == CSMapDetailVcComeType) {
        [self.navigationController popViewControllerAnimated:YES];
    }else{
        [self isPassPoint];
    }
}
//返回到课程详情
-(void)popToCourseDetailVC{
    if (self.comeType == CSNormalDetailVcComeType) {
        [self.navigationController popViewControllerAnimated:YES];
    }else{
        for (id vc in self.navigationController.viewControllers) {
            if ([vc isKindOfClass:[CSNormalCourseDetailViewController class]]) {
                [self.navigationController popToViewController:vc animated:YES];
            }
        }
    }
}
- (void)loadData{
    NSMutableDictionary *parames = [NSMutableDictionary dictionary];
    [parames setValue:self.examActivityId forKey:@"examActivityId"];
    [[CSHttpRequestManager shareManager] postDataFromNetWork:GET_EXAM_RESULT parameters:parames success:^(CSHttpRequestManager *manager, id model) {
        self.examResultModel = [[CSExamResultModel alloc]initWithDictionary:model[@"examActivityEntity"] error:nil];
        [self creatExamResultView];
        if ([self.examResultModel.status isEqualToString:@"PROGRESS"]) {
            [self initExamResultBottomViewWithResultType:CSExamResultEvaluationType];
        }else{
        [self initExamResultBottomViewWithResultType:CSExamResultPassType];
        }
    } failture:^(CSHttpRequestManager *manager, id nodel) {
        
    }];
}

- (void)creatExamResultView{
    self.scrollView = [[UIScrollView alloc]initWithFrame:self.view.bounds];
    self.scrollView.contentSize = CGSizeMake(0, 550);
    [self.view addSubview:self.scrollView];
    self.examResultView = [[CSExamResultView alloc]init];
    self.examResultView.examResultModel = self.examResultModel;
    [self.scrollView addSubview:self.examResultView];
    self.examResultView.sd_layout
    .leftSpaceToView(self.scrollView,0)
    .topSpaceToView(self.scrollView,0)
    .widthIs(kCSScreenWidth)
    .autoHeightRatio(0);
}

-(void)initExamResultBottomViewWithResultType:(CSExamResultViewType)resultType{
    self.examResultBottomView = [[CSExamResultBottomView alloc]init];
    self.examResultBottomView.resultViewType = resultType;
        self.examResultBottomView.frame = CGRectMake(0, kCSScreenHeight - 80 - KNavigationHegiht, kCSScreenWidth, 80);
    [self.view insertSubview:self.examResultBottomView aboveSubview:self.examResultView];
    WS(weakSelf);
    //再来一次
    self.examResultBottomView.againCallBackAction = ^(){
        //canTest大于0，则可以进行考试，可以提交
        if ([weakSelf.examResultModel.canTest integerValue] > 0 ) {
            NSMutableDictionary *params = [NSMutableDictionary dictionary];
            [params setValue:weakSelf.examResultModel.examActivityId forKey:@"examActivityId"];
            [[CSHttpRequestManager shareManager] postDataFromNetWork:START_GO_EXAM parameters:params success:^(CSHttpRequestManager *manager, id model) {
                NSNumber *canTest = model[@"canTest"];
                if ([canTest integerValue] > 0 ) {
                    CSExamContentViewController *examContentVC = [[CSExamContentViewController alloc] init];
                    examContentVC.testId = weakSelf.examResultModel.testId;
                    examContentVC.examActivityId = weakSelf.examResultModel.examActivityId;
                    examContentVC.actTestHistoryId = [model numberForKey:@"actTestHistoryId"];
                    examContentVC.actTestAttId = [model numberForKey:@"actTestAttId"];
                    examContentVC.startTimestamp = [model numberForKey:@"startTimestamp"];
                    examContentVC.whichRow = weakSelf.whichRow;
                    examContentVC.examReultType = weakSelf.examReultType;
                    examContentVC.courseId = weakSelf.courseId;
                    examContentVC.tollgateName = weakSelf.tollgateName;
                    examContentVC.nextLevelSuccessAnimation = weakSelf.nextLevelSuccessAnimation;
                    examContentVC.tollgateId = weakSelf.tollgateId;
                    examContentVC.nextLevelFailAnimation = weakSelf.nextLevelFailAnimation;
                    NSInteger examType = 0;
                    examContentVC.examType = [NSNumber numberWithInteger:examType];
                    examContentVC.canTest = canTest;
                    examContentVC.hidesBottomBarWhenPushed = YES;
                    [weakSelf.navigationController pushViewController:examContentVC animated:YES];
                }
            } failture:^(CSHttpRequestManager *manager, id nodel) {
                
            }];
        }else{
        [MBProgressHUD showToView:weakSelf.view text:@"不能再考试了！" afterDelay:2.0 hideBlock:^(MBProgressHUD * _Nonnull hud) {
            
        }];
        }
    };
    //看试卷
    self.examResultBottomView.lookPaperCallBackAction = ^(){
        CSLookPaperViewController *lookPaperVC = [[CSLookPaperViewController alloc]init];
        lookPaperVC.actTestAttId = weakSelf.examResultModel.actTestAttId;
        [weakSelf.navigationController pushViewController:lookPaperVC animated:YES];
    };
    //看错题
    self.examResultBottomView.lookFalseCallBackAction = ^(){
        CSExamContentViewController *examContentVC = [[CSExamContentViewController alloc]init];
        examContentVC.examActivityId = weakSelf.examResultModel.examActivityId;
        examContentVC.examType = @(2);
        [weakSelf.navigationController pushViewController:examContentVC animated:YES];
    };
    //下一步
    self.examResultBottomView.nextCallBackAction = ^(){
        //从练身手进入
        if (weakSelf.examReultType == CSExamResultDataType) {
            [weakSelf backAction];
            //学习地图的课前测试进入
        }else if (weakSelf.examReultType == CSExamResultBeforeType){
            [weakSelf popToMapDetailVC];
            //学习地图的课后测试进入
        }else if (weakSelf.examReultType == CSExamResultAfterType){
          //请求判断当前关卡是否通关的接口
            NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
            [parameters setValue:weakSelf.tollgateId forKey:@"tollgateId"];
            [[CSHttpRequestManager shareManager] postDataFromNetWork:GET_CHECKPOINT_STATUS parameters:parameters success:^(CSHttpRequestManager *manager, id model) {
                if ( [model intForKey:@"code"] == 0 ) {
                    //是否是最后一关
                    NSInteger isLast = [model integerForKey:@"isLast"];
                    //该关是否已通关
                    NSInteger status = [model integerForKey:@"status"];
                    //该关的资源是否已浏览
                    NSInteger isTest = [model integerForKey:@"isTest"];
                    //闯关失败动画
                    NSString * fcartoon = [model objectForKey:@"fcartoon"];
                    //闯关成功动画
                    NSString * cartoon = [model objectForKey:@"cartoon"];
                     CSCheckPointModel *checkPoint = [[CSCheckPointModel alloc]initWithDictionary:model[@"nextToll"] error:nil];
                    //当前关卡已通关
                    if (status) {
                        //是最后一关
                        if (isLast) {
                            UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"温馨提示"
                                                                          message:@"已是最后一关"
                                                                         delegate:nil
                                                                cancelButtonTitle:@"确定"
                                                                otherButtonTitles:nil, nil];
                            [alert show];
                       //如果不是最后一关,则进入下一关
                        }else{
                            CSMapCourseDetailViewController *detailController = [[CSMapCourseDetailViewController alloc] initWithCourseId:checkPoint.courseId CoureseName:checkPoint.name];
                            detailController.tollgateId = checkPoint.tollgateId;;
                            
                            detailController.nextLevelSuccessAnimation = [CSImagePath noEncodeingImageUrl:checkPoint.cartoon];
                            detailController.nextLevelFailAnimation = [CSImagePath noEncodeingImageUrl:checkPoint.fcartoon];
                            detailController.currentLevelSuccessAnimation = cartoon;
                            detailController.currentLevelFailAnimation = fcartoon;
                            [weakSelf.navigationController pushViewController:detailController animated:YES];
                        }
                        //当前关卡未通关
                    }else{
                        CSMapCourseDetailViewController *detailController = [[CSMapCourseDetailViewController alloc] initWithCourseId:weakSelf.courseId CoureseName:weakSelf.tollgateName];
                        detailController.tollgateId = weakSelf.tollgateId;
                        detailController.titleName = weakSelf.tollgateName;
                        detailController.currentLevelSuccessAnimation = weakSelf.nextLevelSuccessAnimation;
                        detailController.currentLevelFailAnimation = weakSelf.nextLevelFailAnimation;
                        [weakSelf.navigationController pushViewController:detailController animated:YES];
                    }
                }
            } failture:^(CSHttpRequestManager *manager, id nodel) {
                
            }];
            
         //学习课程详情的课前测试进入或课后测试进入
        }else if (weakSelf.examReultType == CSStudyResultBeforeType || weakSelf.examReultType == CSStudyResultAfterType){
            [weakSelf popToCourseDetailVC];
        }
        
    };
    [self.view addSubview:self.examResultBottomView];
}

/**
 *判断当前关卡是否通关
 */
-(void)isPassPoint{
                    CSMapCourseDetailViewController *detailController = [[CSMapCourseDetailViewController alloc] initWithCourseId:self.courseId CoureseName:self.tollgateName];
                    detailController.tollgateId = self.tollgateId;;
            detailController.courseId = self.courseId;
                    detailController.nextLevelSuccessAnimation = self.nextLevelSuccessAnimation;
                    detailController.nextLevelFailAnimation = self.nextLevelFailAnimation;
            detailController.titleName = self.tollgateName;
                    [self.navigationController pushViewController:detailController animated:YES];
}

-(void)showShareView{
    CSShareView *shareView = [[CSShareView alloc] init];
    shareView.viewController = self;
    [shareView showShareView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
