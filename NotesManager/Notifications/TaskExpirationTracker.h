//
//  TaskExpirationTracker.h
//  NotesManager
//
//  Created by Kristiyan Butev on 16.06.21.
//

#ifndef TaskExpirationTracker_h
#define TaskExpirationTracker_h

#import <Foundation/Foundation.h>
#import "TasksRepository.h"
#import "TaskExpirationTrackerListener.h"

@protocol TaskExpirationTracker <NSObject>

// Tracker does not begin operating until this is called.
- (void)start;

- (void)subscribe:(nonnull id<TaskExpirationTrackerListener>)listener;
- (void)unsubscribe:(nonnull id<TaskExpirationTrackerListener>)listener;

@end

@interface TaskExpirationTrackerImpl : NSObject <TaskExpirationTracker>

- (nonnull instancetype)init __attribute__((unavailable("Use initWithTasksRepo:")));
- (nonnull instancetype)initWithTasksRepo:(nonnull id<TasksRepository>)tasksRepo;

@end

#endif /* TaskExpirationTracker_h */
