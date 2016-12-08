//
//  SMUploadImageApi.h
//  sunMobile
//
//  Created by duck on 16/3/22.
//  Copyright © 2016年 www.sunontalent.com. All rights reserved.
//

#import "SMBaseNetworkApi.h"

@interface SMUploadImageApi : SMBaseNetworkApi

/**
 *  上传图片数组
 */
@property (nonatomic ,copy) NSArray<UIImage *> * images;
/**
 *  压缩比例 默认 1
 */
@property (nonatomic ,assign) CGFloat  compressionQuality;
/**
 *  上传图片key
 */
@property (nonatomic ,copy) NSString * fileImageKey;

/**
 *  上传图片
 *
 *  @param success       success
 *  @param failure       failure
 *  @param progressBlock progressBlock
 */
- (void)startWithCompletionBlockWithSuccess:(SMRequestSuccessBlock)success withFailure:(SMRequestFailureBlock)failure withProgressBlock:(ProgressBlock)progressBlock;

/**
 *  带hud进度的 的上传图片
 *
 *  @param success success
 *  @param failure failure
 *  @param toView  progressBlock
 */
- (void)startWithCompletionBlockWithSuccess:(SMRequestSuccessBlock)success withFailure:(SMRequestFailureBlock)failure showHUDToView:(UIView *)toView;
@end
