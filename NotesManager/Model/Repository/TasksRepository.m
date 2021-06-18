//
//  TasksRepository.m
//  NotesManager
//
//  Created by Kristiyan Butev on 16.06.21.
//

#import "TasksRepository.h"

@interface TasksRepositoryImpl ()

@property (strong, nonnull) NSPersistentContainer* container;
@property (strong, nonnull) NSMutableArray<RepositoryDataListenerWeak*>* listeners;

@end

@implementation TasksRepositoryImpl

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

#pragma mark - TasksRepository

- (BOOL)isNameTaken:(nonnull NSString*)name {
    return [self taskByName:name] != nil;
}

- (nullable UserTask*)buildNewTaskWithName:(nonnull NSString*)name {
    if ([self isNameTaken:name]) {
        NSLog(@"TasksRepository| buildNewTaskWithName error: name is already taken");
        return nil;
    }
    
    UserTask* task = [[UserTask alloc] initWithContext:self.mainContext];
    task.name = name;
    
    [self saveContext];
    [self alertListenersOfTaskCreate:name];
    
    return task;
}

- (nullable UserTask*)taskByName:(nonnull NSString*)name {
    NSDictionary* variables = @{@"NAME" : name};
    NSFetchRequest* request = [self.model fetchRequestFromTemplateWithName:@"UserTasksByName" substitutionVariables:variables];
    NSError* error;
    NSArray* result = [self.mainContext executeFetchRequest:request error:&error];
    
    if (error != nil) {
        NSLog(@"TasksRepository| taskByName error: %@, %@", error, error.userInfo);
    }
    
    return [result firstObject];
}

- (nonnull NSArray<UserTask*>*)allTasks {
    NSString* entitityName = NSStringFromClass([UserTask class]);
    NSFetchRequest* request = [NSFetchRequest fetchRequestWithEntityName:entitityName];
    NSError* error;
    NSArray* result = [self.mainContext executeFetchRequest:request error:&error];
    
    if (error != nil) {
        NSLog(@"TasksRepository| allTasks error: %@, %@", error, error.userInfo);
    }
    
    return result ?: [NSArray new];
}

- (nonnull NSArray<UserTask*>*)tasksByCategoryName:(nonnull NSString*)categoryName {
    NSDictionary* variables = @{@"NAME" : categoryName};
    NSFetchRequest* request = [self.model fetchRequestFromTemplateWithName:@"UserTasksByCategoryName" substitutionVariables:variables];
    NSError* error;
    NSArray* result = [self.mainContext executeFetchRequest:request error:&error];
    
    if (error != nil) {
        NSLog(@"TasksRepository| tasksByCategoryName error: %@, %@", error, error.userInfo);
    }
    
    return result ?: [NSArray new];
}

- (void)deleteTaskByName:(nonnull NSString*)name {
    [self.mainContext deleteObject:[self taskByName:name]];
    
    [self saveContext];
    [self alertListenersOfTaskDelete:name];
}

- (void)saveChanges {
    if (!self.container.viewContext.hasChanges) {
        return;
    }
    
    [self saveContext];
    
    [self alertListenersOfDataChanged];
}

#pragma mark - Listeners

- (void)alertListenersOfTaskCreate:(NSString*)taskName {
    for (RepositoryDataListenerWeak* l in [NSArray arrayWithArray:self.listeners]) {
        [l.value onItemCreate:taskName];
    }
}

- (void)alertListenersOfTaskDelete:(NSString*)taskName {
    for (RepositoryDataListenerWeak* l in [NSArray arrayWithArray:self.listeners]) {
        [l.value onItemDelete:taskName];
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
