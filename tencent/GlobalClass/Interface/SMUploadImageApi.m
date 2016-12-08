//
//  SMUploadImageApi.m
//  sunMobile
//
//  Created by duck on 16/3/22.
//  Copyright © 2016年 www.sunontalent.com. All rights reserved.
//

#import "SMUploadImageApi.h"
#import "NSString+Hash.h"
NSString *const upImageType = @"image/jpg/png/jpeg";
#import "MBProgressHUD+SMHUD.h"
@interface SMUploadImageApi ()
@property (nonatomic ,strong)AFHTTPRequestOperationManager * manager;


@property (nonatomic ,assign) long long totalRead;
@property (nonatomic ,strong) NSString * speed;
@property (nonatomic ,strong) NSDate * date;


@end

@implementation SMUploadImageApi

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.compressionQuality = 1.0;
    }
    return self;
}
+ (instancetype)new{
    return [[SMUploadImageApi alloc]init];
}


- (AFConstructingBlock)constructingBodyBlock{
    
    if (self.images.count) {
        AFConstructingBlock blcok = ^(id<AFMultipartFormData> formData){
            
            for (UIImage * image in self.images) {
                NSData *data = UIImageJPEGRepresentation(image, self.compressionQuality);
                NSString * randomStr = [[@(arc4random())stringValue]md5String];
                NSString * fileName = [NSString stringWithFormat:@"%@.png",randomStr];
                [formData appendPartWithFileData:data name:self.fileImageKey fileName:fileName mimeType:upImageType];
            }
        };
        return blcok;
    }
    return nil;
}


- (void)startWithCompletionBlockWithSuccess:(SMRequestSuccessBlock)success withFailure:(SMRequestFailureBlock)failure showHUDToView:(UIView *)toView{
    
    MBProgressHUD * hud = [MBProgressHUD showToView:toView title:NSLocalizedString(@"", nil) details:nil];
    [super startWithCompletionBlockWithSuccess:success withFailure:failure];
    self.progressBlock = ^(NSUInteger bytesWritten, long long totalBytesWritten, long long totalBytesExpectedToWrite,CGFloat percent){
        if (percent<1) {
            hud.detailsLabel.text  =[NSString stringWithFormat:@"(%.2f%%）",percent*100];
        }else{
            hud.detailsLabel.text = nil;
            hud.label.text = NSLocalizedString(@"", nil);
        }
    };
}

- (void)startWithCompletionBlockWithSuccess:(SMRequestSuccessBlock)success withFailure:(SMRequestFailureBlock)failure withProgressBlock:(ProgressBlock)progressBlock{
   
    self.progressBlock = progressBlock;
    [super startWithCompletionBlockWithSuccess:success withFailure:failure];
}

- (NSString*)formatByteCount:(long long)size
{
    return [NSByteCountFormatter stringFromByteCount:size countStyle:NSByteCountFormatterCountStyleFile];
}
@end
    
         
         
         
