//
//  CSRepositoryViewController.m
//  tencent
//
//  Created by bill on 16/4/27.
//  Copyright © 2016年 cyh. All rights reserved.
//

#import "CSRepositoryViewController.h"

#import "CSFrameConfig.h"
#import "CSConfig.h"
#import "CSRepositoryModel.h"
#import "CSRepositoryCollectionViewCell.h"

#import "MBProgressHUD+CYH.h"
#import "CSHttpRequestManager.h"
#import "CSUserModel.h"
#import "CSUserDefaults.h"
#import "CSProjectDefault.h"
#import "CSUrl.h"
#import "MJRefresh.h"

#import "CSCourseListViewController.h"
#import "CSSearchCourseViewController.h"
#import "SMBaseCollectionView.h"
#define kRepositoryCollectionViewCell @"RepositoryCollectionViewCell"


@interface CSRepositoryViewController ()<UICollectionViewDelegate,UICollectionViewDataSource>

@property (nonatomic, strong) SMBaseCollectionView *collectionView;

@property (nonatomic, strong) NSMutableArray *dataSourceAry;

@property (nonatomic, strong) NSNumber *categoryId;

@end

@implementation CSRepositoryViewController

#pragma mark life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
     [self.searchBtn setHidden:NO];
    self.dataSourceAry = [NSMutableArray array];
    self.title = @"知识库";
    self.view.backgroundColor = [UIColor whiteColor];
    [self.collectionView refreshHeaderRefresh:^{
        [self loadInforamtion];
    } withFooterRefreshingBlock:^{
        [self.collectionView endRefreshing];
//        [self loadInforamtion];
    }];
    [self loadInforamtion];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/**
 *  请求数据
 */
- (void)loadInforamtion{
    NSDictionary *params;
    if ([self.categoryId integerValue] > 0) {
        params = @{@"catalogId":self.categoryId,
                   @"projectId":[[CSProjectDefault shareProjectDefault] getProjectId],
                   @"type":@"COURSE"}; //COURSE=课程;SEMINAR=专题
    }else{
        params = @{@"projectId":[[CSProjectDefault shareProjectDefault] getProjectId],
                   @"type":@"COURSE"}; //COURSE=课程;SEMINAR=专题
    }
 
    __weak CSRepositoryViewController *weakSelf = self;
    [MBProgressHUD showMessage:@"加载中..." toView:self.view];
    [[CSHttpRequestManager shareManager] postDataFromNetWork:GET_FINE_COURSE parameters:params success:^(CSHttpRequestManager *manager, id model) {
        [MBProgressHUD hideHUDForView:weakSelf.view];
        if( [model objectForKey:@"code"] && [[model objectForKey:@"code"] integerValue] == 0 ){
            if( self.collectionView.refreshState == SMBaseTableViewRefreshStateHeader ){
                [weakSelf.dataSourceAry removeAllObjects];
            }
            if ( [[model objectForKey:@"courseList"] isKindOfClass:[NSArray class]] ) {
                for ( NSDictionary *dic in [model objectForKey:@"courseList"] ) {
                    CSRepositoryModel *model = [[CSRepositoryModel alloc] initWithDictionary:dic error:nil];
                    [weakSelf.dataSourceAry addObject:model];
                }
              [self.collectionView endReload];
            }
        }
  } failture:^(CSHttpRequestManager *manager, id nodel) {
      [self.collectionView endRefreshing];
  }];
}

#pragma mark UICollectionDelegate
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return CGSizeMake( (kCSScreenWidth - 35)/2, (kCSScreenWidth - 35)/2 + 20);
}


- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return [self.dataSourceAry count];
}


- (UICollectionViewCell *)collectionView:(UICollectionView*)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CSRepositoryCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kRepositoryCollectionViewCell forIndexPath:indexPath];
    CSRepositoryModel *model = self.dataSourceAry[indexPath.row];
   cell.model = model;
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    /**
     *  查看目录
     */
    
    CSRepositoryCollectionViewCell *cell = (CSRepositoryCollectionViewCell *)[self.collectionView cellForItemAtIndexPath:indexPath];
    [cell.unreadMarkImg setHidden:YES];
    CSRepositoryModel *model = self.dataSourceAry[indexPath.row];
    if ( [model.isParent integerValue] == 0 ) {
        CSCourseListViewController *catelogController = [[CSCourseListViewController alloc] initWithCategory:model.catalogId
                                                                                                CategoryName:model.name CourseType:@"All"];
        catelogController.hidesBottomBarWhenPushed = YES;
        catelogController.courseListType = CSCourseListRepositoryType;
        [self.navigationController pushViewController:catelogController animated:YES];
    }else if( [model.isParent integerValue] == 1 ){
        CSRepositoryViewController *catelogController = [[CSRepositoryViewController alloc] initWithCategoryId:model.catalogId
                                                                                                  CategoryName:model.name];
        catelogController.hidesBottomBarWhenPushed = YES;
        
        [self.navigationController pushViewController:catelogController animated:YES];
        
    }

}

#pragma mark init method
- (id)initWithCategoryId:(NSNumber *)categoryId CategoryName:(NSString *)categoryName{

    self = [super init];
    if( self ){
    
        self.categoryId = categoryId;
        self.title = categoryName;
    }
    return self;
}

- (UICollectionView *)collectionView{

    if ( !_collectionView ) {
        
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.footerReferenceSize  = CGSizeMake(0, 0);
        
        layout.sectionInset            = UIEdgeInsetsMake(0, 0, 0, 0);
        layout.minimumInteritemSpacing = 1.0;
        layout.minimumLineSpacing      = 5.0;
 
        _collectionView = [[SMBaseCollectionView alloc] initWithFrame:CGRectMake(15, 10, kCSScreenWidth - 30, kCSScreenHeight - 64 - 10) collectionViewLayout:layout];
        _collectionView.backgroundColor = [UIColor whiteColor];
        _collectionView.alwaysBounceVertical = YES;
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        [self.view addSubview:self.collectionView];
        [_collectionView registerNib:[UINib nibWithNibName:@"CSRepositoryCollectionViewCell" bundle:nil]
                 forCellWithReuseIdentifier:kRepositoryCollectionViewCell];
        _collectionView.showsVerticalScrollIndicator = NO;
    }
    return _collectionView;
}

-(void)searchAction:(UIButton *)sender{
    CSSearchCourseViewController *searchVC = [[CSSearchCourseViewController alloc]init];
    searchVC.rootVC = self;
    searchVC.searchType = CSSearchRepositoryType;
    self.topNav = [[CSBaseNavigationController alloc]initWithRootViewController:searchVC];
    [self.tabBarController addChildViewController:self.topNav];
    [self.tabBarController.view addSubview:self.topNav.view];
}
@end
