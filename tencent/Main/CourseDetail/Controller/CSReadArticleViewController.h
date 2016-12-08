//
//  CSReadArticleViewController.h
//  tencent
//
//  Created by bill on 16/5/9.
//  Copyright © 2016年 cyh. All rights reserved.
//

#import "CSBaseViewController.h"

@interface CSReadArticleViewController : CSBaseViewController

/**
 *  资源Id
 */
@property (nonatomic, strong) NSNumber *resourceId;

/**
 *  资源标题
 */
@property (nonatomic, strong) NSString *resourceTitle;

/**
 *  资源内容
 */
@property (nonatomic, strong) NSString *resourceContent;

@end
