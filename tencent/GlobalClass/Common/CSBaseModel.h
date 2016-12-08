//
//  CSBaseModel.h
//  tencent
//
//  Created by admin on 16/5/20.
//  Copyright © 2016年 cyh. All rights reserved.
//

//#import <JSONModel/JSONModel.h>
#import "JSONModel.h"
@interface CSBaseModel : JSONModel


/**
 *  拼接 imageUrl
 *
 *  @param string 图片url
 *
 *  @return 完成路径
 */
- (NSString *)stringWithJoining:(NSString *)string;
@end
