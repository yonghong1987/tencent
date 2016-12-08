//
//  CSCoreDataManager.m
//  eLearning
//
//  Created by chenliang on 15-1-15.
//  Copyright (c) 2015年 sunon. All rights reserved.
//

#import "CSCoreDataManager.h"
static CSCoreDataManager *dbManager = nil;
@implementation CSCoreDataManager
+ (CSCoreDataManager *)shareDBManager{
    @synchronized(self){
        if (dbManager==nil) {
            dbManager=[[self alloc] init];
        }
    }
    return dbManager;
}

+(id) allocWithZone:(NSZone *)zone{
    @synchronized(self)
    {
        if (dbManager == nil)
        {
            dbManager = [super allocWithZone:zone];
            return dbManager;
        }
    }
    return nil;
}

- (void)clearMessage{
    self.managedObjectModel=nil;
    self.persistentStoreCoordinator=nil;
    self.managedObjectContext=nil;
}

-(NSManagedObjectContext *)managedObjectContext{
    if (_managedObjectContext!=nil) {
        return _managedObjectContext;
    }
    NSPersistentStoreCoordinator *coordinator=[self persistentStoreCoordinator];
    if (coordinator!=nil) {
        _managedObjectContext=[[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
        [_managedObjectContext setPersistentStoreCoordinator:coordinator];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(mocDidSaveNotification:) name:NSManagedObjectContextDidSaveNotification object:nil];
    }
    return _managedObjectContext;
}

-(NSPersistentStoreCoordinator *)persistentStoreCoordinator{
    if (_persistentStoreCoordinator) {
        return _persistentStoreCoordinator;
    }
    NSString *docs=[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSURL *storeURL=[NSURL fileURLWithPath:[docs stringByAppendingPathComponent:@"CoreData.sqlite"]];
    NSError *error=nil;
    _persistentStoreCoordinator=[[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:self.managedObjectModel];
    NSDictionary *options = [NSDictionary dictionaryWithObjectsAndKeys:
                             [NSNumber numberWithBool:YES], NSMigratePersistentStoresAutomaticallyOption,
                             [NSNumber numberWithBool:YES], NSInferMappingModelAutomaticallyOption,
                             nil];
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:options error:&error]) {
        NSLog(@"Error: %@,%@",error,[error userInfo]);
    }
    return _persistentStoreCoordinator;
}

-(NSManagedObjectModel *)managedObjectModel{
    if (_managedObjectModel) {
        return _managedObjectModel;
    }
    _managedObjectModel=[[NSManagedObjectModel mergedModelFromBundles:nil] copy];
    return _managedObjectModel;
}

- (void)excuteInsertOrUpdateManagedObj:(NSManagedObject *)object{
    if (![self saveObject]) {
         NSLog(@"插入或更新失败");
    }
}

- (void)excuteInsertOrUpdateManagedArray:(NSArray *)array{
    if (![self saveObject]) {
        NSLog(@"插入或更新失败");
    }
}

- (NSArray *)excuteQueryWithEntityName:(NSString *)name
                             predicate:(NSPredicate *)predicate{
    NSError *error;
    NSFetchRequest *fetch=[[NSFetchRequest alloc] initWithEntityName:name];
    [fetch setPredicate:predicate];
    NSArray *array=[self.managedObjectContext executeFetchRequest:fetch error:&error];
    return array;
}

-(void)deleteManagerArray:(NSArray *)array{
    for (NSManagedObject *object in array) {
        [_managedObjectContext deleteObject:object];
    }
    if([self saveObject]){
        NSLog(@"全部删除成功");
    }
}

- (BOOL)deleteManagerObj:(NSManagedObject *)object{
    [_managedObjectContext deleteObject:object];
    if( [self saveObject] ){
        NSLog(@"单个删除成功");
        return YES;
    }
    return NO;
}

-(NSFetchedResultsController *)getFetchedResultsControllerWithEntityName:(NSString *)name sorts:(NSArray *)array predicate:(NSPredicate *)predicate{
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:name];
    [fetchRequest setSortDescriptors:array];
    [fetchRequest setPredicate:predicate];
    NSFetchedResultsController *theFetchedResultsController =
    [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest
                                        managedObjectContext:self.managedObjectContext sectionNameKeyPath:nil
                                                   cacheName:nil];
    return theFetchedResultsController;
}

-(BOOL)saveObject{
    NSError* error;
    BOOL isSaveSuccess=[self.managedObjectContext save:&error];
    if (!isSaveSuccess) {
        NSLog(@"Error:%@",error);
    }
    return isSaveSuccess;
}

#pragma mark-notification
- (void)mocDidSaveNotification:(NSNotification *)notification{
    NSManagedObjectContext *savedContext = [notification object];
    if (self.managedObjectContext == savedContext){
        return;
    }
    
    if (self.managedObjectContext.persistentStoreCoordinator != savedContext.persistentStoreCoordinator)
    {
        return;
    }
    
    dispatch_async(dispatch_get_main_queue(), ^{
       // NSLog(@"befroe run here");
        [self.managedObjectContext mergeChangesFromContextDidSaveNotification:notification];
       // NSLog(@"main here run");
    });
}
@end
