//
//  TaskDataValidator.m
//  NotesManager
//
//  Created by Kristiyan Butev on 17.06.21.
//

#import "TaskDataValidator.h"

#define TASKDATA_NAME_MAX_LENGTH 24

@interface TaskDataValidatorImpl ()

@property (nonatomic, strong) id<TasksRepository> tasksRepo;
@property (nonatomic, strong) id<CategoriesRepository> categoriesRepo;

@end

@implementation TaskDataValidatorImpl

- (nonnull instancetype)initWithTasksRepo:(nonnull id<TasksRepository>)tasksRepo
                           categoriesRepo:(nonnull id<CategoriesRepository>)categoriesRepo {
    if (self = [super init]) {
        self.tasksRepo = tasksRepo;
        self.categoriesRepo = categoriesRepo;
    }
    return self;
}

- (BOOL)isNameTaken:(nonnull NSString*)name {
    return [self.tasksRepo isNameTaken:name];
}

- (BOOL)isNameValid:(nonnull NSString*)name {
    return name.length > 0 && name.length <= TASKDATA_NAME_MAX_LENGTH;
}

- (BOOL)isCategoryValid:(nonnull NSString*)categoryName {
    return [self.categoriesRepo isNameTaken:categoryName];
}

- (BOOL)isExpirationDateValid:(nonnull NSDate*)expiration {
    return [expiration timeIntervalSinceNow] > 0;
}

@end
