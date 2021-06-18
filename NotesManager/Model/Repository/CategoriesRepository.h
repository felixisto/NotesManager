//
//  CategoriesRepository.h
//  NotesManager
//
//  Created by Kristiyan Butev on 17.06.21.
//

#ifndef CategoriesRepository_h
#define CategoriesRepository_h

#import <CoreData/CoreData.h>
#import "CoreDataStorage.h"
#import "RepositoryDataListener.h"

@protocol CategoriesRepository <NSObject>

- (BOOL)isNameTaken:(nonnull NSString*)name;

// Changes are saved automatically.
- (nullable Category*)buildNewCategoryWithName:(nonnull NSString*)name;

- (nonnull NSArray<Category*>*)allCategories;
- (nullable Category*)categoryByName:(nonnull NSString*)name;

- (void)saveChanges;

- (void)subscribe:(nonnull id<RepositoryDataListener>)listener;
- (void)unsubscribe:(nonnull id<RepositoryDataListener>)listener;

@end

/*
 * Note: Not thread safe. Should be used on main thread only.
 */
@interface CategoriesRepositoryImpl : NSObject <CategoriesRepository>

@property (readonly, nonnull) NSPersistentContainer* container;
@property (readonly, nonnull) NSManagedObjectContext* mainContext;
@property (readonly, nonnull) NSManagedObjectModel* model;

- (nonnull instancetype)init __attribute__((unavailable("Use initWithContainer:")));
- (nonnull instancetype)initWithContainer:(nonnull NSPersistentContainer*)container;

- (void)saveContext;

@end

#endif /* CategoriesRepository_h */
