//
//  CSMyDownloadViewController.m
//  tencent
//
//  Created by bill on 16/5/24.
//  Copyright © 2016年 cyh. All rights reserved.
//

#import "CSMyDownloadViewController.h"
#import "CSDownLoadCourseModel.h"
#import "CSDownLoadResourceModel.h"
#import "CSNormalCourseDetailViewController.h"
#import "CSCoreDataManager.h"
#import "CSCourseDownloadTableViewCell.h"
#import "CSDeleteVideoFileModel.h"
#import "CSNotificationConfig.h"
#import "CSDownLoadResourceModel.h"
#import "TYDownloadSessionManager.h"


#import "CSTencentCoreDataManager.h"
#import "CSCourseDetailModel.h"
#import "UIAlertView+Utils.h"
@interface CSMyDownloadViewController ()<NSFetchedResultsControllerDelegate,UIAlertViewDelegate,UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) CSDownLoadCourseModel *delModel;

@property (nonatomic, strong) NSArray *courseDetailArray;

@end

@implementation CSMyDownloadViewController


#pragma mark init
- (UITableView *)tableView{
    if ( !_tableView ) {
        _tableView = [[UITableView alloc] initWithFrame:self.view.bounds];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        [_tableView registerNib:[UINib nibWithNibName:@"CSCourseDownloadTableViewCell" bundle:nil] forCellReuseIdentifier:@"CSCourseDownloadTableViewCell"];
        _tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    }
    return _tableView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"我的下载";
    [self.view addSubview:self.tableView];
    [self loadDownLoad];

}

///加载下载数据
- (void)loadDownLoad{
   NSArray * jsonData = [CSTencentCoreDataManager queryCourseAll];
    NSMutableArray * courseDetailArray = [NSMutableArray array];
    for (NSDictionary * dict in jsonData) {
        CSCourseDetailModel * model = [[CSCourseDetailModel alloc]initWithDictionary:dict error:nil];
        [courseDetailArray addObject:model];
    }
    self.courseDetailArray = courseDetailArray;
    [self.tableView reloadData];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSArray * jsonData = [CSTencentCoreDataManager queryCourseAll];
    CSNormalCourseDetailViewController *detailController = [[CSNormalCourseDetailViewController alloc] init];
    detailController.jsonModel = jsonData[indexPath.row];
    detailController.openType = CALL_DOWNLOAD;
    [ self.navigationController pushViewController:detailController animated:YES];
}

#pragma mark--
#pragma mark--UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    // Return the number of rows in the section.
  
    return self.courseDetailArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 80;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    CSCourseDownloadTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CSCourseDownloadTableViewCell"];
    
    CSCourseDetailModel * courseModel = self.courseDetailArray [indexPath.row];
    
    cell.courseModel = courseModel;
    
    NSArray * resourceArr = courseModel.contentList;
    [self statisticalDownloadNumber:resourceArr withCell:cell];
    
    
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath{
    return @"删除";
}

-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle==UITableViewCellEditingStyleDelete) {
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"确认删除该课程吗？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
     
        [alert showAlertViewWithCompleteBlock:^(NSInteger buttonIndex) {
            if (buttonIndex ==1) {
                
                
                CSCourseDetailModel * courseModel = self.courseDetailArray [indexPath.row];
             
                
                ///删除内存中数据
                NSMutableArray * courseDetailArray = [self.courseDetailArray mutableCopy];
                [courseDetailArray removeObject:courseModel];
                self.courseDetailArray = courseDetailArray;
                
                ///删除 数据库
                [CSTencentCoreDataManager deleteCourseDetail:courseModel.courseId];
                
                ///删除下载
                
                for (CSCourseResourceModel * resourceModel in courseModel.contentList) {
                    if ([resourceModel.resCode isEqualToString:@"VIDEO"]) {
                        [[TYDownloadSessionManager manager]deleteAllFileWithDownloadDirectory:resourceModel.resource];
                    }
                }
                
               
                
                
                [tableView reloadData];
            }
        }];
    }
}

- (void)statisticalDownloadNumber:(NSArray *)resourceArr withCell:(CSCourseDownloadTableViewCell *)cell{
    
    
    NSInteger notDownload = 0,downloading = 0,downloadComplete =0;
    
    for (int  i = 0 ; i<resourceArr.count; i++) {
        CSCourseResourceModel * resourceModel = resourceArr[i];
        if ([resourceModel.resCode isEqualToString:@"VIDEO"]) {
            
            TYDownloadState  state  = [[TYDownloadSessionManager manager]getDownloadState:resourceModel.resource];
            
            if (state ==TYDownloadStateRunning||state ==TYDownloadStateSuspended ) {
                
                ///下载中
                downloading ++;
            }else if (state == TYDownloadStateCompleted){
                ///下载完成
                downloadComplete++;
            }else{
                /// 未下载
                notDownload++;
            }
        }
    }
    cell.notDownload = @(notDownload);
    cell.downloading = @(downloading);
    cell.downloadComplete = @(downloadComplete);
}


@end
