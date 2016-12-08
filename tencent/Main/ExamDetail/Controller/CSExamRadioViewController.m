//
//  CSExamRadioViewController.m
//  tencent
//
//  Created by admin on 16/5/19.
//  Copyright © 2016年 cyh. All rights reserved.
//

#import "CSExamRadioViewController.h"
#import "CSFrameConfig.h"
#import "CSTableHeadWebView.h"
#import "CSConfig.h"
#import "CSRadioCell.h"
#import "CSOptionModel.h"
#import "NSDictionary+convenience.h"
#import "CSColorConfig.h"
#import "UITableView+SDAutoTableViewCellHeight.h"
#import "SMBaseTableView.h"
#import "CSSingleOrNoItemAnswerModel.h"
#import "CSGlobalMacro.h"
@interface CSExamRadioViewController ()<UIWebViewDelegate,UITableViewDelegate,UITableViewDataSource>
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

@implementation CSExamRadioViewController

static NSString *const radioCellIdentifier = @"radioCell";

- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = false;
    self.isComplete = false;
    [self addQuestionTable];
    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}

- (void)dealloc{
    NSLog(@"释放单选题");
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.tableHeadView.headWebView stopLoading];
}
#pragma mark tableView delegate method
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.radioModel.questionOptions.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(nonnull NSIndexPath *)indexPath{
    if (self.isComplete == TRUE) {
        CSOptionModel *option = self.radioModel.questionOptions[indexPath.row];
        return [self.questionTable cellHeightForIndexPath:indexPath model:option keyPath:@"optionModel" cellClass:[CSRadioCell class] contentViewWidth:kCSScreenWidth];
    }else{
        return 0;
    }
    return 0;
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    if ([self.canAnswer integerValue] == 0) {
        
    }
    return 0;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    CSRadioCell *cell = [tableView dequeueReusableCellWithIdentifier:radioCellIdentifier];
    if (self.isComplete == TRUE) {
        CSOptionModel *option = self.radioModel.questionOptions[indexPath.row];
        option.displayAnswer = self.displayAnswer;
        cell.row = indexPath.row;
        cell.canAnswer = self.canAnswer;
        cell.optionModel = option;
    }
    
    
    WS(weakelf);
    cell.clickSelectedAction = ^(){
        if ([weakelf.canAnswer integerValue] > 0) {
            [weakelf clickOption:indexPath];
        }
    };
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return self.questionTitleHeight;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([self.canAnswer integerValue] > 0) {
         [self clickOption:indexPath];
    }
   
}

-(void)clickOption:(NSIndexPath *)indexPath{
    CSRadioCell *cell = (CSRadioCell *)[self.questionTable cellForRowAtIndexPath:indexPath];
    for (CSRadioCell *cell2 in self.questionTable.visibleCells) {
        [cell2.optionImgBtn setBackgroundImage:[UIImage imageNamed:@"rounded-rectangle"] forState:UIControlStateNormal];
        cell2.optionModel.isSelected = false;
    }
   
    cell.optionModel.isSelected = true;
    [cell.optionImgBtn setBackgroundImage:[UIImage imageNamed:@"rounded-rectangle_check"] forState:UIControlStateNormal];
    //将选择的选项数据保存
    NSString *filePath = [NSHomeDirectory() stringByAppendingPathComponent:kSingleArrayPathType];
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
    [self.questionTable registerClass:[CSRadioCell class] forCellReuseIdentifier:radioCellIdentifier];
    [self addTableHeadView];
}

-(void)addTableHeadView{
    self.tableHeadView = [[CSTableHeadWebView alloc] initWithFrame:CGRectMake(0, 0, kCSScreenWidth, 1)];
    self.tableHeadView.topicTitle = @"单选题";
      self.tableHeadView.htmlString =self.radioModel.questionText;
    __weak CSExamRadioViewController *weakSelf = self;

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


@end
