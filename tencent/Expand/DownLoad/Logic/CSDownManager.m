//
//  CSDownManager.m
//  eLearning
//
//  Created by sunon on 14-5-19.
//  Copyright (c) 2014年 sunon. All rights reserved.
//

#import "CSDownManager.h"
#import <CoreData/CoreData.h>
#import "CSCourseResourceModel.h"
#import "CSCoreDataManager.h"
#import "WHC_DownloadFileCenter.h"
#import <UIKit/UIKit.h>
#import "CSImagePath.h"
#import "CSMd5.h"
#import "CSConfig.h"
#import "CSDownLoadResourceModel.h"

@interface CSDownManager()<WHCDownloadDelegate>

@property(nonatomic,strong) NSManagedObjectContext *otherContext;

@end


@implementation CSDownManager
+ (CSDownManager *)sharedManger{
    static CSDownManager *_shareManager = nil;
    @synchronized(self){
        if (!_shareManager) {
            _shareManager=[[CSDownManager alloc] init];
        }
        
    }
    return _shareManager;
}

- (id)init{
    self = [super init];
    if (self) {
        
        [[WHC_DownloadFileCenter sharedWHCDownloadFileCenter] setMaxDownloadCount:10];
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(cancelAllLoading)
                                                     name:UIApplicationWillTerminateNotification
                                                   object:nil];
    }
    return self;
}

//- (void)addObject:(CSResouceModel *)obj{
//        CSHttpClient* client=[CSHttpClient sharedClient];
//        [client downloadFile:obj block:^(NSDictionary* dict,download_type type,float percent){
//            CSResouceModel* downModel=[dict objectForKey:@"DOWN_MODEL"];
//            if (downModel.progress<percent||downModel.download_type!=DOWN_DEFAULT) {
//                downModel.download_type=type;
//                downModel.progress=percent;
//                [self.otherContext performBlock:^{
//                    NSPredicate *predicate=[NSPredicate predicateWithFormat:@"courseId=%d&&modId=%d",downModel.courseId,downModel.modId];
//                    NSFetchRequest *fetch=[[NSFetchRequest alloc] initWithEntityName:@"ResourceDownModel"];
//                    [fetch setPredicate:predicate];
//                    NSArray *array=[self.otherContext executeFetchRequest:fetch error:nil];
//                    if ([array count]>0) {
////                       NSLog(@"percent is %f,download_type is %d",percent,downModel.download_type);
//                        ResourceDownModel *resouceModel=[array objectAtIndex:0];
//                        [resouceModel setProgress:[NSNumber numberWithFloat:percent]];
//                        [resouceModel setDownload_type:[NSNumber numberWithInteger:type]];
////                        [self.otherContext refreshObject:resouceModel mergeChanges:YES];
//                        if (![self.otherContext save:nil]) {
//                            NSLog(@"save error");
//                        }
//                    }
//                }];
//            }
//        }];
//}

//- (void)otherOperate:(CSResouceModel *)obj{
//    CSHttpClient* client=[CSHttpClient sharedClient];
//    if ([client hasOperate:obj]) {
//        [client pauseOperation:obj];
//        [self.otherContext performBlock:^{
////            NSLog(@"=====pause======");
//            NSPredicate *predicate=[NSPredicate predicateWithFormat:@"courseId=%d&&modId=%d",obj.courseId,obj.modId];
//            NSFetchRequest *fetch=[[NSFetchRequest alloc] initWithEntityName:@"ResourceDownModel"];
//            [fetch setPredicate:predicate];
//            NSArray *array=[self.otherContext executeFetchRequest:fetch error:nil];
//            if ([array count]>0) {
//                ResourceDownModel *resouceModel=[array objectAtIndex:0];
//                [resouceModel setDownload_type:[NSNumber numberWithInteger:DOWN_PAUSE]];
//                if (![self.otherContext save:nil]) {
//                    NSLog(@"save error");
//                }
//            }
//        }];
//    }else if([client hasPaused:obj]){
//        [client resumeOperation:obj];
//    }else{
//        [self addObject:obj];
//    }
//}

//- (NSManagedObjectContext *)otherContext{
//    if (_otherContext) {
//        return _otherContext;
//    }
//    DBManager *manager=[DBManager shareDBManager];
//    _otherContext=[[NSManagedObjectContext alloc] initWithConcurrencyType:NSPrivateQueueConcurrencyType];
//    [_otherContext setPersistentStoreCoordinator:manager.persistentStoreCoordinator];
//    _otherContext.stalenessInterval=0.0;
//    _otherContext.mergePolicy=NSMergeByPropertyObjectTrumpMergePolicy;
//    return _otherContext;
//}

#pragma mark-notification
//-(void)cancelAllLoading{
//    [self.otherContext performBlock:^{
//        NSPredicate *predicate=[NSPredicate predicateWithFormat:@"download_type=%d",DOWN_LOADING];
//        NSFetchRequest *fetch=[[NSFetchRequest alloc] initWithEntityName:@"ResourceDownModel"];
//        [fetch setPredicate:predicate];
//        NSArray *array=[self.otherContext executeFetchRequest:fetch error:nil];
//        for (ResourceDownModel *resourceModel in array) {
//            [resourceModel setDownload_type:[NSNumber numberWithInteger:DOWN_PAUSE]];
//                CSResouceModel *obj=[[CSResouceModel alloc] initWithResourceDownModel:resourceModel];
//                [[CSHttpClient sharedClient] pauseOperation:obj];
//        }
//        if (![self.otherContext save:nil]) {
//            NSLog(@"save error");
//        }
//    }];
//}


#pragma mark 初始化
- (NSManagedObjectContext *)otherContext{
    if (_otherContext) {
        return _otherContext;
    }
    CSCoreDataManager *manager = [CSCoreDataManager shareDBManager];
    _otherContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSPrivateQueueConcurrencyType];
    [_otherContext setPersistentStoreCoordinator:manager.persistentStoreCoordinator];
    _otherContext.stalenessInterval = 0.0;
    _otherContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy;
    return _otherContext;

}

/**
 *  下载队列全部暂停
 */
- (void)cancelAllLoading{
    
    [[WHC_DownloadFileCenter sharedWHCDownloadFileCenter] cancelAllDownloadTaskAndDelFile:NO];
    
    [self.otherContext performBlock:^{
        NSPredicate *predicate=[NSPredicate predicateWithFormat:@"download_type=%d",DOWN_LOADING];
        NSFetchRequest *fetch=[[NSFetchRequest alloc] initWithEntityName:@"CSDownLoadResourceModel"];
        [fetch setPredicate:predicate];
        NSArray *array=[self.otherContext executeFetchRequest:fetch error:nil];
        for (CSDownLoadResourceModel *resourceModel in array) {
            [resourceModel setDownload_type:[NSNumber numberWithInteger:DOWN_PAUSE]];
        }
        if (![self.otherContext save:nil]) {
            NSLog(@"save error");
        }
    }];
}

/**
 *  下载
 *
 *  @param model 视频信息
 */
- (void)initDownload:(CSCourseResourceModel *)model{
    
    NSString* tranStr = noEncodeingImageOrVideoUrl(model.resource);
    
    NSString* targetStr = getMd5FileName(tranStr);
    
    NSFileManager* fileManger = [NSFileManager defaultManager];
    NSString *videoPath = [cacheDir stringByAppendingPathComponent:VIDOEDOWNLOADPATH];//temp目录

    if( ![fileManger fileExistsAtPath:videoPath] ){
        [fileManger createDirectoryAtPath:videoPath withIntermediateDirectories:YES attributes:nil error:nil];
    }
    [[WHC_DownloadFileCenter sharedWHCDownloadFileCenter] startDownloadWithURL:[NSURL URLWithString:tranStr]
                                                                      savePath:videoPath
                                                                  savefileName:targetStr
                                                                      delegate:self
                                                                      courseId:[model.courseId integerValue]
                                                                         modId:[model.modId integerValue]
                                                                         resId:[model.resId integerValue]];
}


/**
 *  下载视频的状态更新
 *
 *  @param model 视频信息
 */
- (void)resetDownLoad:(CSCourseResourceModel *)model{
    
    switch ( model.download_type ) {
        case DOWN_LOADING:{
            /**
             *  下载中，程序退出的情况
             */
            WHC_Download *downLoad =  [[WHC_DownloadFileCenter sharedWHCDownloadFileCenter] recoverDownloadWithDownUrl:[NSURL URLWithString:model.resource]
                                                                                                              delegate:self];
            if ( !downLoad ) {
                
                [self initDownload:model];
            }
        }
            break;
        case DOWN_PAUSE:{
            [[WHC_DownloadFileCenter sharedWHCDownloadFileCenter] cancelDownloadWithDownUrl:[NSURL URLWithString:model.resource]
                                                                                    delFile:NO];
        }
            break;
            
        case DOWN_FAIL:{
            WHC_Download *downLoad =  [[WHC_DownloadFileCenter sharedWHCDownloadFileCenter] recoverDownloadWithDownUrl:[NSURL URLWithString:model.resource]
                                                                                                              delegate:self];
            
            
            if ( !downLoad ) {
                [self initDownload:model];
            }
        }
            break;
        case DOWN_DEFAULT:{
            [self initDownload:model];
        }
            break;
            
        default:{
            
        }
            break;
    }
}


#pragma mark 下载代理
//得到第一相应并判断要下载的文件是否已经完整下载了
- (void)WHCDownload:(WHC_Download *)download filePath:(NSString *)filePath hasACompleteDownload:(BOOL)has{
    
}

//接受下载数据处理下载显示进度和网速
- (void)WHCDownload:(WHC_Download *)download didReceivedLen:(uint64_t)receivedLen totalLen:(uint64_t)totalLen networkSpeed:(NSString *)networkSpeed{
    [self refresahUI:download Progress:receivedLen/(float)totalLen DownType:DOWN_LOADING];
}


//下载出错
- (void)WHCDownload:(WHC_Download *)download error:(NSError *)error{
    [self refresahUI:download Progress:0 DownType:DOWN_FAIL];
}

//下载结束
- (void)WHCDownload:(WHC_Download *)download filePath:(NSString *)filePath isSuccess:(BOOL)success{
    
    if( success ){
        [self refresahUI:download Progress:1 DownType:DOWN_SUCCESS];
    }else{
        [self.otherContext performBlock:^{
            
            NSPredicate *predicate=[NSPredicate predicateWithFormat:@"courseId=%d&&modId=%d&&resId=%d",download.courseId,download.modId,download.resId];
            
            NSFetchRequest *fetch=[[NSFetchRequest alloc] initWithEntityName:@"CSDownLoadResourceModel"];
            [fetch setPredicate:predicate];
            NSArray *array=[self.otherContext executeFetchRequest:fetch error:nil];
            
            if( 0 < [array count] ){
                CSDownLoadResourceModel *model = (CSDownLoadResourceModel *)[array objectAtIndex:0];
                [model setDownload_type:[NSNumber numberWithInteger:DOWN_PAUSE]];
                [self.otherContext refreshObject:model mergeChanges:YES];
                if (![self.otherContext save:nil]) {
                    NSLog(@"save error");
                }
            }
        }];
    }
}
//- (void)addObject:(CSResouceModel *)obj{
//        CSHttpClient* client=[CSHttpClient sharedClient];
//        [client downloadFile:obj block:^(NSDictionary* dict,download_type type,float percent){
//            CSResouceModel* downModel=[dict objectForKey:@"DOWN_MODEL"];
//            if (downModel.progress<percent||downModel.download_type!=DOWN_DEFAULT) {
//                downModel.download_type=type;
//                downModel.progress=percent;
//                [self.otherContext performBlock:^{
//                    NSPredicate *predicate=[NSPredicate predicateWithFormat:@"courseId=%d&&modId=%d",downModel.courseId,downModel.modId];
//                    NSFetchRequest *fetch=[[NSFetchRequest alloc] initWithEntityName:@"ResourceDownModel"];
//                    [fetch setPredicate:predicate];
//                    NSArray *array=[self.otherContext executeFetchRequest:fetch error:nil];
//                    if ([array count]>0) {
////                       NSLog(@"percent is %f,download_type is %d",percent,downModel.download_type);
//                        ResourceDownModel *resouceModel=[array objectAtIndex:0];
//                        [resouceModel setProgress:[NSNumber numberWithFloat:percent]];
//                        [resouceModel setDownload_type:[NSNumber numberWithInteger:type]];
////                        [self.otherContext refreshObject:resouceModel mergeChanges:YES];
//                        if (![self.otherContext save:nil]) {
//                            NSLog(@"save error");
//                        }
//                    }
//                }];
//            }
//        }];
//}

/**
 *  刷新界面下载信息
 */
- (void)refresahUI:(WHC_Download *)download Progress:(CGFloat)percent DownType:(DOWN_TYPE)type{
    
    @synchronized( self ) {
        [self.otherContext performBlock:^{
            
            NSPredicate *predicate=[NSPredicate predicateWithFormat:@"courseId=%d&&modId=%d&&resId=%d",download.courseId,download.modId,download.resId];
            
            NSFetchRequest *fetch=[[NSFetchRequest alloc] initWithEntityName:@"CSDownLoadResourceModel"];
            [fetch setPredicate:predicate];
            NSArray *array=[self.otherContext executeFetchRequest:fetch error:nil];
            
            
            if( 0 < [array count] ){
                CSDownLoadResourceModel *model = (CSDownLoadResourceModel *)array[0];
                [model setDownload_type:[NSNumber numberWithInteger:type]];
                if ( type == DOWN_FAIL ) {
                    [self.otherContext refreshObject:model mergeChanges:YES];
                }else{
                    [model setDownLoadProgress:[NSNumber numberWithFloat:percent]];
                    [self.otherContext refreshObject:model mergeChanges:YES];
                }
                
                if (![self.otherContext save:nil]) {
                    NSLog(@"save error");
                }
            }
            
            
        }];
    }
    
    //    NSPredicate *predicate=[NSPredicate predicateWithFormat:@"courseId=%d&&modId=%d",download.courseId,download.modId];
    //    NSFetchRequest *fetch=[[NSFetchRequest alloc] initWithEntityName:@"ResourceDownModel"];
    //    [fetch setPredicate:predicate];
    //    NSArray *array=[self.otherContext executeFetchRequest:fetch error:nil];
    //    if ([array count]>0) {
    //        ResourceDownModel *resouceModel=[array objectAtIndex:0];
    //
    //        [resouceModel setProgress:[NSNumber numberWithFloat:percent]];
    //        [resouceModel setDownload_type:[NSNumber numberWithInteger:type]];
    //        
    //        if (![self.otherContext save:nil]) {
    //            NSLog(@"save error");
    //        }
    //        
    //    }
}
@end
