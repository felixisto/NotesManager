//
//  LocalNotificationManager.h
//  NotesManager
//
//  Created by Kristiyan Butev on 16.06.21.
//

#ifndef LocalNotificationManager_h
#define LocalNotificationManager_h

#import <Foundation/Foundation.h>
#import "TasksRepository.h"
#import "TaskExpirationTracker.h"

typedef void (^LocalNotificationManagerCallback)(BOOL isAllowed);

@protocol LocalNotificationManager <NSObject>

// Completion is always performed on main thread.
- (void)requestPermissionForNotificationsWithCompletion:(nonnull LocalNotificationManagerCallback)callback;

@end

@interface LocalNotificationManagerImpl : NSObject <LocalNotificationManager>

- (nonnull instancetype)init __attribute__((unavailable("Use initWithTaskExpirationTracker:")));
- (nonnull instancetype)initWithTasksRepo:(nonnull id<TasksRepository>)tasksRepo
                        expirationTracker:(nonnull id<TaskExpirationTracker>)expirationTracker;

@end

#endif /* LocalNotificationManager_h */
