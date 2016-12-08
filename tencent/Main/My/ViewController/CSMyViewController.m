//
//  CSMyViewController.m
//  tencent
//
//  Created by sunon002 on 16/4/16.
//  Copyright © 2016年 cyh. All rights reserved.
//

#import "CSMyViewController.h"
#import "CSMyView.h"
#import "CSMyCollectionViewController.h"

#import "CSMyDownloadViewController.h"
#import "CSStudyRecordViewController.h"
#import "CSMyPostViewController.h"
#import "CSPracticeRecordViewController.h"

#import "CSHttpRequestManager.h"
#import "MBProgressHUD+CYH.h"
#import "CSUrl.h"
#import "CSUserDefaults.h"
#import "CSAppVersionModel.h"
#import "CSMyCommentViewController.h"
#import "AppDelegate+Category.h"
#import "CSNotificationConfig.h"
@interface CSMyViewController ()<UIAlertViewDelegate>

@property (nonatomic, strong) CSMyView *myCenterView;
//帖子数
@property (nonatomic, copy) NSString *forumCount;
//评论数
@property (nonatomic, copy) NSString *commentCount;
@end

@implementation CSMyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.backBtn setHidden:YES];
    // Do any additional setup after loading the view from its nib.
    self.title = @"我";
    self.tabBarController.tabBar.selectedItem.title = @"";
    
    self.myCenterView = [[CSMyView alloc] initWithFrame:self.view.bounds];
    [self selectedRowIndex];
    [self.view addSubview:self.myCenterView];
}

-(void)passCommentCount:(NSNotification *)noti{
    [self.myCenterView.myCenterTable reloadData];
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(passCommentCount:) name:kNotificationCommentCountAndForumCount object:nil];
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
  self.forumCount = [ud objectForKey:@"forumBadgeCount"];
  self.commentCount = [ud objectForKey:@"commentBadgeCount"];
    [ud synchronize];
    
    UIButton *forumBtn = [self.myCenterView.tableHeadView viewWithTag:4];
    if ([self.forumCount isEqualToString:@"0"] || self.forumCount == nil) {
        [forumBtn setHidden:YES];
        
    }else{
        [forumBtn setHidden:NO];
        [forumBtn setTitle:self.forumCount forState:UIControlStateNormal];
    }

    UITabBarItem * forumItem=[self.tabBarController.tabBar.items objectAtIndex:3];
    NSInteger badgeCount = [self.forumCount integerValue] + [self.commentCount integerValue];
    if (badgeCount == 0) {
        forumItem.badgeValue=nil;
    }else{
        forumItem.badgeValue=[NSString stringWithFormat:@"%d",badgeCount];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)selectedRowIndex{
    
    __weak CSMyViewController *weakSelf = self;
    self.myCenterView.selectedRowIndex = ^(NSInteger selectedRowIndex){
    
        switch ( selectedRowIndex ) {
            case 0:{
                //修改个人资料
            }
                break;
            case 1:{
                //学习记录
                CSStudyRecordViewController *studyRecord = [[CSStudyRecordViewController alloc]init];
                studyRecord.hidesBottomBarWhenPushed = YES;
                [weakSelf.navigationController pushViewController:studyRecord animated:YES];
            }
                break;
            case 2:{
                //实战记录
                CSPracticeRecordViewController *practice = [[CSPracticeRecordViewController alloc]init];
                practice.hidesBottomBarWhenPushed = YES;
                [weakSelf.navigationController pushViewController:practice animated:YES];
            }
                break;
            case 3:{
                //我的帖子
                CSMyPostViewController *myPost = [[CSMyPostViewController alloc]init];
                myPost.hidesBottomBarWhenPushed = YES;
                [weakSelf.navigationController pushViewController:myPost animated:YES];
                weakSelf.forumCount = @"0";
                NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
                [ud setValue:@"0" forKey:@"forumBadgeCount"];
                [ud synchronize];
                
                UITabBarItem * forumItem=[weakSelf.tabBarController.tabBar.items objectAtIndex:3];
                forumItem.badgeValue=weakSelf.commentCount;
            }
                break;
            case 4:{
                //我的收藏
                CSMyCollectionViewController *myCollect = [[CSMyCollectionViewController alloc]init];
                myCollect.hidesBottomBarWhenPushed = YES;
                [weakSelf.navigationController pushViewController:myCollect animated:YES];
            }
                break;
            case 5:{
                //我的下载
                CSMyDownloadViewController *downloadVC = [[CSMyDownloadViewController alloc] init];
                downloadVC.hidesBottomBarWhenPushed = YES;
                [weakSelf.navigationController pushViewController:downloadVC animated:YES];
            }
                break;
            case 6:{
                //我的评论
                CSMyCommentViewController *myCommentVC = [[CSMyCommentViewController alloc]init];
                myCommentVC.hidesBottomBarWhenPushed = YES;
                [weakSelf.navigationController pushViewController:myCommentVC animated:YES];
                weakSelf.commentCount = @"";
                NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
                [ud setValue:@"0" forKey:@"commentBadgeCount"];
                [ud synchronize];
                UITabBarItem * forumItem=[weakSelf.tabBarController.tabBar.items objectAtIndex:3];
                forumItem.badgeValue=weakSelf.forumCount;
                
            }
                break;
            case 7:{
                //当前版本
                [[CSAppVersionModel shareInstance] checkVersion:weakSelf.view ShowTip:YES];
            }
                break;
            case 8:{
                //退出账号
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示"
                                                                message:@"确定要退出账号吗"
                                                               delegate:weakSelf
                                                      cancelButtonTitle:@"取消"
                                                      otherButtonTitles:@"确定", nil];
                [alert show];
            }
                break;
            default:
                break;
        }
    };
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if ( 1 == buttonIndex ) {
        [self exitAccount];
    }
}

- (void)exitAccount{

    [MBProgressHUD showMessage:@"加载中..." toView:self.view];
    
    __weak CSMyViewController *weakSelf = self;
    [[CSHttpRequestManager shareManager] postDataFromNetWork:URL_USER_LOGINOUT parameters:nil success:^(CSHttpRequestManager *manager, id model) {
        [MBProgressHUD hideHUDForView:weakSelf.view];
        
        NSInteger code = [[(NSDictionary *)model objectForKey:@"code"] integerValue];
        if ( 0 == code ) {
#warning 退出ITLogin的需要补充
            [[CSUserDefaults shareUserDefault] clearUserMessage];
            [[AppDelegate sharedInstance] enterLoginVC];
        }
        
    }failture:^(CSHttpRequestManager *manager, id nodel) {
        [MBProgressHUD hideHUDForView:weakSelf.view];

        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示"
                                                            message:[NSString stringWithFormat:@"%@",@"退出失败"]
                                                           delegate:nil
                                                  cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alertView show];
    }];
}

@end
