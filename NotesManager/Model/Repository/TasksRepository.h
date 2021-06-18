//
//  TasksRepository.h
//  NotesManager
//
//  Created by Kristiyan Butev on 16.06.21.
//

#ifndef TasksRepository_h
#define TasksRepository_h

#import <CoreData/CoreData.h>
#import "CoreDataStorage.h"
#import "RepositoryDataListener.h"

@protocol TasksRepository <NSObject>

- (BOOL)isNameTaken:(nonnull NSString*)name;
- (nullable UserTask*)buildNewTaskWithName:(nonnull NSString*)name;
- (nullable UserTask*)taskByName:(nonnull NSString*)name;
- (nonnull NSArray<UserTask*>*)allTasks;
- (nonnull NSArray<UserTask*>*)tasksByCategoryName:(nonnull NSString*)categoryName;
- (void)deleteTaskByName:(nonnull NSString*)name;

- (void)saveChanges;

- (void)subscribe:(nonnull id<RepositoryDataListener>)listener;
- (void)unsubscribe:(nonnull id<RepositoryDataListener>)listener;

@end

/*
 * Note: Not thread safe. Should be used on main thread only.
 */
@interface TasksRepositoryImpl : NSObject <TasksRepository>

@property (readonly, nonnull) NSPersistentContainer* container;
@property (readonly, nonnull) NSManagedObjectContext* mainContext;
@property (readonly, nonnull) NSManagedObjectModel* model;

- (nonnull instancetype)init __attribute__((unavailable("Use initWithContainer:")));
- (nonnull instancetype)initWithContainer:(nonnull NSPersistentContainer*)container;

- (void)saveContext;

@end

#endif /* TasksRepository_h */
