//
//  CSJudgeViewController.m
//  tencent
//
//  Created by cyh on 16/8/17.
//  Copyright © 2016年 cyh. All rights reserved.
//

#import "CSJudgeViewController.h"
#import "CSFrameConfig.h"
#import "CSTableHeadWebView.h"
#import "CSConfig.h"
#import "CSJudgeCell.h"
#import "CSOptionModel.h"
#import "NSDictionary+convenience.h"
#import "CSColorConfig.h"
#import "UITableView+SDAutoTableViewCellHeight.h"
#import "SMBaseTableView.h"
#import "CSGlobalMacro.h"
@interface CSJudgeViewController ()<UIWebViewDelegate,UITableViewDelegate,UITableViewDataSource>
/**
 *  问题表单
 */
@property (nonatomic, strong) SMBaseTableView *questionTable;


/**
 *  问题题目高度
 */
@property (nonatomic, assign) CGFloat questionTitleHeight;

/**
 *  tableViewHead
 */
@property (nonatomic, strong)CSTableHeadWebView *tableHeadView;
/**
 *  判断webview是否加载完成
 */
@property (nonatomic, assign) BOOL isComplete;


@end

@implementation CSJudgeViewController

static NSString *const judgeCellIdentifier = @"judgeCell";

- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = false;
    self.isComplete = false;
    [self addQuestionTable];
//    if (self.radioModel) {
//        [self.questionTable reloadData];
//    }
    // Do any additional setup after loading the view.
}

- (void)dealloc{
    NSLog(@"释放判断题");
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.tableHeadView.headWebView stopLoading];
}

#pragma mark tableView delegate method
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSLog(@"countcount:%ld",self.radioModel.questionOptions.count);
    return self.radioModel.questionOptions.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(nonnull NSIndexPath *)indexPath{
    if (self.isComplete == TRUE) {
        CSOptionModel *option = self.radioModel.questionOptions[indexPath.row];
        return [self.questionTable cellHeightForIndexPath:indexPath model:option keyPath:@"optionModel" cellClass:[CSJudgeCell class] contentViewWidth:kCSScreenWidth];
    }else{
        return 0;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    CSJudgeCell *cell = [tableView dequeueReusableCellWithIdentifier:judgeCellIdentifier];
    if (self.isComplete == TRUE) {
        CSOptionModel *option = self.radioModel.questionOptions[indexPath.row];
        [cell.optionImgBtn setBackgroundImage:[UIImage imageNamed:@"rounded-rectangle"] forState:UIControlStateNormal];
        option.displayAnswer = self.displayAnswer;
        cell.optionModel = option;
        cell.canAnswer = self.canAnswer;
    }
    WS(weakSelf);
    cell.clickSelectedAction = ^(){
        if ([weakSelf.canAnswer integerValue]> 0 ) {
            [weakSelf clickOption:indexPath];

        }
    };
    return cell;
}

-(void)clickOption:(NSIndexPath *)indexPath{
    CSJudgeCell *cell = (CSJudgeCell *)[self.questionTable cellForRowAtIndexPath:indexPath];
    for (CSJudgeCell *cell2 in self.questionTable.visibleCells) {
        [cell2.optionImgBtn setBackgroundImage:[UIImage imageNamed:@"rounded-rectangle"] forState:UIControlStateNormal];
        cell2.optionModel.isSelected = false;
    }
    cell.optionModel.isSelected = YES;
   [cell.optionImgBtn setBackgroundImage:[UIImage imageNamed:@"rounded-rectangle_check"] forState:UIControlStateNormal];
    //将选择的选项数据保存
    NSString *filePath = [NSHomeDirectory() stringByAppendingPathComponent:kJudgeArrayPathType];
    NSMutableArray *examSingleanswerArray = [NSMutableArray arrayWithContentsOfFile:filePath];
    for (NSMutableDictionary *singleOrItemAnswerDic in examSingleanswerArray) {
        NSString *dicKey = singleOrItemAnswerDic.allKeys[0];
        if ([dicKey isEqualToString:self.radioModel.answerKey]) {
            NSArray *valueArr = [[singleOrItemAnswerDic objectForKey:dicKey] componentsSeparatedByString:@"~"];
            NSString *valueString = [NSString stringWithFormat:@"%@~%@~%ld",valueArr[0],valueArr[1],[cell.optionModel.chopId integerValue]];
            [singleOrItemAnswerDic setValue:valueString forKey:dicKey];
            [examSingleanswerArray writeToFile:filePath atomically:YES];
        }
    }

}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return self.questionTitleHeight;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([self.canAnswer integerValue] > 0) {
        [self clickOption:indexPath];
    }

}


-(SMBaseTableView *)questionTable{
    CGRect tableFrame = self.view.bounds;
    if ([self.canAnswer boolValue]) {
        tableFrame.size.height -= 143;
    }else{
        tableFrame.size.height -= 163;
    }
    if (!_questionTable) {
        _questionTable = [[SMBaseTableView alloc] initWithFrame:tableFrame];
        _questionTable.separatorStyle = UITableViewCellSeparatorStyleNone;
        _questionTable.delegate = self;
        _questionTable.dataSource = self;
        _questionTable.backgroundColor = kBGColor;
        [self.view addSubview:_questionTable];
        [_questionTable registerClass:[CSJudgeCell class] forCellReuseIdentifier:judgeCellIdentifier];
        [self addTableHeadView];
    }
    return _questionTable;
}

#pragma mark controlInit
- (void)addQuestionTable{
    CGRect tableFrame = self.view.bounds;
    if ([self.canAnswer boolValue]) {
        tableFrame.size.height -= 143;
    }else{
        tableFrame.size.height -= 163;
    }
    
    self.questionTable = [[SMBaseTableView alloc] initWithFrame:tableFrame];
    self.questionTable.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.questionTable.delegate = self;
    self.questionTable.dataSource = self;
    self.questionTable.backgroundColor = kBGColor;
    [self.view addSubview:self.questionTable];
    [self.questionTable registerClass:[CSJudgeCell class] forCellReuseIdentifier:judgeCellIdentifier];
    [self addTableHeadView];
}

-(void)addTableHeadView{
    self.tableHeadView = [[CSTableHeadWebView alloc] initWithFrame:CGRectMake(0, 0, kCSScreenWidth, 1)];
    self.tableHeadView.topicTitle = @"判断题";
    self.tableHeadView.htmlString =self.radioModel.questionText;
    __weak CSJudgeViewController *weakSelf = self;
    self.tableHeadView.passWebViewHeightBlock = ^(CGFloat height){
        //加载完成
        weakSelf.isComplete = YES;
        //改变题目高度
        CGRect frame = weakSelf.tableHeadView.frame;
        frame.size.height = height;
        weakSelf.tableHeadView.frame = frame;
        //刷新试题
        weakSelf.questionTable.tableHeaderView = weakSelf.tableHeadView;
        [weakSelf.questionTable reloadData];
    };
    
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
