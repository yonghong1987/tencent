//
//  CSFillViewController.m
//  tencent
//
//  Created by cyh on 16/8/17.
//  Copyright © 2016年 cyh. All rights reserved.
//

#import "CSFillViewController.h"
#import "CSFrameConfig.h"
#import "CSTableHeadWebView.h"
#import "CSConfig.h"
#import "CSFillBlankCell.h"
#import "CSOptionModel.h"
#import "NSDictionary+convenience.h"
#import "CSColorConfig.h"
#import "UITableView+SDAutoTableViewCellHeight.h"
#import "SMBaseTableView.h"
#import "CSGlobalMacro.h"
#import "XHMessageTextView.h"
#import "CSFillBlankAnswerCell.h"
#import "CDPMonitorKeyboard.h"
#import "UITableView+SDAutoTableViewCellHeight.h"
@interface CSFillViewController ()<UIWebViewDelegate,UITableViewDelegate,UITableViewDataSource,CDPMonitorKeyboardDelegate>
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
/**
 *用于保存点击的是哪个cell的textView
 */
@property (nonatomic, strong) NSIndexPath *indexPath;
/**
 *textView所在的cellindex.row
 */
@property (nonatomic, assign) NSInteger index;
/**
 *用于保存每个textView中的值
 */
@property (nonatomic, strong) NSMutableArray *textArray;
@end

@implementation CSFillViewController
static NSString *const fillCellIdentifier = @"fillCell";
static NSString *const fillAnswerCellIdentifier = @"fillAnswerCell";
- (void)viewDidLoad {
    [super viewDidLoad];
    self.index = 0;
    self.automaticallyAdjustsScrollViewInsets = false;
    self.isComplete = false;
    [self initTextArr];
    [[CDPMonitorKeyboard defaultMonitorKeyboard]sendValueWithSuperView:self.view higherThanKeyboard:0 andMode:CDPMonitorKeyboardDefaultMode navigationControllerTopHeight:10];
    [CDPMonitorKeyboard defaultMonitorKeyboard].delegate = self;
    [self addQuestionTable];
    // Do any additional setup after loading the view.
}

-(void)initTextArr{
   self.textArray = [NSMutableArray array];
    for (CSOptionModel *optionModel in self.radioModel.questionOptions) {
        [self.textArray addObject:optionModel.chopUserAnswer];
    }
}

//保存数据（不是最后一道填空题）
- (void)saveQuestionData{
    //将输入的数据保存
    NSString *filePath = [NSHomeDirectory() stringByAppendingPathComponent:kFillArrayPathType];
    NSMutableArray *examQuestionAnwerArray = [NSMutableArray arrayWithContentsOfFile:filePath];
    CSFillBlankCell *cell = (CSFillBlankCell *)[self.questionTable cellForRowAtIndexPath:self.indexPath];
    if (!cell) {
        for (NSMutableDictionary *singleOrItemAnswerDic in examQuestionAnwerArray) {
            NSString *dicKey = singleOrItemAnswerDic.allKeys[0];
            if ([dicKey isEqualToString:self.radioModel.answerKey]) {
                NSString *dicValue = [singleOrItemAnswerDic objectForKey:dicKey];
                NSArray *dicValueArray = [dicValue componentsSeparatedByString:@"~"];
                NSString *lastDicValueStirng = [dicValueArray lastObject];
                
                NSArray *valueArr = [lastDicValueStirng componentsSeparatedByString:@"||"];
                NSString *fillString = @"";
                //如果不是最后一道填空题
                if (self.titleTag != self.titleCount - 1) {
                    NSString *fillFilePath = [NSHomeDirectory() stringByAppendingPathComponent:kFillPath];
                    NSMutableArray *fillArr = [NSMutableArray arrayWithContentsOfFile:filePath];
                    for (NSString *string in valueArr) {
                        NSInteger index = [valueArr indexOfObject:string];
                        NSArray *lastArr = [string componentsSeparatedByString:@"@"];
                        NSString *lastString = [lastArr lastObject];
                        if (self.radioModel.dataArr.count == 0) {
                            lastString = self.textArray[index];
                        }else{
                        lastString = self.radioModel.dataArr[index];
                        }
                        
                        NSDictionary *fillDic = [NSDictionary dictionaryWithObject:lastString forKey:[lastArr firstObject]];
                        [fillArr addObject:fillDic];
                        
                        fillString = [fillString stringByAppendingString:[NSString stringWithFormat:@"%@@%@||",lastArr[0],lastString]];
                    }
                    [fillArr writeToFile:fillFilePath atomically:YES];
                    //如果是最后一题
                }else{
                    for (CSFillBlankCell *fillCell in self.questionTable.visibleCells) {
                        NSInteger index = [self.questionTable.visibleCells indexOfObject:fillCell];
                        if ([self.canAnswer boolValue]) {
                            fillCell.optionModel.chopUserAnswer = fillCell.fillContentTextView.text;
                            [self.textArray replaceObjectAtIndex:index withObject:fillCell.fillContentTextView.text];
                        }
                        
                    }
                    
                    for (NSString *string in valueArr) {
                        NSInteger index = [valueArr indexOfObject:string];
                        NSArray *lastArr = [string componentsSeparatedByString:@"@"];
                        NSString *lastString = [lastArr lastObject];
                        lastString = self.textArray[index];
                        fillString = [fillString stringByAppendingString:[NSString stringWithFormat:@"%@@%@||",lastArr[0],lastString]];
                    }
                }
                
                if (fillString.length > 0) {
                    fillString = [fillString substringWithRange:NSMakeRange(0, fillString.length - 2)];
                }
                NSString *resultString = @"";
                resultString = [resultString stringByAppendingString:[NSString stringWithFormat:@"%@~%@~%@",dicValueArray[0],dicValueArray[1],fillString]];
                [singleOrItemAnswerDic setValue:resultString forKey:dicKey];
                [examQuestionAnwerArray writeToFile:filePath atomically:YES];
            }
        }

    }else{
        for (NSMutableDictionary *singleOrItemAnswerDic in examQuestionAnwerArray) {
            NSString *dicKey = singleOrItemAnswerDic.allKeys[0];
            if ([dicKey isEqualToString:self.radioModel.answerKey]) {
                NSString *dicValue = [singleOrItemAnswerDic objectForKey:dicKey];
                NSArray *dicValueArray = [dicValue componentsSeparatedByString:@"~"];
                NSString *lastDicValueStirng = [dicValueArray lastObject];
                
                NSArray *valueArr = [lastDicValueStirng componentsSeparatedByString:@"||"];
                //选中某个输入框的对应的字符串
                if ([cell.fillContentTextView.text rangeOfString:@"|"].location != NSNotFound) {
                    cell.fillContentTextView.text = [cell.fillContentTextView.text stringByReplacingOccurrencesOfString:@"|" withString:@"?" ];
                }
                NSString *fillString = @"";
                //如果不是最后一道填空题
                if (self.titleTag != self.titleCount - 1) {
                    NSString *fillFilePath = [NSHomeDirectory() stringByAppendingPathComponent:kFillPath];
                    NSMutableArray *fillArr = [NSMutableArray arrayWithContentsOfFile:filePath];
                    for (NSString *string in valueArr) {
                        NSInteger index = [valueArr indexOfObject:string];
                        NSArray *lastArr = [string componentsSeparatedByString:@"@"];
                        NSString *lastString = [lastArr lastObject];
                        lastString = self.textArray[index];
                        [self.radioModel.dataArr insertObject:lastString atIndex:index];
                        NSDictionary *fillDic = [NSDictionary dictionaryWithObject:lastString forKey:[lastArr firstObject]];
                        [fillArr addObject:fillDic];
                        
                        fillString = [fillString stringByAppendingString:[NSString stringWithFormat:@"%@@%@||",lastArr[0],lastString]];
                    }
                    [fillArr writeToFile:fillFilePath atomically:YES];
                    //如果是最后一题
                }else{
                    for (CSFillBlankCell *fillCell in self.questionTable.visibleCells) {
                        NSInteger index = [self.questionTable.visibleCells indexOfObject:fillCell];
                        fillCell.optionModel.chopUserAnswer = fillCell.fillContentTextView.text;
                        [self.textArray replaceObjectAtIndex:index withObject:fillCell.fillContentTextView.text];
                    }
                    
                    for (NSString *string in valueArr) {
                        NSInteger index = [valueArr indexOfObject:string];
                        NSArray *lastArr = [string componentsSeparatedByString:@"@"];
                        NSString *lastString = [lastArr lastObject];
                        lastString = self.textArray[index];
                        fillString = [fillString stringByAppendingString:[NSString stringWithFormat:@"%@@%@||",lastArr[0],lastString]];
                    }
                }
                
                if (fillString.length > 0) {
                    fillString = [fillString substringWithRange:NSMakeRange(0, fillString.length - 2)];
                }
                NSString *resultString = @"";
                resultString = [resultString stringByAppendingString:[NSString stringWithFormat:@"%@~%@~%@",dicValueArray[0],dicValueArray[1],fillString]];
                [singleOrItemAnswerDic setValue:resultString forKey:dicKey];
                [examQuestionAnwerArray writeToFile:filePath atomically:YES];
            }
        }

    }
}

- (void)dealloc{
    NSLog(@"释放填空题");
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.tableHeadView.headWebView stopLoading];
    if ([self.canAnswer integerValue] > 0) {
        //如果不是最后一道填空题
        if (self.titleTag != self.titleCount - 1) {
            for (CSFillBlankCell *fillCell in self.questionTable.visibleCells) {
                NSInteger index = [self.questionTable.visibleCells indexOfObject:fillCell];
                fillCell.optionModel.chopUserAnswer = fillCell.fillContentTextView.text;
                [self.textArray replaceObjectAtIndex:index withObject:fillCell.fillContentTextView.text];
            }
            [self saveQuestionData];
        }

    }
}

#pragma mark tableView delegate method
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.radioModel.questionOptions.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(nonnull NSIndexPath *)indexPath{
    if ([self.canAnswer integerValue] > 0) {
        return 80;
    }else{
        CSOptionModel *option = self.radioModel.questionOptions[indexPath.row];
        return [self.questionTable cellHeightForIndexPath:indexPath model:option keyPath:@"radioModel" cellClass:[CSFillBlankAnswerCell class] contentViewWidth:kCSScreenWidth];
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    //如果用户可以作答
        if ([self.canAnswer integerValue] > 0) {
            CSFillBlankCell *cell = [tableView dequeueReusableCellWithIdentifier:fillCellIdentifier];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.fillPromptLabel.text = [NSString stringWithFormat:@"填空 %ld",indexPath.row + 1];
             CSOptionModel *option = self.radioModel.questionOptions[indexPath.row];
            NSString *fillFilePath = [NSHomeDirectory() stringByAppendingPathComponent:kFillPath];
            NSMutableArray *fillArr = [NSMutableArray arrayWithContentsOfFile:fillFilePath];
            if (self.radioModel.dataArr.count == 0) {
                for (NSDictionary *fillDic in fillArr) {
                    NSString *firstKey = [fillDic allKeys][0];
                    if ([firstKey isEqualToString:[NSString stringWithFormat:@"%ld",[option.chopId integerValue]]]) {
//                        option.chopUserAnswer = [fillDic objectForKey:firstKey];
                    }
                }
            }else{
//            option.chopUserAnswer = self.radioModel.dataArr[indexPath.row];
            }
            
            cell.optionModel = option;
            cell.canAnswer = self.canAnswer;
           
            return cell;
            //如果用户不能作答
        }else{
         CSFillBlankAnswerCell *cell = [tableView dequeueReusableCellWithIdentifier:fillAnswerCellIdentifier];
             cell.fillPromptLabel.text = [NSString stringWithFormat:@"填空 %ld: ",indexPath.row + 1];
            cell.radioModel = self.radioModel.questionOptions[indexPath.row];
            return cell;
        }
    return 0;
}


-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return self.questionTitleHeight;
}

#pragma mark controlInit
- (void)addQuestionTable{
//    self.questionTable = [[SMBaseTableView alloc] initWithFrame:CGRectMake(0, 0, kCSScreenWidth, kCSScreenHeight - 113)];
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
    WS(weakSelf);
    if (self.titleCount - 1 == self.titleTag) {
        self.questionTable.saveQuestionAndFillValue = ^(){
            [weakSelf saveQuestionData];
        };
    }

    self.questionTable.clickInTextCallBack = ^(XHMessageTextView *textView){
        for (CSFillBlankCell *fillCell in weakSelf.questionTable.visibleCells) {
            if (fillCell.fillContentTextView == textView) {
                weakSelf.index = [weakSelf.questionTable.visibleCells indexOfObject:fillCell];
                NSLog(@"weakSelf.index:%ld",weakSelf.index);
                weakSelf.indexPath = [NSIndexPath indexPathForRow:weakSelf.index inSection:0];
            }
        }
    };
    
    [self.view addSubview:self.questionTable];
    [self.questionTable registerClass:[CSFillBlankCell class] forCellReuseIdentifier:fillCellIdentifier];
    [self.questionTable registerClass:[CSFillBlankAnswerCell class] forCellReuseIdentifier:fillAnswerCellIdentifier];
    [self addTableHeadView];
}

-(void)addTableHeadView{
    self.tableHeadView = [[CSTableHeadWebView alloc] initWithFrame:CGRectMake(0, 0, kCSScreenWidth, 1)];
    self.tableHeadView.topicTitle = @"填空题";
    self.tableHeadView.htmlString =self.radioModel.questionText;
    __weak CSFillViewController *weakSelf = self;
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

//系统键盘出现时
-(void)didWhenKeyboardWillShow:(NSNotification *)notification{
    CGPoint point = [[CDPMonitorKeyboard defaultMonitorKeyboard] setCellWithPoint:notification withCell: [self.questionTable cellForRowAtIndexPath:self.indexPath] withTableViewPoint:self.questionTable.contentOffset];
    [self.questionTable setContentOffset:point animated:NO];
    
}
//系统键盘消失时
-(void)didWhenKeyboardWillHide:(NSNotification *)notification{
   
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
