//
//  AppDelegate.h
//  tencent
//
//  Created by sunon002 on 16/4/15.
//  Copyright © 2016年 cyh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import "CSBaseNavigationController.h"
@interface AppDelegate : UIResponder <UIApplicationDelegate,UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (nonatomic,assign) NSTimeInterval timeDuration;
+ (AppDelegate *) sharedInstance;

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

//- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;
@end

