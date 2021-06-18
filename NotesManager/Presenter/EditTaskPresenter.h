//
//  EditTaskPresenter.h
//  NotesManager
//
//  Created by Kristiyan Butev on 16.06.21.
//

#ifndef EditTaskPresenter_h
#define EditTaskPresenter_h

#import <Foundation/Foundation.h>
#import "TasksRepository.h"
#import "CategoriesRepository.h"
#import "CategoryViewItem.h"

@protocol CategoryViewItemParser;
@protocol TaskDataValidator;

@protocol EditTaskPresenterDelegate <NSObject>

- (void)showUnknownErrorAlert;
- (void)showNameIsTakenAlert;
- (void)showNameIsInvalidAlert;
- (void)showExpirationDateInvalidAlert;

@end

@protocol EditTaskPresenter <NSObject>

@property (nonatomic, weak, nullable) id<EditTaskPresenterDelegate> delegate;

// Create or edit task?
@property (nonatomic, assign) BOOL isCreate;
@property (nonatomic, copy) NSString* categoryName;
@property (nonatomic, copy) NSString* name;
@property (nonatomic, strong) NSDate* expiration;
@property (nonatomic, assign) BOOL notifyOnExpiration;

@property (readonly) NSArray<CategoryViewItem*>* availableCategories;

// Expires the task being edited. Has no effect if a task is being created.
- (void)expireTask;

// Returns true if successful.
- (BOOL)saveChanges;

@end

@interface EditTaskPresenterImpl : NSObject<EditTaskPresenter>

- (nonnull instancetype)init __attribute__((unavailable("Default init unavaiable")));
- (nonnull instancetype)initWithTasksRepo:(nonnull id<TasksRepository>)tasksRepo
                           categoriesRepo:(nonnull id<CategoriesRepository>)categoriesRepo
                       categoryItemParser:(nonnull id<CategoryViewItemParser>)categoryParser
                            taskValidator:(nonnull id<TaskDataValidator>)taskValidator;

@end

#endif /* EditTaskPresenter_h */
