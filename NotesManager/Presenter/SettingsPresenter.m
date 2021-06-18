//
//  SettingsPresenter.m
//  NotesManager
//
//  Created by Kristiyan Butev on 16.06.21.
//

#import "SettingsPresenter.h"
#import "EditCategoryPresenter.h"
#import "GeneralSettings.h"

@interface SettingsPresenterImpl () <RepositoryDataListener>

@property (nonatomic, strong) id<CategoriesRepository> categoriesRepo;
@property (nonatomic, strong) id<CategoryViewItemParser> categoryParser;
@property (nonatomic, strong) id<CategoryDataValidator> categoryValidator;

@property (nonatomic, strong) NSArray<CategoryViewItem*>* data;

@end

@implementation SettingsPresenterImpl

@synthesize delegate = _delegate;

- (nonnull instancetype)initWithRepo:(nonnull id<CategoriesRepository>)repository
                      categoryParser:(nonnull id<CategoryViewItemParser>)categoryParser
                   categoryValidator:(nonnull id<CategoryDataValidator>)categoryValidator {
    if (self = [super init]) {
        self.categoriesRepo = repository;
        self.categoryParser = categoryParser;
        self.categoryValidator = categoryValidator;
        
        [self.categoriesRepo subscribe:self];
    }
    return self;
}

- (void)dealloc {
    [self.categoriesRepo unsubscribe:self];
}

- (void)reloadData {
    NSArray<Category*>* categories = [self.categoriesRepo allCategories];
    NSMutableArray<CategoryViewItem*>* items = [NSMutableArray new];
    
    for (Category* category in categories) {
        CategoryViewItem* item = [self.categoryParser parse:category];
        
        if (item != nil) {
            [items addObject:item];
        }
    }
    
    self.data = items;
    
    [self.delegate reloadData];
}

- (void)onAddCategoryTap {
    EditCategoryPresenterImpl* presenter = [[EditCategoryPresenterImpl alloc] initWithRepo:self.categoriesRepo categoryValidator:self.categoryValidator];
    [self.delegate openCreateCategoryScreenWithPresenter:presenter];
}

- (void)onCategoryTap:(CategoryViewItem*)category {
    EditCategoryPresenterImpl* presenter = [[EditCategoryPresenterImpl alloc] initWithRepo:self.categoriesRepo categoryValidator:self.categoryValidator];
    presenter.isCreate = false;
    presenter.name = category.name;
    presenter.color = category.color;
    [self.delegate openEditCategoryScreenWithPresenter:presenter];
}

- (void)onNotificationsEnabledTap {
    GeneralSettings* settings = [GeneralSettings shared];
    settings.isNotificationDeliveryOn = !settings.isNotificationDeliveryOn;
}

- (void)onSortingTap {
    GeneralSettings* settings = [GeneralSettings shared];
    
    if (settings.tasksSorting == SettingsSortingChronologically) {
        settings.tasksSorting = SettingsSortingAlphabetically;
    } else {
        settings.tasksSorting = SettingsSortingChronologically;
    }
}

#pragma mark - RepositoryDataListener

- (void)onItemCreate:(NSString*)itemName {
    
}

- (void)onItemDelete:(NSString*)itemName {
    
}

- (void)onRepositoryDataChanged {
    [self reloadData];
}

@end
