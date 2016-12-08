//
//  VideoPlayProgress.h
//  eLearning
//
//  Created by chenliang on 15-2-6.
//  Copyright (c) 2015年 sunon. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface VideoPlayProgress : NSManagedObject

@property (nonatomic, retain) NSNumber * currentTime;
@property (nonatomic, retain) NSNumber * resId;

@end
