//
//  MainPresenter.m
//  NotesManager
//
//  Created by Kristiyan Butev on 16.06.21.
//

#import "MainPresenter.h"
#import "SettingsPresenter.h"
#import "EditTaskPresenter.h"
#import "TaskViewItemParser.h"
#import "GeneralSettings.h"

@interface MainPresenterImpl () <RepositoryDataListener, TaskExpirationTrackerListener, GeneralSettingsListener>

@property (nonatomic, strong) id<TasksRepository> tasksRepo;
@property (nonatomic, strong) id<CategoriesRepository> categoriesRepo;
@property (nonatomic, strong) id<TaskViewItemParser> taskParser;
@property (nonatomic, strong) id<CategoryViewItemParser> categoryParser;
@property (nonatomic, strong) id<TaskDataValidator> taskValidator;
@property (nonatomic, strong) id<CategoryDataValidator> categoryValidator;
@property (nonatomic, strong) id<TaskExpirationTracker> taskExpirationTracker;

@property (nonatomic, strong) NSArray<TaskViewItem*>* allTasks;
@property (nonatomic, strong) NSArray<TaskViewItem*>* activeTasks;
@property (nonatomic, strong) NSArray<TaskViewItem*>* inactiveTasks;

@end

@implementation MainPresenterImpl

@synthesize delegate = _delegate;

- (nonnull instancetype)initWithTasksRepo:(nonnull id<TasksRepository>)tasksRepo
                           categoriesRepo:(nonnull id<CategoriesRepository>)categoriesRepo
                           taskItemParser:(nonnull id<TaskViewItemParser>)taskParser
                       categoryItemParser:(nonnull id<CategoryViewItemParser>)categoryParser
                            taskValidator:(nonnull id<TaskDataValidator>)taskValidator
                        categoryValidator:(nonnull id<CategoryDataValidator>)categoryValidator
                    taskExpirationTracker:(nonnull id<TaskExpirationTracker>)taskExpirationTracker {
    if (self = [super init]) {
        self.tasksRepo = tasksRepo;
        self.categoriesRepo = categoriesRepo;
        self.taskParser = taskParser;
        self.categoryParser = categoryParser;
        self.taskValidator = taskValidator;
        self.categoryValidator = categoryValidator;
        self.taskExpirationTracker = taskExpirationTracker;
        
        self.allTasks = [NSMutableArray new];
        self.activeTasks = [NSMutableArray new];
        self.inactiveTasks = [NSMutableArray new];
        
        [self.tasksRepo subscribe:self];
        [self.taskExpirationTracker subscribe:self];
        [[GeneralSettings shared] subscribe:self];
    }
    return self;
}

- (void)dealloc {
    [self.tasksRepo unsubscribe:self];
    [self.taskExpirationTracker unsubscribe:self];
    [[GeneralSettings shared] unsubscribe:self];
}

- (void)reloadData {
    SettingsSorting sorting = [GeneralSettings shared].tasksSorting;
    
    id sortTasks = ^(UserTask* a, UserTask* b) {
        if (sorting == SettingsSortingAlphabetically) {
            return [a.name compare:b.name];
        }
        if (sorting == SettingsSortingChronologically) {
            return [a.expiration compare:b.expiration];
        }
        return [a.name compare:b.name];
    };
    
    NSArray<UserTask*>* orderedTasks = [[self.tasksRepo allTasks] sortedArrayUsingComparator:sortTasks];
    
    NSMutableArray<TaskViewItem*>* all = [NSMutableArray new];
    NSMutableArray<TaskViewItem*>* active = [NSMutableArray new];
    NSMutableArray<TaskViewItem*>* inactive = [NSMutableArray new];
    
    for (UserTask* task in orderedTasks) {
        TaskViewItem* item = [self.taskParser parse:task];
        
        if (item != nil) {
            [all addObject:item];
            
            if (item.isActive) {
                [active addObject:item];
            } else {
                [inactive addObject:item];
            }
        }
    }
    
    self.allTasks = all;
    self.activeTasks = active;
    self.inactiveTasks = inactive;
    
    [self.delegate reloadData];
}

- (void)onSettingsTap {
    SettingsPresenterImpl* presenter = [[SettingsPresenterImpl alloc] initWithRepo:self.categoriesRepo categoryParser:self.categoryParser categoryValidator:self.categoryValidator];
    [self.delegate openSettingsScreenWithPresenter:presenter];
}

- (void)onAddTaskTap {
    EditTaskPresenterImpl* presenter = [[EditTaskPresenterImpl alloc] initWithTasksRepo:self.tasksRepo categoriesRepo:self.categoriesRepo categoryItemParser:self.categoryParser taskValidator:self.taskValidator];
    [self.delegate openCreateTaskScreenWithPresenter:presenter];
}

- (void)onTaskTap:(TaskViewItem*)task {
    EditTaskPresenterImpl* presenter = [[EditTaskPresenterImpl alloc] initWithTasksRepo:self.tasksRepo categoriesRepo:self.categoriesRepo categoryItemParser:self.categoryParser taskValidator:self.taskValidator];
    presenter.isCreate = false;
    presenter.categoryName = task.categoryName;
    presenter.name = task.name;
    presenter.expiration = task.expiration;
    presenter.notifyOnExpiration = task.notifyOnExpiration;
    [self.delegate openEditTaskScreenWithPresenter:presenter];
}

- (void)onTaskDelete:(TaskViewItem*)task {
    [self.tasksRepo deleteTaskByName:task.name];
}

- (void)onExpireTask:(TaskViewItem*)task {
    UserTask* userTask = [self.tasksRepo taskByName:task.name];
    userTask.isActive = false;
    [self.tasksRepo saveChanges];
}

#pragma mark - RepositoryDataListener

- (void)onItemCreate:(NSString*)itemName {
    
}

- (void)onItemDelete:(NSString*)itemName {
    [self reloadData];
}

- (void)onRepositoryDataChanged {
    [self reloadData];
}

#pragma mark - TaskExpirationTrackerListener

- (void)onTaskExpired:(nonnull NSString*)name {
    [self reloadData];
}

#pragma mark - GeneralSettingsListener

- (void)onSettingsChanged {
    [self reloadData];
}

@end
