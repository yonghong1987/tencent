//
//  CSSpecialDetailViewController.m
//  tencent
//
//  Created by admin on 16/5/4.
//  Copyright © 2016年 cyh. All rights reserved.
//

#import "CSSpecialDetailViewController.h"
#import "CSHttpRequestManager.h"
#import "CSUrl.h"
#import "CSUserDefaults.h"
#import "CSProjectDefault.h"
#import "CSSpecialListModel.h"
#import "CSFrameConfig.h"
#import "CSSpecialDetailCell.h"
#import "CSSpecialHeadCell.h"
#import "UITableView+SDAutoTableViewCellHeight.h"
#import "UIView+SDAutoLayout.h"
#import "CSConfig.h"
#import "CSColorConfig.h"
#import "CSFontConfig.h"
#import "CSSpecialBottomView.h"
#import "CSSpecialCommentViewController.h"
#import "CSShareView.h"
#import "MBProgressHUD+CYH.h"
#import "CSCourseAndExamConfig.h"
#import "SMGlobalApi.h"
#import "MBProgressHUD+SMHUD.h"
@interface CSSpecialDetailViewController ()
/*
 **专题详情model
*/
@property (nonatomic, strong) CSSpecialListModel *specialListModel;
/*
 **用于存放webView高度的key
*/
@property (nonatomic, strong) NSMutableDictionary *heightDic;
/*
 **底部点赞、评论、收藏和分享视图
*/
@property (nonatomic, strong) CSSpecialBottomView *bottomView;
@end

@implementation CSSpecialDetailViewController

static NSString *const specialIdentifier = @"specialDetailCell";
static NSString *const specialHeadIdentifier = @"specialHeadCell";

- (void)viewDidLoad {
    
    [super viewDidLoad];
    self.heightDic = [[NSMutableDictionary alloc] init];
    self.title = @"专题";
    // 注册加载完成高度的通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(noti:) name:@"WEBVIEW_HEIGHT" object:nil];
    [self loadData];
    
    // Do any additional setup after loading the view.
}

//#pragma mark controlInit
- (UITableView*)detailTable{
    if (!_detailTable) {
        _detailTable = [[SMBaseTableView alloc]initWithFrame:CGRectMake(0, 0, kCSScreenWidth , kCSScreenHeight - 64 - 49) style:UITableViewStylePlain];
        _detailTable.delegate = self;
        _detailTable.dataSource = self;
        _detailTable.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
        _detailTable.backgroundColor = kBGColor;
        _detailTable.separatorStyle = UITableViewCellSeparatorStyleNone;
        [self.view addSubview:_detailTable];
    }
    return _detailTable;
}

- (void)addBottomView{
    WS(weakSelf);
    _bottomView = [[CSSpecialBottomView alloc] init];
    _bottomView.frame = CGRectMake(0, kCSScreenHeight - 49 - 64, kCSScreenWidth, 49);
    _bottomView.buttonViewType = CSSpecialDetailBottomView;
    _bottomView.specialModel = self.specialListModel;
    [self.view addSubview:_bottomView];
    //评论
    _bottomView.commentActionBlock = ^(){
        CSSpecialCommentViewController *commentVC = [[CSSpecialCommentViewController alloc] init];
        commentVC.targetid = weakSelf.specialid;
        commentVC.commentType = kCommentSpecail;
        
        [weakSelf.navigationController pushViewController:commentVC animated:YES];
    };
    //分享
    _bottomView.shareActionBlock = ^(){
        CSShareView *shareView = [[CSShareView alloc] init];
        shareView.viewController = weakSelf;
        [shareView showShareView];
    };
    //点赞
    _bottomView.praiseActionBlock = ^(){
         SMClickGlobaPraise *commentPraise = [[SMClickGlobaPraise alloc]init];
        commentPraise.targetId = weakSelf.specialListModel.activityId;
        commentPraise.targetType = SMGlobalApiSpecialPraise;
        [commentPraise startWithPraiseId:weakSelf.specialListModel.praiseId completionBlockWithSuccess:^(id responseJSONObject, NSInteger responseCode) {
            if (responseCode == 0) {
                weakSelf.specialListModel.praiseId = responseJSONObject[@"praiseId"];
                if ([weakSelf.specialListModel.praiseId integerValue] > 0) {
                    NSInteger praiseCount = [weakSelf.specialListModel.praiseCount integerValue] + 1;
                    weakSelf.specialListModel.praiseCount = [NSNumber numberWithInteger:praiseCount];
                    [MBProgressHUD showToView:weakSelf.view text:@"点赞成功" afterDelay:1.0 hideBlock:^(MBProgressHUD * _Nonnull HUD) {
                        
                    }];
                    [weakSelf.bottomView.praiseBtn setImage:[UIImage imageNamed:@"icon_yidianzan"] forState:UIControlStateNormal];
                }else{
                    NSInteger praiseCount = [weakSelf.specialListModel.praiseCount integerValue] - 1;
                    [MBProgressHUD showToView:weakSelf.view text:@"取消点赞成功" afterDelay:1.0 hideBlock:^(MBProgressHUD * _Nonnull HUD) {
                        
                    }];
                    weakSelf.specialListModel.praiseCount = [NSNumber numberWithInteger:praiseCount];
                    [weakSelf.bottomView.praiseBtn setImage:[UIImage imageNamed:@"icon_dianzan"] forState:UIControlStateNormal];
                }
            }
        } withFailure:^(NSError *error) {
           [MBProgressHUD hideToView:weakSelf.view];
        }];
    };
    //收藏
    _bottomView.collectActionBlock = ^(){
        SMGlobalCollect *collect = [[SMGlobalCollect alloc]init];
        collect.targetId = weakSelf.specialListModel.activityId;
        collect.targetType = SMGlobalApiSpecialCollect;
        if ([weakSelf.specialListModel.collectId integerValue] > 0) {
            
        }else{
            collect.titleString = weakSelf.specialListModel.name;
        }
        [collect startWithCollectId:weakSelf.specialListModel.collectId completionBlockWithSuccess:^(id responseJSONObject, NSInteger responseCode) {
            if (responseCode == 0) {
                weakSelf.specialListModel.collectId = responseJSONObject[@"collectId"];
                if ([weakSelf.specialListModel.collectId integerValue] > 0) {
                    [MBProgressHUD showToView:weakSelf.view text:@"收藏成功" afterDelay:1.0 hideBlock:^(MBProgressHUD * _Nonnull HUD) {
                        
                    }];
                    [weakSelf.bottomView.collectBtn setImage:[UIImage imageNamed:@"icon_yishoucang"] forState:UIControlStateNormal];
                }else{
                    [MBProgressHUD showToView:weakSelf.view text:@"取消收藏成功" afterDelay:1.0 hideBlock:^(MBProgressHUD * _Nonnull HUD) {
                        
                    }];
                    [weakSelf.bottomView.collectBtn setImage:[UIImage imageNamed:@"icon_shoucang"] forState:UIControlStateNormal];
                }
            }
        } withFailure:^(NSError *error) {
            [MBProgressHUD hideToView:weakSelf.view];
        }];
    };
}

#pragma mark loadData
- (void)loadData{
    NSMutableDictionary *paramters = [NSMutableDictionary dictionary];
    [paramters setValue:self.specialid forKey:@"activityId"];
    [[CSHttpRequestManager shareManager] postDataFromNetWork:GET_SPECIAL_DETAIL parameters:paramters success:^(CSHttpRequestManager *manager, id model) {
            self.specialListModel = [[CSSpecialListModel alloc]initWithDictionary:model error:nil];
            [self.detailTable endReload];
        [self addBottomView];
    } failture:^(CSHttpRequestManager *manager, id nodel) {
        [self.detailTable endRefreshing];

    }];
}

#pragma mark UITableViewDelegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 2;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row ==0) {
        CSSpecialHeadCell *headCell = [tableView dequeueReusableCellWithIdentifier:specialHeadIdentifier];
        if (!headCell) {
            headCell = [[CSSpecialHeadCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:specialHeadIdentifier];
        }
        headCell.specialListModel = self.specialListModel;
           return headCell;
    }else if (indexPath.row == 1){
        CSSpecialDetailCell *cell =[tableView dequeueReusableCellWithIdentifier:specialIdentifier];
        if (!cell) {
            cell = [[CSSpecialDetailCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:specialIdentifier];
        }
        cell.tag = indexPath.row;
        cell.viewController = self;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.specialListModel = self.specialListModel;
        return cell;
    }
    return 0;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.row == 0) {
        return [self.detailTable cellHeightForIndexPath:indexPath model:self.specialListModel keyPath:@"specialListModel" cellClass:[CSSpecialHeadCell class] contentViewWidth:kCSScreenWidth - 60 ];
    }else if (indexPath.row == 1){
        return [[self.heightDic objectForKey:[NSString stringWithFormat:@"%ld",indexPath.row]] floatValue];
    }
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return CGFLOAT_MIN;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return CGFLOAT_MIN;
}

#pragma mark - NSNotification
- (void)noti:(NSNotification *)sender
{
    CSSpecialDetailCell *cell = [sender object];
    if (![self.heightDic objectForKey:[NSString stringWithFormat:@"%ld",cell.tag]]||[[self.heightDic objectForKey:[NSString stringWithFormat:@"%ld",cell.tag]] floatValue] != cell.height)
    {
        [self.heightDic setObject:[NSNumber numberWithFloat:cell.height] forKey:[NSString stringWithFormat:@"%ld",cell.tag]];
        [self.detailTable reloadData];
    }
}


-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
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
