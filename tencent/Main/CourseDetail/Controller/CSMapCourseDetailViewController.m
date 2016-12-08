//
//  CSMapCourseDetailViewController.m
//  tencent
//
//  Created by bill on 16/5/4.
//  Copyright © 2016年 cyh. All rights reserved.
//

#import "CSMapCourseDetailViewController.h"
#import "UIViewController+BackButtonHandler.h"
#import "NSDictionary+convenience.h"
#import "CSCourseResourceModel.h"
#import "CSImagePath.h"
#import "CSFrameConfig.h"
#import "CSCheckPointModel.h"
#import "CSCheckPointAnimationView.h"
#import "CSColorConfig.h"
#import "MBProgressHUD+SMHUD.h"
#import "CSMapCheckPointViewController.h"
#import "CSNotificationConfig.h"
#define ANIMATIONVIEWTAG 10000
@interface CSMapCourseDetailViewController ()<UIAlertViewDelegate>

/**
 *  控制闯关动画
 */
@property(nonatomic,strong) NSTimer *timer;

@end

@implementation CSMapCourseDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.commonOperationType = CSMapCourseDetailBottomView;
    self.studyType = CSStudyMapType;
    self.passTollgateId = self.tollgateId;
    self.passTitleName = self.titleName;
    self.passNextLevelFailAnimation = self.nextLevelFailAnimation;
    self.passNextLevelSuccessAnimation = self.nextLevelSuccessAnimation;
    [self setTableFootView];
 
}

-(void)receivePrecourceStatus:(NSNotification *)noti{
  NSString *passStatus = noti.userInfo[@"precourcePass"];
    if ([passStatus isEqualToString:@"pass"]) {
        self.courseDetailModel.studyFlag = 1;
    }
}

-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receivePrecourceStatus:) name:kNotificationPrecourceStatus object:nil];
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
#pragma mark logic
/**
 *  是否需要改写navigationBar返回按钮响应事件
 *
 *  @return 状态
 */
- (BOOL) navigationShouldPopOnBackButton{
    return YES;
}

/**
 *  调整到下一关
 *
 *  @param sender 点击按钮
 */
- (void)nextCheckPoint:(UIButton *)sender{
 
    //是否可以学习
    if( self.operation.courseDetailContent.studyFlag == 0 ){
        CSCheckPointAnimationView *animationView = [[CSCheckPointAnimationView alloc]initWithFrame:self.view.bounds];
        animationView.cartoonString = [CSImagePath noEncodeingImageUrl:self.nextLevelFailAnimation];
        [self.navigationController.view addSubview:animationView];
        [MBProgressHUD showSuccess:@"请先完成课前测验" toView:self.view];
    }else{
        NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
        [parameters setValue:self.tollgateId forKey:@"tollgateId"];
        [MBProgressHUD showMessage:@"加载中..." toView:self.view];
        __weak CSNormalCourseDetailViewController *weakSelf = self;
        [[CSHttpRequestManager shareManager] postDataFromNetWork:GET_CHECKPOINT_STATUS parameters:parameters success:^(CSHttpRequestManager *manager, id model) {
            [MBProgressHUD hideHUDForView:weakSelf.view];
            
            if ( [model intForKey:@"code"] == 0 ) {
                //是否是最后一关
                NSInteger isLast = [model integerForKey:@"isLast"];
                //该关是否已通关
                NSInteger status = [model integerForKey:@"status"];
                //是否可以课后考试
                NSInteger isTest = [model integerForKey:@"isTest"];
                
                CSCheckPointModel *checkPoint = [[CSCheckPointModel alloc]initWithDictionary:model[@"nextToll"] error:nil];
                //当前关卡已经通关
                if (status) {
                    //如果是最后一关
                    if (isLast) {
                        UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"温馨提示"
                                                                      message:@"已是最后一关"
                                                                     delegate:nil
                                                            cancelButtonTitle:@"确定"
                                                            otherButtonTitles:nil, nil];
                        [alert show];
                        //如果不是最后一关,则进入下一关
                    }else{
                        //如果有课后考试，跳转到考试结果页面
                        if (self.afCourseType == hasAfCourseType) {
                            CSCourseResourceModel *resource = [self.resources lastObject];
                            CSExamResultViewController *examResultVC = [[CSExamResultViewController alloc]init];
                            CSCheckPointAnimationView *animationView = [[CSCheckPointAnimationView alloc]initWithFrame:self.view.bounds];
                            
                            animationView.cartoonString = [CSImagePath noEncodeingImageUrl:self.nextLevelSuccessAnimation];
                            [self.navigationController.view addSubview:animationView];

                            examResultVC.tollgateId = self.tollgateId;
                            examResultVC.examReultType = CSExamResultAfterType;
                            examResultVC.examActivityId = resource.examActivityId;
                            animationView.pushToNextVC = ^(){
                                [self.navigationController pushViewController:examResultVC animated:YES];
                            };
                            
                            //跳转到地图详情界面
                        }else{
                            CSMapCourseDetailViewController *detailController = [[CSMapCourseDetailViewController alloc] initWithCourseId:checkPoint.courseId CoureseName:checkPoint.name];
                            detailController.tollgateId = checkPoint.tollgateId;;
                            detailController.titleName = checkPoint.name;
                            CSCheckPointAnimationView *animationView = [[CSCheckPointAnimationView alloc]initWithFrame:self.view.bounds];
                            animationView.cartoonString = [CSImagePath noEncodeingImageUrl:self.nextLevelSuccessAnimation];

                            [self.navigationController.view addSubview:animationView];
                             detailController.examReultType = CSStudyResultBeforeType;
                            detailController.nextLevelSuccessAnimation = [CSImagePath noEncodeingImageUrl:checkPoint.cartoon];
                            detailController.nextLevelFailAnimation = [CSImagePath noEncodeingImageUrl:checkPoint.fcartoon];
                            animationView.pushToNextVC = ^(){
                            [self.navigationController pushViewController:detailController animated:YES];
                            };
                        }
                    }
                }else{//没有通关,判断是否是最后一关
                   
                    if (isTest) {
                        CSCheckPointAnimationView *animationView = [[CSCheckPointAnimationView alloc]initWithFrame:self.view.bounds];
                        
                        animationView.cartoonString = [CSImagePath noEncodeingImageUrl:self.nextLevelFailAnimation];
                        [self.navigationController.view addSubview:animationView];

                        [MBProgressHUD showToView:weakSelf.view text:@"请进行课后测验！" afterDelay:1.0 hideBlock:^(MBProgressHUD * _Nonnull hud) {
                            
                        }];
                    }else{
                        
                        [MBProgressHUD showToView:weakSelf.view text:@"请先浏览关卡资源！" afterDelay:1.0 hideBlock:^(MBProgressHUD * _Nonnull hud) {
                            
                        }];
                    }
                    CSCheckPointAnimationView *animationView = [[CSCheckPointAnimationView alloc]initWithFrame:self.view.bounds];
                    animationView.cartoonString = [CSImagePath noEncodeingImageUrl:self.nextLevelFailAnimation];
                    
                    [self.navigationController.view addSubview:animationView];
                }
            }
        } failture:^(CSHttpRequestManager *manager, id nodel) {
            [MBProgressHUD hideHUDForView:self.view];
            [MBProgressHUD showError:@"请求超时"];
        }];
    }
}

#pragma mark init view
- (void)setTableFootView{
    CGRect frame = self.courseDetailTable.bounds;
    frame.size.height = 60;
    
    UIView *tableFooterV = [[UIView alloc] initWithFrame:frame];
    tableFooterV.backgroundColor = [UIColor clearColor];
    UILabel *line = [[UILabel alloc] initWithFrame:CGRectMake( 0, 0, CGRectGetWidth(frame) , 1.0)];
    [tableFooterV addSubview:line];
    
    UIView *subV = [[UIView alloc] initWithFrame:CGRectMake(0, 0.5, CGRectGetWidth(line.frame), CGRectGetHeight(frame) - 1.0)];
    subV.backgroundColor = [UIColor whiteColor];
    [tableFooterV addSubview:subV];
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(0, 0, subV.frame.size.width, subV.frame.size.height);
    [btn setTitle:@"下一步" forState:UIControlStateNormal];
    [btn setTitleColor:kCSThemeColor forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(nextCheckPoint:) forControlEvents:UIControlEventTouchUpInside];
    [subV addSubview:btn];
    self.courseDetailTable.tableFooterView = tableFooterV;
}

-(void)backAction{
    if (self.examReultType ==CSExamResultBeforeType || self.examReultType == 110) {
        [self.navigationController popViewControllerAnimated:YES];
    }else{
        for (id vc in self.navigationController.viewControllers) {
            if ([vc isKindOfClass:[CSMapCheckPointViewController class]]) {
                [self.navigationController popToViewController:vc animated:YES];
            }
        }
    }
    
}
@end
