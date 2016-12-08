//
//  VedioPlayProgress+CoreDataProperties.h
//  tencent
//
//  Created by cyh on 16/11/30.
//  Copyright © 2016年 cyh. All rights reserved.
//

#import "VedioPlayProgress+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface VedioPlayProgress (CoreDataProperties)

+ (NSFetchRequest<VedioPlayProgress *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSString *resourceUrl;
@property (nonatomic) float playProgress;

@end

NS_ASSUME_NONNULL_END
