//
//  LocalNotificationManager.m
//  NotesManager
//
//  Created by Kristiyan Butev on 16.06.21.
//

#import "LocalNotificationManager.h"
#import "TaskExpirationTrackerListener.h"
#import "GeneralSettings.h"
#import "UserTask+HELPERS.h"
#import <UserNotifications/UserNotifications.h>
#import <UserNotificationsUI/UserNotificationsUI.h>

#define LocalNotificationManagerTaskTitle @"Notes Manager"

@interface LocalNotificationManagerImpl () <RepositoryDataListener, TaskExpirationTrackerListener, GeneralSettingsListener>

@property (nonatomic, strong) id<TasksRepository> tasksRepo;
@property (nonatomic, strong) id<TaskExpirationTracker> expirationTracker;
@property (nonatomic, strong) UNUserNotificationCenter* center;

@property (nonatomic, assign) BOOL permissionGranted;

@end

@implementation LocalNotificationManagerImpl

- (nonnull instancetype)initWithTasksRepo:(nonnull id<TasksRepository>)tasksRepo
                        expirationTracker:(nonnull id<TaskExpirationTracker>)expirationTracker {
    if (self = [super init]) {
        self.tasksRepo = tasksRepo;
        self.expirationTracker = expirationTracker;
        self.center = [UNUserNotificationCenter currentNotificationCenter];
        self.permissionGranted = false;
        
        [tasksRepo subscribe:self];
        [expirationTracker subscribe:self];
        [[GeneralSettings shared] subscribe:self];
    }
    return self;
}

- (void)dealloc {
    [self.tasksRepo unsubscribe:self];
    [self.expirationTracker unsubscribe:self];
    [[GeneralSettings shared] unsubscribe:self];
}

#pragma mark - Notifications

- (BOOL)notificationsAreEnabled {
    return self.permissionGranted && [[GeneralSettings shared] isNotificationDeliveryOn];
}

- (void)queueNotificationsForAllActiveTasks {
    if (![self notificationsAreEnabled]) {
        return;
    }
    
    NSArray<UserTask*>* tasks = [self.tasksRepo allTasks];
    
    for (UserTask* task in tasks) {
        [self queueNotificationForTask:task];
    }
}

- (NSString*)notificationIDFromTaskName:(nonnull NSString*)name {
    return [NSString stringWithFormat:@"Task.%@", name];
}

- (void)queueNotificationForTask:(nonnull UserTask*)task {
    if (![self notificationsAreEnabled]) {
        return;
    }
    
    if (![task isActive] || !task.notifyOnExpiration) {
        return;
    }
    
    NSString* name = task.name;
    NSTimeInterval expireTime = [task timeUntilExpiration];
    
    if (expireTime <= 0) {
        expireTime = 1;
    }
    
    UNMutableNotificationContent *content = [[UNMutableNotificationContent alloc] init];
    content.title = LocalNotificationManagerTaskTitle;
    content.body = [NSString stringWithFormat:@"%@ expired", name];
    
    UNTimeIntervalNotificationTrigger *trigger = [UNTimeIntervalNotificationTrigger triggerWithTimeInterval:expireTime repeats:NO];
    
    NSString* identifier = [self notificationIDFromTaskName:name];
    UNNotificationRequest *request = [UNNotificationRequest requestWithIdentifier:identifier content:content trigger:trigger];
    
    [self.center addNotificationRequest:request withCompletionHandler:^(NSError * _Nullable error) {}];
    
    NSLog(@"LocalNotificationManagerImpl| Queued local notification for task '%@' in %f sec", name, expireTime);
}

- (void)dequeueAllNotifications {
    NSLog(@"LocalNotificationManagerImpl| Dequeued all pending local notifications");
    
    [self.center removeAllPendingNotificationRequests];
}

- (void)dequeueNotificationForTask:(nonnull NSString*)name removeDelivered:(BOOL)removeDelivered {
    NSLog(@"LocalNotificationManagerImpl| Dequeued local notification for task '%@'", name);
    
    NSString* identifier = [self notificationIDFromTaskName:name];
    [self.center removePendingNotificationRequestsWithIdentifiers:@[identifier]];
    
    if (removeDelivered) {
        [self.center removeDeliveredNotificationsWithIdentifiers:@[identifier]];
    }
}

#pragma mark - LocalNotificationManager

- (void)requestPermissionForNotificationsWithCompletion:(nonnull LocalNotificationManagerCallback)callback {
    UNAuthorizationOptions options = (UNAuthorizationOptionAlert + UNAuthorizationOptionSound);
    
    __weak typeof(self) weakSelf = self;
    
    [self.center requestAuthorizationWithOptions:options completionHandler:^(BOOL granted, NSError* error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (granted) {
                [weakSelf handlePermissionGranted];
            }
            
            callback(granted);
        });
    }];
}

- (void)handlePermissionGranted {
    self.permissionGranted = true;
    [self queueNotificationsForAllActiveTasks];
}

#pragma mark - RepositoryDataListener

- (void)onItemCreate:(NSString*)itemName {
    
}

- (void)onItemDelete:(NSString*)itemName {
    [self dequeueNotificationForTask:itemName removeDelivered:true];
}

- (void)onRepositoryDataChanged {
    [self dequeueAllNotifications];
    [self queueNotificationsForAllActiveTasks];
}

#pragma mark - TaskExpirationTrackerListener

- (void)onTaskExpired:(nonnull NSString*)name {
    [self dequeueNotificationForTask:name removeDelivered:false];
}

#pragma mark - GeneralSettingsListener

- (void)onSettingsChanged {
    [self onRepositoryDataChanged];
}

@end
