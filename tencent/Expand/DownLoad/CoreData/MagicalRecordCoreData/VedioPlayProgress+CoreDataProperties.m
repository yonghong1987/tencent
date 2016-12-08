//
//  VedioPlayProgress+CoreDataProperties.m
//  tencent
//
//  Created by cyh on 16/11/30.
//  Copyright © 2016年 cyh. All rights reserved.
//

#import "VedioPlayProgress+CoreDataProperties.h"

@implementation VedioPlayProgress (CoreDataProperties)

+ (NSFetchRequest<VedioPlayProgress *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"VedioPlayProgress"];
}

@dynamic resourceUrl;
@dynamic playProgress;

@end
