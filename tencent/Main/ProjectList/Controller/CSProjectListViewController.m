//
//  CSProjectListViewController.m
//  tencent
//
//  Created by bill on 16/4/26.
//  Copyright © 2016年 cyh. All rights reserved.
//

#import "CSProjectListViewController.h"
#import "CSProjectListView.h"

#import "CSUrl.h"
#import "CSFrameConfig.h"
#import "CSUserDefaults.h"
#import "MBProgressHUD+CYH.h"
#import "CSHttpRequestManager.h"
#import "CSFrameConfig.h"

@interface CSProjectListViewController ()

@property (nonatomic, strong) CSProjectListView *projectListView;

@end

@implementation CSProjectListViewController

#pragma mark life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.projectDic = [NSMutableDictionary dictionary];
    if ([self respondsToSelector:@selector(edgesForExtendedLayout)]){
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    
    self.title = @"腾学汇";
 
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIBarButtonItem *rightBtnItem = [[UIBarButtonItem alloc] initWithTitle:@"设置" style:UIBarButtonItemStyleDone target:self action:@selector(settingDefaultProject)];
    [rightBtnItem setTintColor:[UIColor whiteColor]];
    self.navigationItem.rightBarButtonItem = rightBtnItem;
    
    [self loadInformation];
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

#pragma mark logic method
- (void)settingDefaultProject{
    
    if( self.projectListView.showType == TYPE_SHOWPROJ ){
        self.projectListView.showType = TYPE_CHOICEPROJ;
        [self.navigationItem.rightBarButtonItem setTitle:@"完成"];
        self.title = [NSString stringWithFormat:@"常用项目（%d/5)",[self.projectDic.allKeys count]];
        self.projectListView.choiceMarkDic = self.projectDic;
        [self.projectListView reloadData];
    }else{
        self.projectListView.showType = TYPE_SHOWPROJ;
        [self postNormalProject];
    }
}

- (void)postNormalProject{
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setValue:@"C" forKey:@"type"];
    [params setValue:[[CSUserDefaults shareUserDefault] getUserToken] forKey:@"token"];
    [params setValue:[[self.projectListView.choiceMarkDic allValues] componentsJoinedByString:@","] forKey:@"projectIds"];
    
    __weak CSProjectListViewController *weakSelf = self;
    [MBProgressHUD showMessage:@"加载中..." toView:self.view];
    [[CSHttpRequestManager shareManager] postDataFromNetWork:SET_NORMAL_PROJECTS parameters:params success:^(CSHttpRequestManager *manager, id model) {
        [MBProgressHUD hideHUDForView:self.view];
        
        if ( [[model objectForKey:@"code"] integerValue] == 0 ) {
            
            [weakSelf.navigationController popViewControllerAnimated:YES];
        }
        
    } failture:^(CSHttpRequestManager *manager, id nodel) {
        [MBProgressHUD hideHUDForView:self.view];
        [MBProgressHUD showError:@"请求超时"];
    }];

}

- (void)loadInformation{
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setValue:@"A" forKey:@"type"];
    [params setValue:[[CSUserDefaults shareUserDefault] getUserToken] forKey:@"token"];
    
    [MBProgressHUD showMessage:@"加载中..." toView:self.view];
    [[CSHttpRequestManager shareManager] postDataFromNetWork:GET_PROJECTS parameters:params success:^(CSHttpRequestManager *manager, id model) {
        [MBProgressHUD hideHUDForView:self.view];
        
        if ( [[model objectForKey:@"code"] integerValue] == 0 ) {
            
            NSMutableArray *projectAry = [NSMutableArray array];
            NSArray *arr = [model objectForKey:@"projectList"];
            for ( NSDictionary *dic in  arr) {
                NSInteger index = [arr indexOfObject:dic];
                CSProjectItemModel *currentProjectModel = [[CSProjectItemModel alloc] initWithDictionary:dic error:nil];
                [projectAry addObject:currentProjectModel];
                if ([currentProjectModel.addedInd boolValue]) {
                    [self.projectDic setValue:currentProjectModel.projectId forKey:[NSString stringWithFormat:@"%d",[currentProjectModel.projectId integerValue]]];
                }
            }
            
            self.projectListView.dataSourceAry = projectAry;
            [self.projectListView reloadData];
        }
        
    } failture:^(CSHttpRequestManager *manager, id nodel) {
        [MBProgressHUD hideHUDForView:self.view];
        [MBProgressHUD showError:@"请求超时"];
    }];
    
}

#pragma mark init method
- (CSProjectListView *)projectListView{
    
    if ( !_projectListView ) {
        
        _projectListView = [[CSProjectListView alloc] initWithFrame:CGRectMake( 0, 0, kCSScreenWidth, kCSScreenHeight - KNavigationHegiht)];
        _projectListView.delegate = self;
        __weak CSProjectListViewController *weakSelf = self;
        _projectListView.choiceProject = ^(NSInteger choice){
            switch ( choice ) {
                case 0:{
             
                }
                    break;
                case 1:{
                    [weakSelf.navigationController popViewControllerAnimated:YES];
                 
                }
                default:
                    break;
            }
        };
        [self.view addSubview:_projectListView];
     }
    return _projectListView;
}

@end
