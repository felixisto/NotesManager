//
//  TaskExpirationTracker.m
//  NotesManager
//
//  Created by Kristiyan Butev on 16.06.21.
//

#import "TaskExpirationTracker.h"
#import "UserTask+HELPERS.h"

#define TaskExpirationTrackerDelay 5.0

@interface TaskExpirationTrackerImpl () <RepositoryDataListener>

@property (nonatomic, assign) BOOL isActive;

@property (nonatomic, strong) id<TasksRepository> tasksRepo;
@property (strong, nonnull) NSMutableArray<TaskExpirationTrackerListenerWeak*>* listeners;

@property (nonatomic, assign) BOOL skipNextRepoDataChange;

@end

@implementation TaskExpirationTrackerImpl

- (nonnull instancetype)initWithTasksRepo:(nonnull id<TasksRepository>)tasksRepo {
    if (self = [super init]) {
        self.isActive = false;
        self.tasksRepo = tasksRepo;
        self.listeners = [NSMutableArray new];
        self.skipNextRepoDataChange = false;
    }
    return self;
}

- (void)dealloc {
    [self.tasksRepo unsubscribe:self];
}

- (void)start {
    if (self.isActive) {
        return;
    }
    
    self.isActive = true;
    
    [self.tasksRepo subscribe:self];
    
    // Start update loop
    [self updateLoop];
}

#pragma mark - Update

- (void)updateLoop {
    [self update];
    
    __weak typeof(self) weakSelf = self;
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, TaskExpirationTrackerDelay * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
        [weakSelf updateLoop];
    });
}

- (void)update {
    NSArray<UserTask*>* tasks = [self.tasksRepo allTasks];
    NSMutableArray<UserTask*>* expiredTasks = [NSMutableArray new];
    
    for (UserTask* task in tasks) {
        if ([task isActive] && [task isExpirationDateReached]) {
            task.isActive = false;
            [expiredTasks addObject:task];
        }
    }
    
    if ([expiredTasks count] > 0) {
        [self.tasksRepo saveChanges];
    }
    
    for (UserTask* task in expiredTasks) {
        [self alertListenersOfExpiration:task.name];
    }
}

- (void)alertListenersOfExpiration:(nonnull NSString*)taskName {
    for (TaskExpirationTrackerListenerWeak* l in [NSArray arrayWithArray:self.listeners]) {
        [l.value onTaskExpired:taskName];
    }
}

#pragma mark - TaskExpirationTracker

- (void)subscribe:(nonnull id<TaskExpirationTrackerListener>)listener {
    [self unsubscribe:listener];
    
    [self.listeners addObject:[[TaskExpirationTrackerListenerWeak alloc] initWithValue:listener]];
}

- (void)unsubscribe:(nonnull id<TaskExpirationTrackerListener>)listener {
    for (TaskExpirationTrackerListenerWeak* l in [NSArray arrayWithArray:self.listeners]) {
        if (l.value == nil || l.value == listener) {
            [self.listeners removeObject:l];
        }
    }
}

#pragma mark - RepositoryDataListener

- (void)onItemCreate:(NSString*)itemName {
    
}

- (void)onItemDelete:(NSString*)itemName {
    
}

- (void)onRepositoryDataChanged {
    if (self.skipNextRepoDataChange) {
        self.skipNextRepoDataChange = false;
        return;
    }
    
    [self update];
}

@end
