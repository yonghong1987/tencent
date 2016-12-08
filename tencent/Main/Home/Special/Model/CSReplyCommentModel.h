//
//  CSReplyCommentModel.h
//  tencent
//
//  Created by admin on 16/5/7.
//  Copyright © 2016年 cyh. All rights reserved.
//

#import "CSBaseModel.h"
#import "CSUserModel.h"
@interface CSReplyCommentModel : CSBaseModel
/*
 ***回复者名字
 */
@property (nonatomic, copy) NSString *commentUserName;
/*
 **回复内容
 */
@property (nonatomic, copy) NSString *content;
/*
 **回复时间
 */
@property (nonatomic, copy) NSString *createDate;

@property (nonatomic, strong) CSUserModel *userModel;
@end
