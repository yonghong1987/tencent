//
//  WHC_Download.h
//  PhoneBookBag
//


#import <Foundation/Foundation.h>
#define kWHC_DownloadDidCompleteNotification (@"WHCDownloadDidCompleteNotification")
@class WHC_Download;

typedef enum:NSInteger{
    FreeDiskSpaceLack,      //磁盘空间不足错误
    GeneralErrorInfo,       //一般错误信息
    NetWorkErrorInfo        //网络工作错误
}WHCDownloadErrorType;

@protocol WHCDownloadDelegate <NSObject>
@optional
//得到第一相应并判断要下载的文件是否已经完整下载了
- (void)WHCDownload:(WHC_Download *)download filePath:(NSString *)filePath hasACompleteDownload:(BOOL)has;

//接受下载数据处理下载显示进度和网速
- (void)WHCDownload:(WHC_Download *)download didReceivedLen:(uint64_t)receivedLen totalLen:(uint64_t)totalLen networkSpeed:(NSString *)networkSpeed;

//下载出错
- (void)WHCDownload:(WHC_Download *)download error:(NSError *)error;

//下载结束
- (void)WHCDownload:(WHC_Download *)download filePath:(NSString *)filePath isSuccess:(BOOL)success;

@end

@interface WHC_Download : NSOperation

@property (nonatomic , weak) id <WHCDownloadDelegate>delegate;

/**
 *  文件名保存路径
 */
@property (nonatomic , retain) NSString       *   saveFilePath;

/**
 *  文件保存名
 */
@property (nonatomic , retain) NSString       *   saveFileName;

/**
 *  下载地址
 */
@property (nonatomic , retain) NSURL          *   downUrl;

/**
 *  文件下载路径
 */
@property (nonatomic , retain , readonly)NSString       *   downPath;

/**
 *  下载是否完成
 */
@property (nonatomic , assign , readonly)BOOL               downloadComplete;

/**
 *  是否正在下载
 */
@property (nonatomic , assign , readonly)BOOL               downloading;

/**
 *  下载实际长度
 */
@property (nonatomic , assign , readonly)uint64_t           downloadLen;

/**
 *  文件实际总长度
 */
@property (nonatomic , assign , readonly)uint64_t           totalLen;

/**
 *  资源Id
 */
@property (nonatomic, assign) NSInteger resId;

/**
 * 课程id
 */
@property (nonatomic, assign) NSInteger courseId;
/**
 *模块id
 */
@property (nonatomic, assign) NSInteger modId;


/**
 *  取消下载是否删除已下载的文件
 *
 *  @param isDel 是否要取消
 */
- (void)cancelDownloadTaskAndDelFile:(BOOL)isDel;

/**
 *  添加依赖下载队列
 *
 *  @param download 下载实体
 */
- (void)addDependOnDownload:(WHC_Download *)download;

@end
