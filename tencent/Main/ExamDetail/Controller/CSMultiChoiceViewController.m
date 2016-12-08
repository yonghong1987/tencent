//
//  CSMultiChoiceViewController.m
//  TXHDemo
//
//  Created by bill on 16/5/18.
//  Copyright © 2016年 Bill. All rights reserved.
//

#import "CSMultiChoiceViewController.h"
#import "CSFrameConfig.h"
#import "CSTableHeadWebView.h"
#import "CSConfig.h"
#import "CSOptionModel.h"
#import "NSDictionary+convenience.h"
#import "CSColorConfig.h"
#import "UITableView+SDAutoTableViewCellHeight.h"
#import "SMBaseTableView.h"
#import "CSMultiselectCell.h"
#import "CSGlobalMacro.h"
@interface CSMultiChoiceViewController ()<UIWebViewDelegate,UITableViewDelegate,UITableViewDataSource>

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

@implementation CSMultiChoiceViewController

static NSString *multiselectCellIdentifier = @"multiselectCell";
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.automaticallyAdjustsScrollViewInsets = false;
    self.isComplete = false;
    [self addQuestionTable];
}

- (void)dealloc{
    NSLog(@"释放多选题");
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
        return [self.questionTable cellHeightForIndexPath:indexPath model:option keyPath:@"optionModel" cellClass:[CSMultiselectCell class] contentViewWidth:kCSScreenWidth];
    }else{
        return 0;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    CSMultiselectCell *cell = [tableView dequeueReusableCellWithIdentifier:multiselectCellIdentifier];
    if (self.isComplete == TRUE) {
         [cell.optionImgBtn setBackgroundImage:[UIImage imageNamed:@"rounded-rectangle"] forState:UIControlStateNormal];
        CSOptionModel *option = self.radioModel.questionOptions[indexPath.row];
        option.displayAnswer = self.displayAnswer;
        cell.optionModel = option;
        
    }
    cell.canAnswer = self.canAnswer;
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return self.questionTitleHeight;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([self.canAnswer integerValue]> 0) {
        CSMultiselectCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        [cell didSelectCell];
        if (cell.optionModel.isSelected ==YES) {
            [cell.optionImgBtn setBackgroundImage:[UIImage imageNamed:@"rounded-rectangle_check"] forState:UIControlStateNormal];
        }else{
            [cell.optionImgBtn setBackgroundImage:[UIImage imageNamed:@"rounded-rectangle"] forState:UIControlStateNormal];
        }
        NSString *optionIdString = @"";
        for (CSOptionModel *optionModel in self.radioModel.questionOptions) {
            if (optionModel.isSelected ==YES) {
                optionIdString = [optionIdString stringByAppendingString:[NSString stringWithFormat:@"%ld,",[optionModel.chopId integerValue]]];
            }
        }
        if (optionIdString.length > 0) {
            optionIdString = [optionIdString substringWithRange:NSMakeRange(0, optionIdString.length - 1)];
        }
        //将选择的选项数据保存
        NSString *filePath;
        if ([self.radioModel.questionType isEqualToString:kTopicMultiSelectType]) {
            filePath = [NSHomeDirectory() stringByAppendingPathComponent:kMultiArrayPathType];
        }else if ([self.radioModel.questionType isEqualToString:kTopicNoItemType]){
            filePath = [NSHomeDirectory() stringByAppendingPathComponent:kNoItemArrayPathType];
        }
        NSMutableArray *examMultiAnswerArray = [NSMutableArray arrayWithContentsOfFile:filePath];
        for (NSMutableDictionary *singleOrItemAnswerDic in examMultiAnswerArray) {
            NSString *dicKey = singleOrItemAnswerDic.allKeys[0];
            if ([dicKey isEqualToString:self.radioModel.answerKey]) {
                NSArray *valueArr = [[singleOrItemAnswerDic objectForKey:dicKey] componentsSeparatedByString:@"~"];
                NSString *valueString = [NSString stringWithFormat:@"%@~%@~%@",valueArr[0],valueArr[1],optionIdString];
                [singleOrItemAnswerDic setValue:valueString forKey:dicKey];
                [examMultiAnswerArray writeToFile:filePath atomically:YES];
            }
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
    [self.questionTable registerClass:[CSMultiselectCell class] forCellReuseIdentifier:multiselectCellIdentifier];
    [self addTableHeadView];
}

-(void)addTableHeadView{
    self.tableHeadView = [[CSTableHeadWebView alloc] initWithFrame:CGRectMake(0, 0, kCSScreenWidth, 1)];
    if ([self.radioModel.questionType isEqualToString:kTopicNoItemType]) {
        self.tableHeadView.topicTitle = @"不定项题";
    }else if ([self.radioModel.questionType isEqualToString:kTopicMultiSelectType]){
    self.tableHeadView.topicTitle = @"多选题";
    }
    
    self.tableHeadView.htmlString =self.radioModel.questionText;
    __weak CSMultiChoiceViewController *weakSelf = self;
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
/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
