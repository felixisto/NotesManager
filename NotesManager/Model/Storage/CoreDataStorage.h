//
//  CoreDataStorage.h
//  NotesManager
//
//  Created by Kristiyan Butev on 17.06.21.
//

#ifndef CoreDataStorage_h
#define CoreDataStorage_h

#import <CoreData/CoreData.h>
#import "UserTask+CoreDataClass.h"
#import "Category+CoreDataClass.h"

@interface CoreDataStorage : NSObject

@property (readonly, strong, nonnull) NSPersistentContainer *persistentContainer;
@property (readonly, nonnull) NSManagedObjectContext* mainContext;
@property (readonly, nonnull) NSManagedObjectModel* model;

@end

#endif /* CoreDataStorage_h */
