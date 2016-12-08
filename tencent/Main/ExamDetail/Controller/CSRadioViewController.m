//
//  CSRadioViewController.m
//  TXHDemo
//
//  Created by bill on 16/5/18.
//  Copyright © 2016年 Bill. All rights reserved.
//

#import "CSRadioViewController.h"

@interface CSRadioViewController ()<UIWebViewDelegate,UITableViewDelegate,UITableViewDataSource>

/**
 *  问题表单
 */
@property (nonatomic, strong) UITableView *questionTable;



/**
 *  问题题目高度
 */
@property (nonatomic, assign) CGFloat questionTitleHeight;

/**
 *  问题题目视图
 */
@property (nonatomic, strong) UIWebView *questionTitleView;

@end

@implementation CSRadioViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
     self.automaticallyAdjustsScrollViewInsets = false;

    NSLog(@"加载单选题:%ld",(long)[[self.dataSourceDic objectForKey:@"id"] integerValue]);
    [self.view addSubview:self.questionTable];
 }

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    NSString *htmlContent = [self.dataSourceDic objectForKey:@"texts"];
    [self.questionTitleView loadHTMLString:htmlContent baseURL:nil];
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (void)dealloc{
    NSLog(@"释放单选题:%ld",(long)[[self.dataSourceDic objectForKey:@"id"] integerValue]);
}

#pragma mark logic method

#pragma mark tableView delegate method
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(nonnull NSIndexPath *)indexPath{
    return 60;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell"];
    if ( !cell ) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"UITableViewCell"];
    }
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    CGRect frame = self.questionTitleView.frame;
    frame.size.height = self.questionTitleHeight;
    self.questionTitleView.frame = frame;
    return self.questionTitleView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return self.questionTitleHeight;
}

#pragma mark webview delegate method
- (void)webViewDidStartLoad:(UIWebView *)webView{
    NSLog(@"start load");
}

- (void)webViewDidFinishLoad:(UIWebView *)webView{
    
    NSLog(@"end load");
    
    self.questionTitleHeight = webView.scrollView.contentSize.height;
    [self.questionTable reloadData];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{

}

#pragma mark init
- (UIWebView *)questionTitleView{
    if ( !_questionTitleView ) {
        _questionTitleView = [[UIWebView alloc] initWithFrame:self.questionTable.bounds];
        _questionTitleView.delegate = self;
    }
    return _questionTitleView;
}

- (UITableView *)questionTable{
    if ( !_questionTable ) {
        CGRect tableFrame = self.view.bounds;
        tableFrame.size.height -= 113;
        _questionTable = [[UITableView alloc] initWithFrame:tableFrame];
        _questionTable.delegate = self;
        _questionTable.dataSource = self;
        [_questionTable registerClass:[UITableViewCell class] forCellReuseIdentifier:@"UITableViewCell"];
    }
    return _questionTable;
}

- (NSDictionary *)dataSourceDic{
    if ( !_dataSourceDic ) {
        _dataSourceDic = [NSDictionary dictionary];
    }
    return _dataSourceDic;
}
@end
