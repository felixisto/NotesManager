//
//  AppDelegate.m
//  NotesManager
//
//  Created by Kristiyan Butev on 16.06.21.
//

#import "AppDelegate.h"
#import "MainViewController.h"
#import "TasksRepository.h"
#import "CategoriesRepository.h"
#import "TaskViewItemParser.h"
#import "CategoryViewItemParser.h"
#import "GeneralSettings.h"
#import "TaskExpirationTracker.h"
#import "LocalNotificationManager.h"

@interface AppDelegate ()

@property (strong, nonatomic) UIWindow* primaryWindow;
@property (strong, nonatomic) CoreDataStorage* coreDataStorage;

@property (nonatomic, strong) id<LocalNotificationManager> localNotificationManager;

@property (strong, nonatomic) id<TasksRepository> tasksRepo;
@property (strong, nonatomic) id<CategoriesRepository> categoriesRepo;
@property (nonatomic, strong) id<TaskViewItemParser> taskParser;
@property (nonatomic, strong) id<CategoryViewItemParser> categoryParser;
@property (nonatomic, strong) id<TaskDataValidator> taskValidator;
@property (nonatomic, strong) id<CategoryDataValidator> categoryValidator;
@property (nonatomic, strong) id<TaskExpirationTracker> taskExpirationTracker;

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [GeneralSettings shared];
    
    // Components
    [self initComponents];
    
    // First launch setup
    if ([[GeneralSettings shared] isFirstLaunch]) {
        [self setupFirstLaunch];
    }
    
    // Splash screen setup (inital screen)
    [self setupLaunch];
    
    // Ask for notifications permission
    [self.localNotificationManager requestPermissionForNotificationsWithCompletion:^(BOOL isAllowed) {
        // Root screen setup
        [self setupRootViewController];
    }];
    
    return YES;
}

#pragma mark - Launch

- (void)setupLaunch {
    // UI
    self.primaryWindow = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.primaryWindow.rootViewController = [self splashScreen];
    [self.primaryWindow makeKeyAndVisible];
}

- (void)setupRootViewController {
    // Start tracker
    [self.taskExpirationTracker start];
    
    // UI
    self.primaryWindow.rootViewController = [self rootScreen];
}

- (UIViewController*)splashScreen {
    UIStoryboard* storyboard = [UIStoryboard storyboardWithName:@"LaunchScreen" bundle:[NSBundle mainBundle]];
    return [storyboard instantiateInitialViewController];
}

- (UIViewController*)rootScreen {
    UINavigationController* navigation = [UINavigationController new];
    MainPresenterImpl* presenter = [[MainPresenterImpl alloc] initWithTasksRepo:self.tasksRepo
                                                                 categoriesRepo:self.categoriesRepo
                                                                 taskItemParser:self.taskParser
                                                             categoryItemParser:self.categoryParser
                                                                  taskValidator:self.taskValidator
                                                              categoryValidator:self.categoryValidator
                                                          taskExpirationTracker:self.taskExpirationTracker];
    MainViewController* vc = [MainViewController buildWithPresenter:presenter];
    presenter.delegate = vc;
    [presenter reloadData];
    [navigation pushViewController:vc animated:false];
    return navigation;
}

- (void)initComponents {
    self.coreDataStorage = [CoreDataStorage new];
    
    self.tasksRepo = [[TasksRepositoryImpl alloc] initWithContainer:self.coreDataStorage.persistentContainer];
    self.categoriesRepo = [[CategoriesRepositoryImpl alloc] initWithContainer:self.coreDataStorage.persistentContainer];
    self.taskParser = [TaskViewItemStandardParser new];
    self.categoryParser = [CategoryViewItemStandardParser new];
    self.taskValidator = [[TaskDataValidatorImpl alloc] initWithTasksRepo:self.tasksRepo categoriesRepo:self.categoriesRepo];
    self.categoryValidator = [[CategoryDataValidatorImpl alloc] initWithCategoriesRepo:self.categoriesRepo];
    self.taskExpirationTracker = [[TaskExpirationTrackerImpl alloc] initWithTasksRepo:self.tasksRepo];
    self.localNotificationManager = [[LocalNotificationManagerImpl alloc] initWithTasksRepo:self.tasksRepo expirationTracker:self.taskExpirationTracker];
}

- (void)setupFirstLaunch {
    Category* category1 = [self.categoriesRepo buildNewCategoryWithName:@"Work"];
    category1.color = [UIColor systemRedColor];
    Category* category2 = [self.categoriesRepo buildNewCategoryWithName:@"Entertainment"];
    category2.color = [UIColor systemBlueColor];
    Category* category3 = [self.categoriesRepo buildNewCategoryWithName:@"Appointment"];
    category3.color = [UIColor systemYellowColor];
    Category* category4 = [self.categoriesRepo buildNewCategoryWithName:@"Misc"];
    category4.color = [UIColor systemGreenColor];
    
    [self.categoriesRepo saveChanges];
}

@end
