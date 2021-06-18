//
//  CategoriesRepository.m
//  NotesManager
//
//  Created by Kristiyan Butev on 17.06.21.
//

#import "CategoriesRepository.h"
#import <UIKit/UIKit.h>

@interface CategoriesRepositoryImpl ()

@property (strong, nonnull) NSPersistentContainer* container;
@property (strong, nonnull) NSMutableArray<RepositoryDataListenerWeak*>* listeners;

@end

@implementation CategoriesRepositoryImpl

- (nonnull instancetype)initWithContainer:(nonnull NSPersistentContainer*)container {
    if (self = [super init]) {
        self.container = container;
        self.listeners = [NSMutableArray new];
    }
    return self;
}

#pragma mark - Core Data stack

- (nonnull NSManagedObjectContext *)mainContext {
    return self.container.viewContext;
}

- (nonnull NSManagedObjectModel *)model {
    return self.container.managedObjectModel;
}

#pragma mark - Core Data Saving support

- (void)saveContext {
    NSManagedObjectContext *context = self.mainContext;
    NSError *error = nil;
    if ([context hasChanges] && ![context save:&error]) {
        // Replace this implementation with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
        NSLog(@"Unresolved error %@, %@", error, error.userInfo);
        abort();
    }
}

#pragma mark - CategoriesRepository

- (BOOL)isNameTaken:(nonnull NSString*)name {
    return [self categoryByName:name] != nil;
}

- (nullable Category*)buildNewCategoryWithName:(nonnull NSString*)name {
    if ([self isNameTaken:name]) {
        NSLog(@"CategoriesRepository| buildNewCategoryWithName error: name is already taken");
        return nil;
    }
    
    Category* category = [[Category alloc] initWithContext:self.mainContext];
    category.name = name;
    category.color = [UIColor systemRedColor];
    
    [self saveContext];
    [self alertListenersOfCategoryCreate:name];
    
    return category;
}

- (nonnull NSArray<Category*>*)allCategories {
    NSString* entitityName = NSStringFromClass([Category class]);
    NSFetchRequest* request = [NSFetchRequest fetchRequestWithEntityName:entitityName];
    NSError* error;
    NSArray* result = [self.mainContext executeFetchRequest:request error:&error];
    
    if (error != nil) {
        NSLog(@"CategoriesRepository| allCategories error: %@, %@", error, error.userInfo);
    }
    
    return result ?: [NSArray new];
}

- (nullable Category*)categoryByName:(nonnull NSString*)name {
    NSDictionary* variables = @{@"NAME" : name};
    NSFetchRequest* request = [self.model fetchRequestFromTemplateWithName:@"CategoriesByName" substitutionVariables:variables];
    NSError* error;
    NSArray* result = [self.mainContext executeFetchRequest:request error:&error];
    
    if (error != nil) {
        NSLog(@"CategoriesRepository| taskByName error: %@, %@", error, error.userInfo);
    }
    
    return [result firstObject];
}

- (void)saveChanges {
    [self saveContext];
    
    for (RepositoryDataListenerWeak* l in [NSArray arrayWithArray:self.listeners]) {
        [l.value onRepositoryDataChanged];
    }
}

#pragma mark - Listeners

- (void)alertListenersOfCategoryCreate:(NSString*)taskName {
    for (RepositoryDataListenerWeak* l in [NSArray arrayWithArray:self.listeners]) {
        [l.value onItemCreate:taskName];
    }
}

- (void)alertListenersOfDataChanged {
    for (RepositoryDataListenerWeak* l in [NSArray arrayWithArray:self.listeners]) {
        [l.value onRepositoryDataChanged];
    }
}

- (void)subscribe:(nonnull id<RepositoryDataListener>)listener {
    [self unsubscribe:listener];
    
    [self.listeners addObject:[[RepositoryDataListenerWeak alloc] initWithValue:listener]];
    
    [listener onRepositoryDataChanged];
}

- (void)unsubscribe:(nonnull id<RepositoryDataListener>)listener {
    for (RepositoryDataListenerWeak* l in [NSArray arrayWithArray:self.listeners]) {
        if (l.value == nil || l.value == listener) {
            [self.listeners removeObject:l];
        }
    }
}

@end
