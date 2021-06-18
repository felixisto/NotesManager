//
//  MainPresenter.h
//  NotesManager
//
//  Created by Kristiyan Butev on 16.06.21.
//

#ifndef MainPresenter_h
#define MainPresenter_h

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "TaskViewItem.h"
#import "TaskDataValidator.h"
#import "CategoryDataValidator.h"
#import "TaskExpirationTracker.h"

@protocol SettingsPresenter;
@protocol EditTaskPresenter;
@protocol TaskViewItemParser;
@protocol CategoryViewItemParser;

@protocol MainPresenterDelegate <NSObject>

- (void)reloadData;

- (void)openSettingsScreenWithPresenter:(nonnull id<SettingsPresenter>)presenter;
- (void)openCreateTaskScreenWithPresenter:(nonnull id<EditTaskPresenter>)presenter;
- (void)openEditTaskScreenWithPresenter:(nonnull id<EditTaskPresenter>)presenter;

@end

@protocol MainPresenter <NSObject>

@property (nonatomic, weak, nullable) id<MainPresenterDelegate> delegate;

@property (readonly) NSArray<TaskViewItem*>* allTasks;
@property (readonly) NSArray<TaskViewItem*>* activeTasks;
@property (readonly) NSArray<TaskViewItem*>* inactiveTasks;

- (void)reloadData;

- (void)onSettingsTap;
- (void)onAddTaskTap;
- (void)onTaskTap:(TaskViewItem*)task;
- (void)onTaskDelete:(TaskViewItem*)task;
- (void)onExpireTask:(TaskViewItem*)task;

@end

@interface MainPresenterImpl : NSObject<MainPresenter>

- (nonnull instancetype)init __attribute__((unavailable("Default init unavaiable")));
- (nonnull instancetype)initWithTasksRepo:(nonnull id<TasksRepository>)tasksRepo
                           categoriesRepo:(nonnull id<CategoriesRepository>)categoriesRepo
                           taskItemParser:(nonnull id<TaskViewItemParser>)taskParser
                       categoryItemParser:(nonnull id<CategoryViewItemParser>)categoryParser
                            taskValidator:(nonnull id<TaskDataValidator>)taskValidator
                        categoryValidator:(nonnull id<CategoryDataValidator>)categoryValidator
                    taskExpirationTracker:(nonnull id<TaskExpirationTracker>)taskExpirationTracker;

@end

#endif /* MainPresenter_h */
