//
//  EditTaskPresenter.m
//  NotesManager
//
//  Created by Kristiyan Butev on 16.06.21.
//

#import "EditTaskPresenter.h"
#import "CategoryViewItemParser.h"
#import "TaskDataValidator.h"

@interface EditTaskPresenterImpl ()

@property (nonatomic, strong) id<TasksRepository> tasksRepo;
@property (nonatomic, strong) id<CategoriesRepository> categoriesRepo;
@property (nonatomic, strong) id<CategoryViewItemParser> categoryParser;
@property (nonatomic, strong) id<TaskDataValidator> taskValidator;

@end

@implementation EditTaskPresenterImpl

@synthesize delegate = _delegate;
@synthesize isCreate = _isCreate;
@synthesize categoryName = _categoryName;
@synthesize name = _name;
@synthesize expiration = _expiration;
@synthesize notifyOnExpiration = _notifyOnExpiration;

- (nonnull instancetype)initWithTasksRepo:(nonnull id<TasksRepository>)tasksRepo
                           categoriesRepo:(nonnull id<CategoriesRepository>)categoriesRepo
                       categoryItemParser:(nonnull id<CategoryViewItemParser>)categoryParser
                            taskValidator:(nonnull id<TaskDataValidator>)taskValidator {
    if (self = [super init]) {
        self.tasksRepo = tasksRepo;
        self.categoriesRepo = categoriesRepo;
        self.categoryParser = categoryParser;
        self.taskValidator = taskValidator;
        
        [self setupDefaultValues];
    }
    return self;
}

- (void)setupDefaultValues {
    self.isCreate = true;
    self.categoryName = [self anyCategory].name;
    self.name = @"MyTask";
    self.expiration = [NSDate dateWithTimeIntervalSinceNow:60];
    self.notifyOnExpiration = true;
}

- (Category*)anyCategory {
    NSArray* categories = [self.categoriesRepo allCategories];
    
    if ([categories count] == 0) {
        NSLog(@"EditTaskPresenterImpl| categories repo is empty, internal logic error");
        abort();
    }
    
    return [categories firstObject];
}

- (NSArray<CategoryViewItem*>*)availableCategories {
    NSMutableArray* categories = [NSMutableArray new];
    
    for (Category* category in [self.categoriesRepo allCategories]) {
        CategoryViewItem* item = [self.categoryParser parse:category];
        
        if (item != nil) {
            [categories addObject:item];
        }
    }
    
    return categories;
}

- (void)expireTask {
    if (self.isCreate) {
        return;
    }
    
    UserTask* task = [self.tasksRepo taskByName:self.name];
    task.isActive = false;
    [self.tasksRepo saveChanges];
}

- (BOOL)saveChanges {
    if (self.isCreate) {
        if ([self.taskValidator isNameTaken:self.name]) {
            [self.delegate showNameIsTakenAlert];
            return false;
        }
        
        if (![self.taskValidator isNameValid:self.name]) {
            [self.delegate showNameIsInvalidAlert];
            return false;
        }
        
        if (![self.taskValidator isExpirationDateValid:self.expiration]) {
            [self.delegate showExpirationDateInvalidAlert];
            return false;
        }
        
        if (![self.taskValidator isCategoryValid:self.categoryName]) {
            [self.delegate showUnknownErrorAlert];
            return false;
        }
        
        UserTask* task = [self.tasksRepo buildNewTaskWithName:self.name];
        task.isActive = true;
        task.category = [self.categoriesRepo categoryByName:self.categoryName];
        task.expiration = self.expiration;
        task.notifyOnExpiration = self.notifyOnExpiration;
    } else {
        // Ignore the expiration date, even if its set to past date, the app will expire the task properly
        
        if (![self.taskValidator isCategoryValid:self.categoryName]) {
            [self.delegate showUnknownErrorAlert];
            return false;
        }
        
        UserTask* task = [self.tasksRepo taskByName:self.name];
        task.isActive = true;
        task.category = [self.categoriesRepo categoryByName:self.categoryName];
        task.expiration = self.expiration;
        task.notifyOnExpiration = self.notifyOnExpiration;
    }
    
    [self.tasksRepo saveChanges];
    
    return true;
}

@end
