//
//  CSForumViewController.m
//  tencent
//
//  Created by sunon002 on 16/4/16.
//  Copyright © 2016年 cyh. All rights reserved.
//

#import "CSForumViewController.h"
#import "CSForumListViewController.h"

#import "JQNavTabBarController.h"

#import "CSFrameConfig.h"
#import "CSCourseAndExamConfig.h"
#import "CSHotForumListViewController.h"
#import "UIBarButtonItem+Common.h"
#import "CSSendNoticeView.h"
#import "CSHttpRequestManager.h"
#import "CSProjectDefault.h"
#import "SMUploadImageApi.h"
#import "MBProgressHUD+SMHUD.h"
#import "NSDictionary+convenience.h"
#import "CSPostListModel.h"
#import "CSNotificationConfig.h"
@interface CSForumViewController ()<CSSendNoticeDelegate>
@property(nonatomic,strong) NSMutableArray *subViewControllers;
@property(nonatomic,strong) JQNavTabBarController *navTabBarController;
@property (nonatomic, strong)CSForumListViewController *child1;
@property (nonatomic, strong)CSHotForumListViewController *child2;
@end

@implementation CSForumViewController

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    UITabBarItem * forumItem=[self.tabBarController.tabBar.items objectAtIndex:2];
    forumItem.badgeValue=nil;

}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self.backBtn setHidden:YES];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.subViewControllers = [NSMutableArray array];
    [self addViewControllers];
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem itemWithBtnTitle:@"发帖" actionBolock:^(UIBarButtonItem *commitBtn) {
        [self sendPost];
    }];
    
    // Do any additional setup after loading the view from its nib.
}

- (void)changedProjectItem{
    [self.child1 changedProjectMenuItem];
    [self.child2 changedProjectMenuItem];
}
#pragma mark controlInit
- (void)addViewControllers{
    self.child1 = [[CSForumListViewController alloc]init];
    self.child1.title = @"最新帖";
    self.child1.forumType = kNewForumType;
    [self.subViewControllers addObject:self.child1];
    
    self.child2 = [[CSHotForumListViewController alloc]init];
    self.child2.title = @"热门贴";
    self.child2.forumType = kHotForumType;
    [self.subViewControllers addObject:self.child2];
    
    self.navTabBarController = [[JQNavTabBarController alloc] init];
    self.navTabBarController.preferredContentSize = CGSizeMake(self.view.frame.size.width, self.view.frame.size.height);
    
    self.navTabBarController.viewControllers = self.subViewControllers;
    [self addChildViewController:self.navTabBarController];
    [self.view addSubview:self.navTabBarController.view];
}

- (void)sendPost{
    CSSendNoticeView *sendNotice = [[CSSendNoticeView alloc]initWithTitle:@"发帖" delegate:self leftBtnImage:[UIImage imageNamed:@"icon_cancle"] rightBtnImage:[UIImage imageNamed:@"icon_ok"] csSendType:CSSendNoticeTypePicture];
    [sendNotice show];
}

-(void)alertNotificeView:(CSSendNoticeView *)alertView clickButtonAtIndex:(NSInteger)index params:(NSMutableDictionary *)dict{
    
    if (index == 1) {
        NSString* content=[dict objectForKey:@"content"];
        NSMutableDictionary *parames = [NSMutableDictionary dictionary];
        NSNumber *projectId = [[CSProjectDefault shareProjectDefault] getProjectId];
        [parames setValue:projectId forKey:@"projectId"];
        [parames setValue:content forKey:@"content"];
        SMUploadImageApi *uploadImageApi = [[SMUploadImageApi alloc] init];
         uploadImageApi.images = [dict objectForKey:@"images"];
        if (content.length == 0) {
            [MBProgressHUD showToView:self.view text:@"请填写文字！" afterDelay:1.0 hideBlock:^(MBProgressHUD * _Nonnull hud) {
            }];
            return;
        }
        uploadImageApi.requestArgument = parames;
        uploadImageApi.requestUrl = SEND_POST;
        uploadImageApi.fileImageKey = @"fileImg";
        [uploadImageApi startWithCompletionBlockWithSuccess:^(id responseJSONObject, NSInteger responseCode) {
            [MBProgressHUD hideToView:self.view];
            if (responseCode == 0) {
                [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationSavePostSuccess object:nil userInfo:@{@"saveSuccess":@"success"}];
                
                
                [MBProgressHUD showToView:self.view text:@"发帖成功" afterDelay:1.0 hideBlock:^(MBProgressHUD * _Nonnull hud) {
                    
                }];
            }else{
                [MBProgressHUD showToView:self.view text:@"发帖失败" afterDelay:1.0 hideBlock:^(MBProgressHUD * _Nonnull hud) {
                    
                }];
            }
        } withFailure:^(NSError *error) {
            [MBProgressHUD showToView:self.view text:@"发帖失败" afterDelay:1.0 hideBlock:^(MBProgressHUD * _Nonnull hud) {
                
            }];

        } showHUDToView:self.view];
    }
    NSLog(@"index:%ld",index);
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    
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
