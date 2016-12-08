//
//  CSCourseResourceModel.m
//  tencent
//
//  Created by bill on 16/5/3.
//  Copyright © 2016年 cyh. All rights reserved.
//

#import "CSCourseResourceModel.h"
#import "CSImagePath.h"
#import "NSDictionary+convenience.h"

@implementation CSCourseResourceModel

- (id)initWithDictionary:(NSDictionary *)dict error:(NSError *__autoreleasing *)err{
    self = [super initWithDictionary:dict error:err];
    if ( self ) {
        if (self.rsUrl.length) {
            self.resource = self.rsUrl;
        }else{
            self.resource = [CSImagePath noEncodeingImageUrl:dict[@"resource"]];
        }
        
    }
    return self;
}

- (id)initWithDownLoadResourceModel:(CSDownLoadResourceModel *)downResourceModel{

    self = [super init];
    if ( self ) {
         _resCode = downResourceModel.resCode;
        _resId = downResourceModel.resourceId;
        _resName = downResourceModel.resName;
        _describe = downResourceModel.resourceDescription;
        _resourceContent = downResourceModel.resourceContent;
        _resource = downResourceModel.resource;
        _rsUrl = downResourceModel.resourceUrl;
        _endDate = downResourceModel.endDate;
        _startDate = downResourceModel.startDate;
        _downLoadProgress = downResourceModel.downLoadProgress;
        _allowDown = [NSNumber numberWithInteger:1];
        _download_type = [downResourceModel.download_type integerValue];
    }
    
    return self;

}

@end
