//
//  CSExamContentViewController.m
//  tencent
//
//  Created by bill on 16/5/9.
//  Copyright © 2016年 cyh. All rights reserved.
//

#import "CSExamContentViewController.h"
#import "CSTitleTagChooseView.h"
#import "CSTitleTemplateViewController.h"
#import "CSCommitCaseAnswerView.h"
#import "CSQuestionViewController.h"
#import "CSJudgeViewController.h"
#import "CSFillViewController.h"
#import "CSCommitAnswerModel.h"
#import "AppDelegate+Category.h"
#import "CSConfig.h"

#import "CSTotalScoreVIew.h"
@interface CSExamContentViewController ()<UIAlertViewDelegate,CSTitleTemplateDelegate>
//上一题、下一题视图view
@property (nonatomic, strong) CSTitleTagChooseView *tagChooseView;
@property (nonatomic, strong) NSMutableArray *viewControllers;
@property (nonatomic, strong) NSMutableArray *titleArray;
@property (nonatomic, strong) CSTitleTemplateViewController *titleTemplateVC;
@property (nonatomic, strong) CSCommitCaseAnswerView *commitAnswerView;
@property (nonatomic, strong) CSExaminationPaperModel *paperModel;
//是否可以作答
@property (nonatomic, strong) NSNumber *canAnswer;
//是否显示答案
@property (nonatomic, strong) NSNumber *displayAnswer;

/**
 *点击的需要显示哪道试题
 */
@property (nonatomic, assign) NSInteger index;
/**
 *显示总分、及格分
 */
@property (nonatomic, strong) CSTotalScoreVIew *totalScoreView;
@end

@implementation CSExamContentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"考试题目";
    self.index = 1;
    self.viewControllers = [NSMutableArray array];
    self.titleArray = [NSMutableArray array];
    self.automaticallyAdjustsScrollViewInsets = false;
    [self loadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [[AppDelegate sharedInstance]deleteAnswerData];
    [CSCommitAnswerModel removeDicKey];
}

//获取试卷信息
#pragma mark logic method
- (void)loadData{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters setValue:self.examActivityId forKey:@"examActivityId"];
    [parameters setValue:self.examType forKey:@"type"];
    [[CSHttpRequestManager shareManager] postDataFromNetWork:GET_EXAMINATION_PAPER parameters:parameters success:^(CSHttpRequestManager *manager, id model) {
        self.paperModel = [CSParserExamDataModel parserExamPaperDataWithDictionary:model];
        self.canAnswer = [CSParserExamDataModel getCanAnswerDataWithDictionary:model];
        self.displayAnswer = [CSParserExamDataModel getDisplayAnswerDataWithDictionary:model];
        CSExamResultModel *examResultModel = self.paperModel.examResultModel;
        self.totalScoreView = [[CSTotalScoreVIew alloc]init];
        if ([examResultModel.canAnswer boolValue]) {
            self.totalScoreView.frame = CGRectMake(0, 0, kCSScreenWidth, 30);
        }else{
        self.totalScoreView.frame = CGRectMake(0, 0, kCSScreenWidth, 50);
        }
        self.totalScoreView.examResultModel = examResultModel;
        
        [self.view addSubview:self.totalScoreView];
        self.titleArray  = self.paperModel.allTitleArray;
        if (self.titleArray.count > 0) {
            [self creatExamVCWithRadioModel:self.titleArray[0]];
        }
        
        if (self.titleArray.count > 1) {
            [self creatBottomView];
        }else if(self.titleArray.count == 1){
            if ([self.canTest integerValue] > 0) {
                [self creatSingleTitleCommitView];
            }
        }
        [self.tagChooseView.indexBtn setTitle:[NSString stringWithFormat:@"1/%ld",self.titleArray.count] forState:UIControlStateNormal];
    } failture:^(CSHttpRequestManager *manager, id nodel) {
        
    }];
}


-(void)creatExamVCWithRadioModel:(CSRadioModel *)radioModel{
    if ([radioModel.questionType isEqualToString:kTopicSingleType]) {
        CSExamRadioViewController *radioVC = [[CSExamRadioViewController alloc]init];
            radioVC.radioModel = radioModel;
            radioVC.canAnswer = self.canAnswer;
            radioVC.displayAnswer = self.displayAnswer;
            [self loadViewController:radioVC];
    }else if ([radioModel.questionType isEqualToString:kTopicNoItemType] || [radioModel.questionType isEqualToString:kTopicMultiSelectType]){
        CSMultiChoiceViewController *multiVC = [[CSMultiChoiceViewController alloc]init];
                        multiVC.radioModel = radioModel;
                        multiVC.canAnswer = self.canAnswer;
                        multiVC.displayAnswer = self.displayAnswer;
                        [self loadViewController:multiVC];
    }else if ([radioModel.questionType isEqualToString:kTopicQuestionType]){
        CSQuestionViewController *questionVC = [[CSQuestionViewController alloc]init];
                        questionVC.radioModel = radioModel;
                     questionVC.canAnswer = self.canAnswer;
                    questionVC.displayAnswer = self.displayAnswer;
        [self loadViewController:questionVC];

    }else if ([radioModel.questionType isEqualToString:kTopicJudgeType]){
        CSJudgeViewController *judgeVC = [[CSJudgeViewController alloc]init];
                        judgeVC.radioModel = radioModel;
                        judgeVC.canAnswer = self.canAnswer;
                        judgeVC.displayAnswer = self.displayAnswer;
                        [self loadViewController:judgeVC];
    }else if ([radioModel.questionType isEqualToString:kTopicFillType]){
        CSFillViewController *fillVC = [[CSFillViewController alloc]init];
                        fillVC.canAnswer = self.canAnswer;
                    fillVC.radioModel = radioModel;
        NSInteger titleTag = [self.titleArray indexOfObject:radioModel];
        fillVC.titleTag = titleTag;;
        fillVC.titleCount = self.titleArray.count;
        [self loadViewController:fillVC];
    }
}

- (void)loadViewController:(UIViewController *)vc{
    NSInteger subViewIndex = [[self childViewControllers] count];
    [self addChildViewController:vc];
     CSExamResultModel *examResultModel = self.paperModel.examResultModel;
    if ([examResultModel.canAnswer boolValue]) {
         vc.view.frame = CGRectMake(0, 30, kCSScreenWidth, kCSScreenHeight - 30 );
    }else{
         vc.view.frame = CGRectMake(0, 50, kCSScreenWidth, kCSScreenHeight - 50);
    }
    [self.view insertSubview:vc.view atIndex:subViewIndex];
    
    for ( UIViewController *tempVC in [self childViewControllers] ) {
        if ( ![tempVC isEqual:vc] ) {
            [tempVC.view removeFromSuperview];
            [tempVC removeFromParentViewController];
        }
    }
}

-(void)creatBottomView{
    self.tagChooseView = [[CSTitleTagChooseView alloc]initWithFrame:CGRectMake(0, kCSScreenHeight - KNavigationHegiht - 50, kCSScreenWidth, 50)];
    [self.tagChooseView.leftBtn addTarget:self action:@selector(leftTitleAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.tagChooseView.rightBtn addTarget:self action:@selector(rightTitleAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.tagChooseView];
}

-(void)creatSingleTitleCommitView{
 self.commitAnswerView = [[CSCommitCaseAnswerView alloc]initWithFrame:CGRectMake(0, kCSScreenHeight - KNavigationHegiht - 50, kCSScreenWidth, 50)];
    WS(weakSelf);
    self.commitAnswerView.commitAction = ^(){
        [weakSelf commitAnswer];
    };
    [self.view addSubview:self.commitAnswerView];
}
//点击上一题
-(void)leftTitleAction:(UIButton *)sender{
    
    if (self.index == 1) {
        [self.tagChooseView.leftBtn setTitle:@"" forState:UIControlStateNormal];
        return;
    }else{
         self.index --;
        if (self.index == 1) {
            [self.tagChooseView.leftBtn setTitle:@"" forState:UIControlStateNormal];
        }else{
         [self.tagChooseView.leftBtn setTitle:@"上一题" forState:UIControlStateNormal];
        }
        [self.tagChooseView.indexBtn setTitle:[NSString stringWithFormat:@"%ld/%ld",self.index,self.titleArray.count] forState:UIControlStateNormal];
        [self.tagChooseView.rightBtn setTitle:@"下一题" forState:UIControlStateNormal];
        [self creatExamVCWithRadioModel:self.titleArray[self.index - 1] ];
    }
   
    NSLog(@"indexindex:%ld",self.index);
}
//点击下一题
-(void)rightTitleAction:(UIButton *)sender{
    
    if (self.index == self.titleArray.count) {
        if ([self.canAnswer integerValue] > 0) {
            [self.tagChooseView.rightBtn setTitle:@"提交" forState:UIControlStateNormal];
            [self commitAnswer];
        }else{
            [self.tagChooseView.rightBtn setTitle:@"" forState:UIControlStateNormal];
        }
        return;
    }else{
         self.index ++;
        if (self.index == self.titleArray.count) {
            if ([self.canAnswer integerValue] > 0) {
                [self.tagChooseView.rightBtn setTitle:@"提交" forState:UIControlStateNormal];
            }else{
            [self.tagChooseView.rightBtn setTitle:@"" forState:UIControlStateNormal];
            }
            
        }else{
        [self.tagChooseView.rightBtn setTitle:@"下一题" forState:UIControlStateNormal];
        }
        [self.tagChooseView.indexBtn setTitle:[NSString stringWithFormat:@"%ld/%ld",self.index,self.titleArray.count] forState:UIControlStateNormal];
        [self.tagChooseView.leftBtn setTitle:@"上一题" forState:UIControlStateNormal];
        [self creatExamVCWithRadioModel:self.titleArray[self.index - 1]];
    }
   NSLog(@"indexindex:%ld",self.index);
}

#pragma mark CSTitleTemplateDelegate
- (void)passCollectionViewScrollWhichIndex:(NSInteger)index{
    if (index == self.viewControllers.count - 1) {
        [self.tagChooseView.indexBtn setTitle:[NSString stringWithFormat:@"%ld/%ld",self.titleTemplateVC.currentIndex + 1,self.viewControllers.count] forState:UIControlStateNormal];
        [self.tagChooseView.leftBtn setTitle:@"上一题" forState:UIControlStateNormal];
        [self.tagChooseView.rightBtn setTitle:@"提交" forState:UIControlStateNormal];
    }else if (index == 0){
        [self.tagChooseView.indexBtn setTitle:[NSString stringWithFormat:@"%ld/%ld",self.titleTemplateVC.currentIndex + 1,self.viewControllers.count] forState:UIControlStateNormal];
        [self.tagChooseView.leftBtn setTitle:@"" forState:UIControlStateNormal];
        [self.tagChooseView.rightBtn setTitle:@"下一题" forState:UIControlStateNormal];
    }else{
        [self.tagChooseView.indexBtn setTitle:[NSString stringWithFormat:@"%ld/%ld",self.titleTemplateVC.currentIndex + 1,self.viewControllers.count] forState:UIControlStateNormal];
        [self.tagChooseView.leftBtn setTitle:@"上一题" forState:UIControlStateNormal];
        [self.tagChooseView.rightBtn setTitle:@"下一题" forState:UIControlStateNormal];
    }
}

-(void)commitAnswer{
    
    if ([self.canTest integerValue] > 0) {
        NSMutableDictionary *commitAnswerDic = [CSCommitAnswerModel getCommitAnswerDictionaryWithExaminationPaper:self.paperModel];
        [commitAnswerDic setValue:self.testId forKey:@"testId"];
        [commitAnswerDic setValue:self.examActivityId forKey:@"examActivityId"];
        [commitAnswerDic setValue:self.actTestAttId forKey:@"actTestAttId"];
        [commitAnswerDic setValue:self.startTimestamp forKey:@"startTimestamp"];
        [commitAnswerDic setValue:self.actTestHistoryId forKey:@"actTestHistoryId"];
        [[CSHttpRequestManager shareManager] postDataFromNetWork:SAVE_EXAM_ANSWER parameters:commitAnswerDic success:^(CSHttpRequestManager *manager, id model) {
            if ([model[@"code"] integerValue] == 0) {
                [CSCommitAnswerModel removeDicKey];
                //答案提交成功后   跳转到考试结果页
                CSExamResultViewController *examResultVC = [[CSExamResultViewController alloc]init];
                examResultVC.hidesBottomBarWhenPushed = YES;
                examResultVC.examActivityId = self.examActivityId;
                examResultVC.examReultType = self.examReultType;
                examResultVC.tollgateId = self.tollgateId;
                examResultVC.courseId = self.courseId;
                examResultVC.tollgateName = self.tollgateName;
                examResultVC.nextLevelFailAnimation = self.nextLevelFailAnimation;
                examResultVC.nextLevelSuccessAnimation = self.nextLevelSuccessAnimation;
                examResultVC.whichRow = self.whichRow;
                [self.navigationController pushViewController:examResultVC animated:YES];
            }
        } failture:^(CSHttpRequestManager *manager, id nodel) {
            
        }];
    }else{
        NSLog(@"不能提交答案");
    }
    
}
@end
