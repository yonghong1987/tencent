//
//  CSLookPaperViewController.m
//  tencent
//
//  Created by cyh on 16/8/22.
//  Copyright © 2016年 cyh. All rights reserved.
//

#import "CSLookPaperViewController.h"
#import "CSTrueAndFalseView.h"
#import "CSFrameConfig.h"
#import "CSUrl.h"
#import "CSHttpRequestManager.h"
#import "CSExamResultModel.h"
#import "CSTitleListModel.h"
#import "CSTitleListCell.h"
#import "CSTureFalseAllChooseView.h"
#import "CSConfig.h"
#import "CSExamContentViewController.h"
@interface CSLookPaperViewController ()<UICollectionViewDelegate,UICollectionViewDataSource>
/**
 *用于显示题号
 */
@property (nonatomic, strong) UICollectionView *collectionView;
/**
 *题目数组
 */
@property (nonatomic, strong) NSMutableArray *titleArray;
@property (nonatomic, strong) CSExamResultModel *examResultModel;
@end

@implementation CSLookPaperViewController

static NSString * kItemIdentifier = @"ItemCell";
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"练身手";
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.titleArray = [NSMutableArray array];
    [self creatTrueAndFalseView];
    [self creatCollectionView];
    [self loadData];
    // Do any additional setup after loading the view.
}

- (void)loadData{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setValue:self.actTestAttId forKey:@"actTestAttId"];
    [[CSHttpRequestManager shareManager] postDataFromNetWork:CHECK_PAPER parameters:params success:^(CSHttpRequestManager *manager, id model) {
        NSDictionary *resultDic = model[@"questionResultEntity"];
        self.examResultModel = [[CSExamResultModel alloc]initWithDictionary:resultDic error:nil];
        NSArray *resultList = resultDic[@"questionResultList"];
        NSMutableArray *arrayData = [NSMutableArray array];
        for (NSDictionary *listDic in resultList) {
            CSTitleListModel *listModel = [[CSTitleListModel alloc]initWithDictionary:listDic error:nil];
            [arrayData addObject:listModel];
        }
     self.examResultModel.resultList = arrayData;
        [self.collectionView reloadData];
        
//        if ([self.examResultModel.displayAnswer integerValue] > 0) {
             [self trueFalseAllChooseView];
//        }
    } failture:^(CSHttpRequestManager *manager, id nodel) {
        
    }];
}

-(void)creatCollectionView{
UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.minimumLineSpacing = 1;
    layout.minimumInteritemSpacing = 1;
    layout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
    self.collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 50, kCSScreenWidth, kCSScreenHeight - KNavigationHegiht - 50 - 68) collectionViewLayout:layout];
    self.collectionView.backgroundColor = [UIColor whiteColor];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    layout.itemSize = CGSizeMake((kCSScreenWidth - 5 )/ 5, (kCSScreenWidth - 5 )/ 5);
    [self.view addSubview:self.collectionView];
    [self.collectionView registerClass:[CSTitleListCell class] forCellWithReuseIdentifier:kItemIdentifier];
}


-(void)creatTrueAndFalseView{
    CSTrueAndFalseView *trueAndFalseView = [[CSTrueAndFalseView alloc]initWithFrame:CGRectMake(0, 0, kCSScreenWidth, 50)];
    [self.view addSubview:trueAndFalseView];
}

-(void)trueFalseAllChooseView{
    CSTureFalseAllChooseView *trueFalseAllChooseView = [[CSTureFalseAllChooseView alloc]initWithFrame:CGRectMake(0,kCSScreenHeight - KNavigationHegiht - 68, kCSScreenWidth, 68)];
    WS(weakSelf);
    trueFalseAllChooseView.clickTrueAction = ^(){
        CSExamContentViewController *examContentVC = [[CSExamContentViewController alloc]init];
        examContentVC.examActivityId = self.examResultModel.examActivityId;
        examContentVC.examType = @(3);
        [weakSelf.navigationController pushViewController:examContentVC animated:YES];
    };
    trueFalseAllChooseView.clickFalseAction = ^(){
        CSExamContentViewController *examContentVC = [[CSExamContentViewController alloc]init];
        examContentVC.examActivityId = self.examResultModel.examActivityId;
         examContentVC.examType = @(2);
        [weakSelf.navigationController pushViewController:examContentVC animated:YES];
    };
    trueFalseAllChooseView.clickAllAction = ^(){
        CSExamContentViewController *examContentVC = [[CSExamContentViewController alloc]init];
        examContentVC.examActivityId = self.examResultModel.examActivityId;
        examContentVC.examType = @(1);
        [weakSelf.navigationController pushViewController:examContentVC animated:YES];
    };
    [self.view addSubview:trueFalseAllChooseView];
}

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.examResultModel.resultList.count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    CSTitleListCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kItemIdentifier forIndexPath:indexPath];
    cell.indexPath = indexPath;
    cell.titleListModel = self.examResultModel.resultList[indexPath.row];
    return cell;
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
