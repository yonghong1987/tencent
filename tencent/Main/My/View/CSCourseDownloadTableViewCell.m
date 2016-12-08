//
//  CSCourseListTableViewCell.m
//  tencent
//
//  Created by bill on 16/4/27.
//  Copyright © 2016年 cyh. All rights reserved.
//

#import "CSCourseDownloadTableViewCell.h"
#import "UIImageView+AFNetworking.h"
#import "CSDownLoadResourceModel.h"
@interface CSCourseDownloadTableViewCell ()

@property (strong, nonatomic) IBOutlet UIImageView *courseThumbnailImg;

@property (strong, nonatomic) IBOutlet UILabel *courseNameLbl;

@property (strong, nonatomic) IBOutlet UILabel *courseDescriptionLbl;

@property (strong, nonatomic) IBOutlet UILabel *unDownloadCountLbl;

@property (strong, nonatomic) IBOutlet UILabel *downloadingCountLbl;

@property (strong, nonatomic) IBOutlet UILabel *didDownloadCountLbl;

@end

@implementation CSCourseDownloadTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.selectionStyle = UITableViewCellSelectionStyleNone;;
}


- (void)layoutSubviews{
    [super layoutSubviews];
    
    self.courseNameLbl.text = self.courseModel.name;
    [self.courseThumbnailImg setImageWithURL:[NSURL URLWithString: self.courseModel.img]
                        placeholderImage:[UIImage imageNamed:@"default_image"]];
    self.courseDescriptionLbl.text = self.courseModel.describe;
    
    
    _unDownloadCountLbl.text = [NSString stringWithFormat:@"未下载:%@",self.notDownload];
    
    _downloadingCountLbl.text = [NSString stringWithFormat:@"下载中:%@",self.downloading];
    
    _didDownloadCountLbl.text = [NSString stringWithFormat:@"已下载:%@",self.downloadComplete];
}

//- (void)setCourseCell:(CSDownLoadCourseModel *)model{
//    
//    _courseNameLbl.text = model.courseName;
//    
//    _courseDescriptionLbl.text = model.courseDescription;
//    
//    NSInteger unDownload = 0;
//    NSInteger downloading = 0;
//    NSInteger didloading = 0;
//    
//    NSEnumerator *enumerator = [model.resourceship objectEnumerator];
//    CSDownLoadResourceModel *resourceModel = [enumerator nextObject];
//    
//    while ( resourceModel ) {
//        if ( [resourceModel.download_type integerValue] == 3 ) {
//            didloading++;
//        }else{
//            downloading++;
//        }
//        resourceModel = [enumerator nextObject];
//    }
//    unDownload = [model.courseResourceCount integerValue] - didloading - downloading;
//    
//    _unDownloadCountLbl.text = [NSString stringWithFormat:@"未下载:%ld",(long)unDownload];
//    
//    _downloadingCountLbl.text = [NSString stringWithFormat:@"下载中:%ld",(long)downloading];
//    
//    _didDownloadCountLbl.text = [NSString stringWithFormat:@"已下载:%ld",(long)didloading];
//    
//    [_courseThumbnailImg setImageWithURL:[NSURL URLWithString:model.courseImg]
//                        placeholderImage:[UIImage imageNamed:@"default_image"]];
//    
//}
 
@end
