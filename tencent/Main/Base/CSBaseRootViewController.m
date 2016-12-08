//
//  CSBaseRootViewController.m
//  tencent
//
//  Created by bill on 16/4/26.
//  Copyright © 2016年 cyh. All rights reserved.
//

#import "CSBaseRootViewController.h"
#import "CSProjectListViewController.h"

#import "CSNavigationTitleView.h"
#import "UIView+SDAutoLayout.h"
#import "CSUrl.h"
#import "CSFrameConfig.h"
#import "CSUserDefaults.h"
#import "MBProgressHUD+CYH.h"
#import "CSHttpRequestManager.h"
#import "CSProjectDefault.h"

@interface CSBaseRootViewController ()




@property (nonatomic,strong) UIImageView *imageUpView;

@property (nonatomic, strong) CSProjectListView *projectListView;

@property (nonatomic, assign) BOOL showProjectList;

@property (nonatomic, strong)CSNavigationTitleView *customTitleView;

@end

@implementation CSBaseRootViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    if ([self respondsToSelector:@selector(edgesForExtendedLayout)]){
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }

    [self initTitleView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
    [self hiddenProjectList];
}

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark 初始化
/**
 *  初始化titleView
 */
- (void)initTitleView{
    
    self.customTitleView = [[CSNavigationTitleView alloc] initWithNomalImageName:@"icon_play_white"
                                                               SelectedImageName:@"arrowDown"];

    self.navigationItem.titleView=self.customTitleView;
    UITapGestureRecognizer *gesTap = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                             action:@selector(responseToGes)];
    [self.navigationItem.titleView addGestureRecognizer:gesTap];
}

/**
 *  切换显示项目列表
 */
- (void)responseToGes{
        self.showProjectList = !self.showProjectList;
        if ( self.showProjectList ) {
            
            [self loadInformation];

            
        }else{
            
            [self hiddenProjectList];

        }
}


- (void)changedProjectItem{
    
}

- (void)hiddenProjectList{
    
    if (self.showProjectList) {
    self.showProjectList = !self.showProjectList;
    }
    
    
    [self.customTitleView.contentImg setImage:[UIImage imageNamed:@"icon_play_white"]];
    
    [self.imageUpView removeFromSuperview];
    self.imageUpView =nil;
    
    [self.projectListView removeFromSuperview];
    self.projectListView = nil;

    [self.projectBackView removeFromSuperview];
    self.projectBackView = nil;
}

- (void)needRefreashData:(BOOL)refreash{
    [self hiddenProjectList];
    if ( refreash ) {
        [self changedProjectItem];
    }
}

- (void)loadInformation{
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setValue:@"C" forKey:@"type"];
    [MBProgressHUD showMessage:@"加载中..." toView:self.view];
    
    [[CSHttpRequestManager shareManager] postDataFromNetWork:GET_PROJECTS parameters:params success:^(CSHttpRequestManager *manager, id model) {
        [MBProgressHUD hideHUDForView:self.view];
        
        if ( [[model objectForKey:@"code"] integerValue] == 0 ) {
            
            NSMutableArray *projectAry = [NSMutableArray array];
            
            int j = 0;
            for ( NSDictionary *dic in [model objectForKey:@"projectList"] ) {
                
                if ( j < 5 ) {
                    
                    j++;
                    CSProjectItemModel *currentProjectModel = [[CSProjectItemModel alloc] initWithDictionary:dic error:nil];
                    [projectAry addObject:currentProjectModel];
                    
                }else{
                    
                    break;
                    
                }
            }
            
            CSProjectItemModel *allProject = [[CSProjectItemModel alloc] init];
            allProject.projectId = @(0);
            allProject.name = @"全部";
            allProject.img = @"project_all";
//            img_more
            allProject.appName = @"全部";
            allProject.addedInd = @(0);
            [projectAry addObject:allProject];
            [self.customTitleView.contentImg setImage:[UIImage imageNamed:@"icon_play_white_up"]];
            [[UIApplication sharedApplication].keyWindow addSubview:self.imageUpView];
            [[UIApplication sharedApplication].keyWindow addSubview:self.projectBackView];
            [[UIApplication sharedApplication].keyWindow addSubview:self.projectListView];
            self.projectListView.dataSourceAry = projectAry;
            CGRect frame = self.projectListView.frame;
            frame.size.height = 120 * ([projectAry count]/3 + ( ([projectAry count]%3 != 0) ? 1 : 0) );
            self.projectListView.frame = frame;
            [self.projectListView reloadData];
        }
        
    } failture:^(CSHttpRequestManager *manager, id nodel) {
        [MBProgressHUD hideHUDForView:self.view];
        [MBProgressHUD showError:@"请求超时"];
    }];
}

-(UIImageView *)imageUpView{
    
    if (!_imageUpView) {
        UIImage *upImage =[UIImage imageNamed:@"arrowUp"];
        _imageUpView=[[UIImageView alloc]initWithFrame:CGRectMake(0,KNavigationHegiht-upImage.size.height+2,upImage.size.width,upImage.size.height)];
        _imageUpView.centerX=kCSScreenWidth/2;
        _imageUpView.image=upImage;
    }
    return _imageUpView;

}
- (UIView *)projectBackView{
    if ( !_projectBackView ) {
        CGRect listFrame = [[UIScreen mainScreen] bounds];
        listFrame.origin.y = KNavigationHegiht;
        listFrame.size.height -= KNavigationHegiht;
        _projectBackView = [[UIView alloc] initWithFrame:listFrame];
        _projectBackView.backgroundColor = [UIColor blackColor];
        _projectBackView.alpha = 0.3;
      
        UITapGestureRecognizer *tapGes = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hiddenProjectList)];
        [_projectBackView addGestureRecognizer:tapGes];
    }
    return _projectBackView;
}

- (CSProjectListView *)projectListView{

    if ( !_projectListView ) {
        
        CGRect listFrame = [[UIScreen mainScreen] bounds];
        listFrame.origin.y = KNavigationHegiht;
        _projectListView = [[CSProjectListView alloc] initWithFrame:listFrame];
        
        __weak CSBaseRootViewController *weakSelf = self;
        _projectListView.choiceProject = ^(NSInteger choice){
            switch ( choice ) {
                case 0:{
                    CSProjectListViewController *projectVC = [[CSProjectListViewController alloc] init];
                    projectVC.hidesBottomBarWhenPushed = YES;
                    [weakSelf.navigationController pushViewController:projectVC animated:YES];
                }
                    break;
                case 1:{
                     //点击了当前项目
                    [weakSelf needRefreashData:NO];
                }
                    break;
                case 2:{
                    //切换了当前项目
                    [weakSelf needRefreashData:YES];
                }
                    break;
                default:
                    break;
            }
        };

    }
    return _projectListView;
}


@end
