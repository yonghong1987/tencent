//
//  CSCoreDataManager.h
//  eLearning
//
//  Created by chenliang on 15-1-15.
//  Copyright (c) 2015年 sunon. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@interface CSCoreDataManager : NSObject
@property (nonatomic, strong) NSManagedObjectModel *managedObjectModel;
@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, strong) NSPersistentStoreCoordinator *persistentStoreCoordinator;

+ (CSCoreDataManager *)shareDBManager;

- (void)clearMessage;

/**
 *  插入数据或更新数据
 *
 *  @param object 操作对象
 */
- (void)excuteInsertOrUpdateManagedObj:(NSManagedObject *)object;

/**
 *  插入数据或更新数据
 *
 *  @param array 对象数组
 */

- (void)excuteInsertOrUpdateManagedArray:(NSArray *)array;

/**
 *  查找数据
 *
 *  @param name      实体名字
 *  @param predicate 查询条件
 *
 *  @return 返回查到的数据
 */
- (NSArray *)excuteQueryWithEntityName:(NSString *)name
                             predicate:(NSPredicate *)predicate;
/**
 *  删除数据库中的一组对象
 *
 *  @param array 数组对象，必须是数据库中存在的
 */
-(void)deleteManagerArray:(NSArray *)array;

/**
 *  删除NSManagedObject对象
 *
 *  @param object 要删除的NSManagedObject
 *
 *  @return 删除结果
 */
- (BOOL)deleteManagerObj:(NSManagedObject *)object;

/**
 *  返回NSFetchedResultsController用于表格中
 *
 *  @param name      实体名字
 *  @param array     排序条件
 *  @param predicate 查询条件
 *
 *  @return NSFetchedResultsController
 */
-(NSFetchedResultsController *)getFetchedResultsControllerWithEntityName:(NSString *)name
                                                                   sorts:(NSArray *)array
                                                               predicate:(NSPredicate *)predicate;
@end
