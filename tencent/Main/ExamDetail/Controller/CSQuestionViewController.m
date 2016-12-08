//
//  CSQuestionViewController.m
//  tencent
//
//  Created by cyh on 16/8/17.
//  Copyright © 2016年 cyh. All rights reserved.
//

#import "CSQuestionViewController.h"
#import "CSFrameConfig.h"
#import "CSTableHeadWebView.h"
#import "CSConfig.h"
#import "CSAskAndAnswerCell.h"
#import "CSOptionModel.h"
#import "NSDictionary+convenience.h"
#import "CSColorConfig.h"
#import "UITableView+SDAutoTableViewCellHeight.h"
#import "SMBaseTableView.h"
#import "CSGlobalMacro.h"
#import "CSSubjectiveAnswerCell.h"
#import "UITableView+SDAutoTableViewCellHeight.h"
@interface CSQuestionViewController ()<UIWebViewDelegate,UITableViewDelegate,UITableViewDataSource>
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

@implementation CSQuestionViewController

static NSString *const questionCellIdentifier = @"questionCell";
static NSString *const questionAnswerCellIdentifier = @"questionAnswerCell";
- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = false;
    self.isComplete = false;
    [self addQuestionTable];
    // Do any additional setup after loading the view.
}

- (void)dealloc{
    NSLog(@"释放问答题");
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.tableHeadView.headWebView stopLoading];
}

#pragma mark tableView delegate method
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(nonnull NSIndexPath *)indexPath{
    if (self.isComplete == TRUE) {
        if ([self.canAnswer integerValue] > 0) {
           return 420;
        }else{
            return [tableView cellHeightForIndexPath:indexPath model:self.radioModel keyPath:@"radioModel" cellClass:[CSSubjectiveAnswerCell class] contentViewWidth:kCSScreenWidth];
        }
    }else{
        return 0;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.isComplete == TRUE) {
        
    }
    
    if ([self.canAnswer integerValue] > 0) {
        CSAskAndAnswerCell *cell = [tableView dequeueReusableCellWithIdentifier:questionCellIdentifier];
        cell.radioModel = self.radioModel;
        cell.canAnswer = self.canAnswer;
        return cell;
    }
    else{
     CSSubjectiveAnswerCell *cell = [tableView dequeueReusableCellWithIdentifier:questionAnswerCellIdentifier];
        cell.radioModel = self.radioModel;
        cell.answerPromptLabel.text = @"我的回答：";
          cell.answerLabel.text = self.radioModel.userAnswerText;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
        return 0;
}


-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return self.questionTitleHeight;
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    CSSubjectiveAnswerCell *cell = [tableView dequeueReusableCellWithIdentifier:questionAnswerCellIdentifier];
    cell.answerPromptLabel.text = @"答案解析:";
    cell.radioModel = self.radioModel;
    cell.answerLabel.text = self.radioModel.viewPoint;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;

}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:-1 inSection:section];
    if ([self.displayAnswer integerValue] > 0) {
         return [tableView cellHeightForIndexPath:indexPath model:self.radioModel keyPath:@"radioModel" cellClass:[CSSubjectiveAnswerCell class] contentViewWidth:kCSScreenWidth];
    }
    return 0;
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
    WS(weakSelf);
    if ([self.canAnswer integerValue] > 0) {
        self.questionTable.saveQuestionAndFillValue = ^(){
            [weakSelf saveQuestionData];
        };
    }
    self.questionTable.backgroundColor = kBGColor;
    [self.view addSubview:self.questionTable];
    [self.questionTable registerClass:[CSAskAndAnswerCell class] forCellReuseIdentifier:questionCellIdentifier];
    [self.questionTable registerClass:[CSSubjectiveAnswerCell class] forCellReuseIdentifier:questionAnswerCellIdentifier];
    [self addTableHeadView];
}

-(void)saveQuestionData{
    //将输入的数据保存
    NSString *filePath = [NSHomeDirectory() stringByAppendingPathComponent:kQuestionArrayPathType];
    NSMutableArray *examQuestionAnwerArray = [NSMutableArray arrayWithContentsOfFile:filePath];
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    CSAskAndAnswerCell *cell = (CSAskAndAnswerCell *)[self.questionTable cellForRowAtIndexPath:indexPath];
    //如果没有cell
    if (!cell) {
        for (NSMutableDictionary *singleOrItemAnswerDic in examQuestionAnwerArray) {
            NSString *dicKey = singleOrItemAnswerDic.allKeys[0];
            if ([dicKey isEqualToString:self.radioModel.answerKey]) {
                NSArray *valueArr = [[singleOrItemAnswerDic objectForKey:dicKey] componentsSeparatedByString:@"~"];
                NSString *valueString;
                NSString *fillFilePath = [NSHomeDirectory() stringByAppendingPathComponent:kQuestionPath];
                NSMutableArray *questionArr = [NSMutableArray arrayWithContentsOfFile:fillFilePath];
                NSString *text;
                for (NSDictionary *dic in questionArr) {
                    NSString *firstKey = [dic allKeys][0];
                    if ([firstKey isEqualToString:dicKey]) {
                        text = [dic objectForKey:firstKey];
                        text = [[text componentsSeparatedByString:@"~"]lastObject];
                    }
                    ;
                }
                self.radioModel.userAnswerText = text;
                if (text.length > 0) {
                    valueString = [NSString stringWithFormat:@"%@~%@",valueArr[0],text];
                }else{
                    valueString = [NSString stringWithFormat:@"%@~",valueArr[0]];
                }
                [singleOrItemAnswerDic setValue:valueString forKey:dicKey];
                [examQuestionAnwerArray writeToFile:filePath atomically:YES];
            }
        }

    }else{
        for (NSMutableDictionary *singleOrItemAnswerDic in examQuestionAnwerArray) {
            NSString *dicKey = singleOrItemAnswerDic.allKeys[0];
            if ([dicKey isEqualToString:self.radioModel.answerKey]) {
                NSArray *valueArr = [[singleOrItemAnswerDic objectForKey:dicKey] componentsSeparatedByString:@"~"];
                NSString *valueString;
                if (cell.textView.text.length > 0 ) {
                    valueString = [NSString stringWithFormat:@"%@~%@",valueArr[0],cell.textView.text];
                    NSString *fillFilePath = [NSHomeDirectory() stringByAppendingPathComponent:kQuestionPath];
                    NSMutableArray *questionArr = [NSMutableArray arrayWithContentsOfFile:filePath];
                    NSDictionary *questionDic = [NSDictionary dictionaryWithObject:cell.textView.text forKey:dicKey];
                    [questionArr addObject:questionDic];
                    [questionArr writeToFile:fillFilePath atomically:YES];
                }else{
                    valueString = [NSString stringWithFormat:@"%@~",valueArr[0]];
                }
                
                cell.radioModel.userAnswerText = cell.textView.text;
                [singleOrItemAnswerDic setValue:valueString forKey:dicKey];
                [examQuestionAnwerArray writeToFile:filePath atomically:YES];
            }
        }
    }

}
-(void)addTableHeadView{
    self.tableHeadView = [[CSTableHeadWebView alloc] initWithFrame:CGRectMake(0, 0, kCSScreenWidth, 1)];
    self.tableHeadView.topicTitle = @"问答题";
    self.tableHeadView.htmlString =self.radioModel.questionText;
    __weak CSQuestionViewController *weakSelf = self;
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
