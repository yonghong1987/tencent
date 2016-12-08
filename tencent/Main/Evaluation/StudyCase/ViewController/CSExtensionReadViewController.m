//
//  CSExtensionReadViewController.m
//  tencent
//
//  Created by cyh on 16/8/15.
//  Copyright © 2016年 cyh. All rights reserved.
//

#import "CSExtensionReadViewController.h"
#import "CSUrl.h"
#import "CSHttpRequestManager.h"
#import "ConstFile.h"
#import "SMBaseTableView.h"
#import "CSCourseResourceModel.h"
#import "CSCaseResourceListCell.h"
#import "UITableView+SDAutoTableViewCellHeight.h"
#import "CSFrameConfig.h"
#import "CSColorConfig.h"
#import "CSReadArticleViewController.h"
#import <TVKPlayer/TVKPlayer.h>
#import "CSProjectDefault.h"
#import "CSCourseListModel.h"
#import "CSCourseListTableViewCell.h"
#import "CSNormalCourseDetailViewController.h"
#import "CSCourseDetailOperationModel.h"
#import "CSCourseDetailModel.h"
#import "CSTencentCoreDataManager.h"
#import "TYDownloadSessionManager.h"
#import "AppDelegate.h"
#import "CSUserDefaults.h"
@interface CSExtensionReadViewController ()<UITableViewDelegate,UITableViewDataSource,TVKMediaPlaybackDelegate,TVKMediaUrlRequestDelegate>
@property (nonatomic, strong) SMBaseTableView *resourseTable;
@property (nonatomic, strong) NSMutableArray *resourseArr;

/**
 *课程详情对象
 */
@property (nonatomic, strong) CSCourseDetailModel *courseDetailModel;
@end

@implementation CSExtensionReadViewController
static NSString *resourceIdentifierCell = @"resourceCell";
static NSString *courseCellIdentifier = @"CSCourseListTableViewCell";
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"延伸阅读";
    [self initUI];
    self.resourseArr = [NSMutableArray array];
    [self setRefresh];
    // Do any additional setup after loading the view.
}

-(void)setRefresh{
[self.resourseTable refreshHeaderRefresh:^{
    [self loadData];
} withFooterRefreshingBlock:^{
    [self loadData];
}];
    [self.resourseTable beginRefreshing];
}

-(void)initUI{
    self.resourseTable = [[SMBaseTableView alloc]initWithFrame:CGRectMake(0, 0, kCSScreenWidth, kCSScreenHeight - 20) style:UITableViewStylePlain];
    self.resourseTable.delegate = self;
    self.resourseTable.dataSource = self;
    self.resourseTable.backgroundColor = kBGColor;
    self.resourseTable.tableFooterView = [[UIView alloc]initWithFrame:CGRectZero];
    self.resourseTable.rowHeight = 80.0;
    [self.view addSubview:self.resourseTable];
    [self.resourseTable registerClass:[CSCaseResourceListCell class] forCellReuseIdentifier:resourceIdentifierCell];
    [self.resourseTable registerNib:[UINib nibWithNibName:NSStringFromClass([CSCourseListTableViewCell class]) bundle:nil] forCellReuseIdentifier:courseCellIdentifier];
}

-(void)loadData{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setValue:@(CONST_RP) forKey:@"rp"];
    [params setValue:@(self.resourseTable.page) forKey:@"page"];
    NSString *url;
    if (self.extensionReadType == CSExtensionReadCaseType) {
        [params setValue:self.caseId forKey:@"caseId"];
        url = GET_CASE_LIST;
    }else if (self.extensionReadType == CSExtensionReadCourseType){
        [params setValue:[[CSProjectDefault shareProjectDefault] getProjectId] forKey:@"projectId"];
        [params setValue:self.courseId forKey:@"refCourseId"];
        url = COURSE_EXTENSION_READ;
    }
    [[CSHttpRequestManager shareManager] postDataFromNetWork:url parameters:params success:^(CSHttpRequestManager *manager, id model) {
        NSMutableArray *arrayData = [NSMutableArray array];
        if (self.extensionReadType == CSExtensionReadCaseType) {
            NSArray *array = model[@"resourceList"];
            for (NSDictionary  *resourceDic in array) {
                CSCourseResourceModel *resourceModel = [[CSCourseResourceModel alloc]initWithDictionary:resourceDic error:nil];
                [arrayData addObject:resourceModel];
            }
            if (self.resourseTable.refreshState == SMBaseTableViewRefreshStateHeader) {
                self.resourseArr = arrayData;
            }else{
                [self.resourseArr addObjectsFromArray:arrayData];
            }
            [self.resourseTable endReload];
        }else if (self.extensionReadType == CSExtensionReadCourseType){
            NSArray *courseArr = model[@"courseList"];
            NSMutableArray *arrayDada = [NSMutableArray array];
            for (NSDictionary *courseDic in courseArr) {
                CSCourseListModel *course = [[CSCourseListModel alloc]initWithDictionary:courseDic error:nil];
                [arrayDada addObject:course];
            }
            if (self.resourseTable.refreshState == SMBaseTableViewRefreshStateHeader) {
                self.resourseArr = arrayDada;
            }else{
                [self.resourseArr addObjectsFromArray:arrayDada];
            }
            [self.resourseTable endReload];
        }
    } failture:^(CSHttpRequestManager *manager, id nodel) {
        [self.resourseTable endRefreshing];
    }];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.resourseArr.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.extensionReadType == CSExtensionReadCaseType) {
        CSCaseResourceListCell *cell = [tableView dequeueReusableCellWithIdentifier:resourceIdentifierCell];
        CSCourseResourceModel *resourceModel = self.resourseArr[indexPath.row];
        cell.resourceModel = resourceModel;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }else if (self.extensionReadType == CSExtensionReadCourseType){
        CSCourseListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:courseCellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell setCourseCell:self.resourseArr[indexPath.row]];
        return cell;

    }
    return 0;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.extensionReadType == CSExtensionReadCaseType) {
        CSCourseResourceModel *resourceModel = self.resourseArr[indexPath.row];
        return [self.resourseTable cellHeightForIndexPath:indexPath model:resourceModel keyPath:@"resourceModel" cellClass:[CSCaseResourceListCell class] contentViewWidth:kCSScreenWidth];
    }
    else if (self.extensionReadType == CSExtensionReadCourseType){
        return 80;
    }
    return 0;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.extensionReadType == CSExtensionReadCaseType) {
        CSCourseResourceModel *resourceModel = self.resourseArr[indexPath.row];
        if ([resourceModel.resCode isEqualToString:@"ARTICLE"]) {
            CSReadArticleViewController *readArticleVC = [[CSReadArticleViewController alloc]init];
            readArticleVC.resourceId = resourceModel.resId;
            readArticleVC.resourceTitle = resourceModel.resName;
            readArticleVC.resourceContent = resourceModel.resourceContent;
            [self.navigationController pushViewController:readArticleVC animated:YES];
        }else if ([resourceModel.resCode isEqualToString:@"VIDEO"]){
            TYDownloadState  state =  [[TYDownloadSessionManager manager]getDownloadState:resourceModel.resource];
            if (state == TYDownloadStateCompleted) {
                TYDownloadProgress * progress = [[TYDownloadSessionManager manager]getCacheProgress:resourceModel.resource];
                [self playVideoUrl:progress.filePath videoID:@"" type:resourceModel.resCode title:resourceModel.resName startPostion:0.0];
            }else{
                [self playVideoUrl:resourceModel.resource videoID:@"" type:resourceModel.resCode title:resourceModel.resName startPostion:0.0];
                
                
            }

        }
    }else if (self.extensionReadType == CSExtensionReadCourseType){
        CSCourseListModel *course = self.resourseArr[indexPath.row];
        CSNormalCourseDetailViewController *normal = [[CSNormalCourseDetailViewController alloc]initWithCourseId:course.courseId CoureseName:course.name];
        [self.navigationController pushViewController:normal animated:YES];
    }
}


-(void)playVideoUrl:(NSString *)url videoID:(NSString *)videoID type:(NSString *)type title:(NSString *)title startPostion:(float)postion
{
    TVKMediaPlayer* player = [TVKMediaPlayer sharedInstance];
    player.videoTitle = title;
    player.videoTitleMark = @"";
    player.delegate = self;
    NSLog(@"[CSAppDelegate sharedInstance].timeDuration:%f",[AppDelegate sharedInstance].timeDuration);
    if ((int)postion==(int)[AppDelegate sharedInstance].timeDuration) {
        postion=0;
    }
    //在播放前打开播放器界面
    [player presentMediaPlayerWithViewController:self];
    if ([type isEqualToString:@"VIDEO"]) {
        [player openMediaPlayerWithUrl:url live:NO videoID:nil startPosition:postion];
    }else if([type isEqualToString:@"LIVEVIDEO"]){
        [player openMediaPlayerWithChannelID:videoID];
    }
    [player removeCustomViewWithLayerID:TVKMediaPlayerCustomLayerIDBegin+1 smallOrMainPlayer:NO];
    [player removeCustomViewWithLayerID:TVKMediaPlayerCustomLayerIDBegin+2 smallOrMainPlayer:NO];
    NSString *str=[[CSUserDefaults shareUserDefault] getUserName];
    if (str.length>0) {
        NSMutableString* muStr=[NSMutableString string];
        CGSize muSize=[muStr sizeWithFont:[UIFont systemFontOfSize:22.0]];
        while (muSize.width<600.0) {
            [muStr appendString:str];
            muSize=[muStr sizeWithFont:[UIFont systemFontOfSize:22.0]];
        }
        UILabel* lb=[[UILabel alloc] initWithFrame:CGRectMake(-100.0,-10.0,600.0, 30.0)];
        lb.backgroundColor=[UIColor clearColor];
        lb.textColor = [UIColor colorWithRed:200.0/255.0 green:200.0/255.0 blue:200.0/255.0 alpha:0.8];
        lb.font = [UIFont fontWithName:@"Verdana" size:17];
        lb.textAlignment=NSTextAlignmentCenter;
        
        lb.text=[NSString stringWithFormat:@"%@",muStr];
        lb.transform=CGAffineTransformMakeRotation(M_PI/180.0*(-20.0));
        UILabel* twoLb=[[UILabel alloc] initWithFrame:CGRectMake(40.0,300.0,600.0, 30.0)];
        twoLb.backgroundColor=[UIColor clearColor];
        twoLb.textColor=[UIColor colorWithRed:200.0/255.0 green:200.0/255.0 blue:200.0/255.0 alpha:0.8];
        twoLb.font=[UIFont fontWithName:@"Verdana" size:17];
        twoLb.textAlignment=NSTextAlignmentCenter;
        twoLb.text =[NSString stringWithFormat:@"%@",muStr];
        twoLb.transform=CGAffineTransformMakeRotation(M_PI/180.0*(-20.0));
        
        [player addCustomView:lb withLayerID:TVKMediaPlayerCustomLayerIDBegin+1 smallOrMainPlayer:NO];
        [player addCustomView:twoLb withLayerID:TVKMediaPlayerCustomLayerIDBegin+2 smallOrMainPlayer:NO];
    }
}
#pragma mark - TVKMediaPlaybackDelegate
- (NSString*)mediaPlayer:(TVKMediaPlayer*)mediaPlayer willPlayUrl:(NSString*)url
{
    NSLog(@"willPlayUrl:%@", url);
    return url;
}

- (void)mediaPlayer:(TVKMediaPlayer*)mediaPlayer stateChanged:(TVKMediaPlayerState)state withError:(NSError*)error
{
    if(state==11){
    
    }else if(state==14){
       
    }
}



- (void)mediaPlayer:(TVKMediaPlayer*)mediaPlayer screenChanged:(BOOL)fullScreen
{
    NSLog(@"self.view:%@",self.view);
    NSLog(@"screenChanged:%d", fullScreen);
}

- (void)mediaPlayer:(TVKMediaPlayer*)mediaPlayer eventOccur:(TVKMediaPlayerEvent)event userInfo:(NSDictionary*)userInfo
{
    NSLog(@"eventOccur:%d userInfo:%@", event, userInfo);
    if (event == TVKMediaPlayerEventSkipAD) {
        [mediaPlayer skipAdertisement];
    }else if (event == TVKMediaPlayerEventChangeVideo) {
        NSLog(@"%@", userInfo);
    }
}

- (void)mediaPlayer:(TVKMediaPlayer*)mediaPlayer progressUpdated:(NSTimeInterval)currentTime duration:(NSTimeInterval)duration
{
    
    self.vedioProgress = (float)currentTime;
    [AppDelegate sharedInstance].timeDuration=duration;
    self.timeDuration = duration;
    NSLog(@"progressUpdated:%lf duration:%lf", currentTime, duration);
    
}

#pragma mark - TVKMediaUrlRequestDelegate
- (void)didMediaUrlRequestFinished:(TVKMediaUrlRequest*)request videoUrls:(NSArray*)videoUrls viedoDurations:(NSArray*)videoDurations
{
    NSLog(@"videoUrls:%@", videoUrls);
    NSLog(@"videoDurations:%@", videoDurations);
}

- (void)didMediaUrlRequestUpdated:(TVKMediaUrlRequest*)request videoUrls:(NSArray*)videoUrls viedoDurations:(NSArray*)videoDurations
{
    NSLog(@"videoUrls:%@", videoUrls);
    NSLog(@"videoDurations:%@", videoDurations);
}

- (void)didMediaUrlRequestFailed:(TVKMediaUrlRequest*)request error:(NSError*)error
{
    NSLog(@"%@", error);
}

//调用资源浏览数记录接口
-(void)resourceBrowseWithResource:(CSCourseResourceModel *)resource
{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setValue:resource.resId forKey:@"resId"];
    [params setValue:resource.modId forKey:@"modId"];
//    [params setValue:self.courseDetailContent.courseId forKey:@"courseId"];
    [[CSHttpRequestManager shareManager] postDataFromNetWork:RESOURCE_BROWSE parameters:params success:^(CSHttpRequestManager *manager, id model) {
        
    } failture:^(CSHttpRequestManager *manager, id nodel) {
        
    }];
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
