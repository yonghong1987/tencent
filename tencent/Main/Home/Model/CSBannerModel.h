//
//  CSBannerModel.h
//  tencent
//
//  Created by admin on 16/5/21.
//  Copyright © 2016年 cyh. All rights reserved.
//

#import "CSBaseModel.h"

@interface CSBannerModel : CSBaseModel
/**
 *bannerid
 */
@property (nonatomic ,strong) NSNumber *bannerId;
@property (nonatomic ,copy) NSString *name;
@property (nonatomic ,copy) NSString *img;
@property (nonatomic ,copy) NSString *url;
@property (nonatomic, copy) NSString *describe;
@end
