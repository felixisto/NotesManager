//
//  TaskDataValidator.h
//  NotesManager
//
//  Created by Kristiyan Butev on 17.06.21.
//

#ifndef TaskDataValidator_h
#define TaskDataValidator_h

#import <Foundation/Foundation.h>
#import "TasksRepository.h"
#import "CategoriesRepository.h"

@protocol TaskDataValidator <NSObject>

- (BOOL)isNameTaken:(nonnull NSString*)name;
- (BOOL)isNameValid:(nonnull NSString*)name;
- (BOOL)isCategoryValid:(nonnull NSString*)categoryName;
- (BOOL)isExpirationDateValid:(nonnull NSDate*)expiration;

@end

@interface TaskDataValidatorImpl : NSObject <TaskDataValidator>

- (nonnull instancetype)init __attribute__((unavailable("Default init unavaiable")));
- (nonnull instancetype)initWithTasksRepo:(nonnull id<TasksRepository>)tasksRepo
                           categoriesRepo:(nonnull id<CategoriesRepository>)categoriesRepo;

@end

#endif /* TaskDataValidator_h */
