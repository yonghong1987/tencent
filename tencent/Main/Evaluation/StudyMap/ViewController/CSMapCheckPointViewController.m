//
//  CSMapCheckPointViewController.m
//  tencent
//
//  Created by cyh on 16/7/28.
//  Copyright © 2016年 cyh. All rights reserved.
//

#import "CSMapCheckPointViewController.h"
#import "CSFrameConfig.h"
#import "CSUrl.h"
#import "CSHttpRequestManager.h"
#import "CSCheckPointAnimationView.h"
#import "CSCheckPointCell.h"
#import "CSCheckPointModel.h"
#import "CSArrayDataChange.h"
#import "CSMapCourseDetailViewController.h"
#import "MJRefresh.h"
#import "CarTonButton.h"
#import "UIButton+AFNetworking.h"
#import "CSImagePath.h"
#import "MBProgressHUD+SMHUD.h"
@interface CSMapCheckPointViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, assign) NSInteger currentPage;
@property (nonatomic, strong) CSCheckPointAnimationView *animationView;
@property (nonatomic, strong) NSMutableArray *checkPoints;
@property (nonatomic, strong) UITableView *table;
@property (nonatomic, assign) NSInteger nowPage;
@property(nonatomic, strong) UIButton *beforeBtn;
@property(nonatomic, strong) UIButton *nextBtn;
@end

@implementation CSMapCheckPointViewController

static NSString *checkPointCell = @"checkPointCell";

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = self.mapModel.name;
    self.checkPoints = [NSMutableArray array];
    self.currentPage = 1;
    
    [self initTable];
    [self setUpRefresh];
    [self addBeforeAndAfterBtn];
    // Do any additional setup after loading the view.
}

-(void)addBeforeAndAfterBtn{
    _beforeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _beforeBtn.frame = CGRectMake(10, kCSScreenHeight/2-50, 28, 47);
    [_beforeBtn setBackgroundImage:[UIImage imageNamed:@"beforeBtn"] forState:UIControlStateNormal];
    [_beforeBtn addTarget:self action:@selector(beforePageAction:) forControlEvents:UIControlEventTouchUpInside];
    _beforeBtn.hidden = YES;
    [self.view addSubview:_beforeBtn];
    
    _nextBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _nextBtn.frame = CGRectMake(kCSScreenWidth-40, kCSScreenHeight/2-50, 28, 47);
    [_nextBtn setBackgroundImage:[UIImage imageNamed:@"nextBtn"] forState:UIControlStateNormal];
    [_nextBtn addTarget:self action:@selector(nextPageAction:) forControlEvents:UIControlEventTouchUpInside];
    _nextBtn.hidden = YES;
    [self.view addSubview:_nextBtn];

}

- (void)beforePageAction:(UIButton *)button {
    if (_nowPage>0) {
        [self.table setContentOffset:CGPointMake(0, kCSScreenWidth*(_nowPage-1)) animated:YES];
    }
}
- (void)nextPageAction:(UIButton *)button {
    NSInteger currentPage=self.table.contentSize.height/kCSScreenWidth;
    if (_nowPage<currentPage-1) {
        [self.table setContentOffset:CGPointMake(0, kCSScreenWidth*(_nowPage+1)) animated:YES];
    }
}
- (void)initAnimationViewWithString:(NSString *)string{
    self.animationView = [[CSCheckPointAnimationView alloc]initWithFrame:self.view.bounds];
    self.animationView.cartoonString = string;
    [self.navigationController.view addSubview:self.animationView];
}

-(void)initTable{
    self.table = [[UITableView alloc]init];
    self.table.transform=CGAffineTransformMakeRotation(-M_PI/2);
    self.table.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - 64.0);
    self.table.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.table.delegate = self;
    self.table.dataSource = self;
    [self.view addSubview:self.table];
    [self.table registerClass:[UITableViewCell class] forCellReuseIdentifier:checkPointCell];
}

- (void)loadData:(BOOL)reload{
    if (reload) {
        self.currentPage = 1;
    }else{
        self.currentPage ++;
    }
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setValue:@(8) forKey:@"rp"];
    [params setValue:@(self.currentPage) forKey:@"page"];
    [params setValue:self.mapModel.mappId forKey:@"mapId"];
    [[CSHttpRequestManager shareManager] postDataFromNetWork:GET_CHECK_POINT_LIST parameters:params success:^(CSHttpRequestManager *manager, id model) {
        NSArray *array = model[@"tollgateList"];
        NSMutableArray *dataArr = [NSMutableArray array];
        for (NSDictionary *checkPointDic in array) {
            CSCheckPointModel *checkPointModel = [[CSCheckPointModel alloc]initWithDictionary:checkPointDic error:nil];
            [dataArr addObject:checkPointModel];
        }
        self.title = model[@"mapName"];
        dataArr = [[CSArrayDataChange alloc]dataChangeIndexWithArray:dataArr count:4];
        if (reload == YES) {
            self.checkPoints = dataArr;
        }else{
            [self.checkPoints addObjectsFromArray:dataArr];
        }
        if (self.currentPage == 1) {
            NSString *mapCartoon = [CSImagePath noEncodeingImageUrl:model[@"mapCartoon"]];
                [self initAnimationViewWithString:mapCartoon];
        }
        [self.table reloadData];
        [self endRefresh];
    } failture:^(CSHttpRequestManager *manager, id nodel) {
        [self endRefresh];
    }];
}

- (void)setUpRefresh{
    self.table.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self loadData:YES];
    }];
    self.table.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        [self loadData:NO];
    }];
    self.table.mj_footer.hidden = NO;
    [self loadData:YES];
}

- (void)endRefresh{
    [self.table.mj_header endRefreshing];
    [self.table.mj_footer endRefreshing];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.checkPoints.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSMutableArray *array=self.checkPoints[indexPath.row];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:checkPointCell];
    cell.contentView.transform=CGAffineTransformMakeRotation(M_PI / 2);
    for (UIView *v in cell.contentView.subviews) {
        [v removeFromSuperview];
    }
    for (int i=0; i<array.count; i++) {
        CSCheckPointModel *checkPointModel = array[i];
        CGFloat currentX=(i%2==0?0:tableView.frame.size.width/2.0);
        CGFloat currentY=(i/2)*tableView.frame.size.height/2.0;
        CarTonButton *imageBtn = [CarTonButton buttonWithType:UIButtonTypeCustom];
        imageBtn.frame = CGRectMake(currentX,currentY, tableView.frame.size.width/2.0, tableView.frame.size.height/2.0);
        [imageBtn setBackgroundImageForState:UIControlStateNormal withURL:[NSURL URLWithString:checkPointModel.backgroundImg] placeholderImage:[UIImage imageNamed:@"loadingtencent-guanqia"]];
        [imageBtn addTarget:self action:@selector(checkPointAction:) forControlEvents:UIControlEventTouchUpInside];
        imageBtn.tag = indexPath.row;
        [imageBtn.dict setValue:checkPointModel forKey:@"checkPointModel"];
        [cell.contentView addSubview:imageBtn];
        
        UIImageView * imgV=[[UIImageView alloc] initWithFrame:CGRectMake(imageBtn.frame.size.width/2.0-39.0, imageBtn.frame.size.height/2.0-42.0, 79.0, 85.0)];
        imgV.image = [UIImage imageNamed:@"icon_lock"];
        [imageBtn addSubview:imgV];
        if ([checkPointModel.isLock intValue] > 0) {
            imgV.hidden = NO;
        }else {
            imgV.hidden = YES;
        }
        
    }
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    return cell;

}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"widthwidth:%lf",tableView.frame.size.width);
    return tableView.frame.size.width;
}

-(void)checkPointAction:(CarTonButton *)sender{
    CSCheckPointModel *checkPointModel = [sender.dict valueForKey:@"checkPointModel"];
    if ([checkPointModel.isLock intValue] > 0 ) {
        UIAlertView *av = [[UIAlertView alloc]initWithTitle:@"温馨提示" message:@"您还未完成上一关通关条件" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
        [av show];
    }else{
        CSMapCourseDetailViewController *detailController = [[CSMapCourseDetailViewController alloc] initWithCourseId:checkPointModel.courseId CoureseName:checkPointModel.name];
        detailController.tollgateId = checkPointModel.tollgateId;
        detailController.studyType =  CSStudyMapType;
        detailController.titleName = checkPointModel.name;
        detailController.nextLevelSuccessAnimation = checkPointModel.cartoon;
        detailController.nextLevelFailAnimation = checkPointModel.fcartoon;
        detailController.examReultType = CSExamResultBeforeType;
        if ([checkPointModel.courseId integerValue] == 0) {
            [MBProgressHUD showToView:self.view text:@"课程正在创建中！" afterDelay:1.0 hideBlock:^(MBProgressHUD * _Nonnull hud) {
                
            }];
            return;
        }else{
         [self.navigationController pushViewController:detailController animated:YES];
        }
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    _nowPage = (scrollView.contentOffset.y+kCSScreenWidth/2)/kCSScreenWidth;
    if (_nowPage==0) {
        _beforeBtn.hidden = YES;
    }else {
        _beforeBtn.hidden = NO;
    }
    NSMutableArray *allData=[NSMutableArray array];
    for (NSArray *array in self.checkPoints) {
        [allData addObjectsFromArray:array];
    }
    NSInteger currentPage=startPullTableWithPageCount(allData, NO, 8);
    if (((int)scrollView.contentSize.height/kCSScreenWidth)==_nowPage+1&&currentPage<=0) {
        _nextBtn.hidden = YES;
    }else {
        _nextBtn.hidden = NO;
    }
    
}

NSInteger startPullTableWithPageCount(NSMutableArray* dataArray,BOOL sureMore,NSInteger count)
{
    if (sureMore==YES) {
        NSInteger resultPage=dataArray.count/count+1;
        return resultPage;
    }else{
        if (dataArray.count%count==0) {
            return dataArray.count/count+1;
        }else{
            return -1;
        }
    }
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
