//
//  EditCategoryPresenter.m
//  NotesManager
//
//  Created by Kristiyan Butev on 16.06.21.
//

#import "EditCategoryPresenter.h"
#import "CategoryDataValidator.h"

@interface EditCategoryPresenterImpl ()

@property (nonatomic, strong) id<CategoriesRepository> categoriesRepo;
@property (nonatomic, strong) id<CategoryDataValidator> categoryValidator;

@end

@implementation EditCategoryPresenterImpl

@synthesize delegate = _delegate;
@synthesize isCreate = _isCreate;
@synthesize name = _name;
@synthesize color = _color;

- (nonnull instancetype)initWithRepo:(nonnull id<CategoriesRepository>)repository
                   categoryValidator:(nonnull id<CategoryDataValidator>)categoryValidator {
    if (self = [super init]) {
        self.categoriesRepo = repository;
        self.categoryValidator = categoryValidator;
        
        [self setupDefaultValues];
    }
    return self;
}

- (void)setupDefaultValues {
    self.isCreate = true;
    self.name = @"MyCategory";
    self.color = [UIColor systemRedColor];
}

- (BOOL)saveChanges {
    if (self.isCreate) {
        if ([self.categoryValidator isNameTaken:self.name]) {
            [self.delegate showNameIsTakenAlert];
            return false;
        }
        
        if (![self.categoryValidator isNameValid:self.name]) {
            [self.delegate showNameIsInvalidAlert];
            return false;
        }
        
        Category* category = [self.categoriesRepo buildNewCategoryWithName:self.name];
        category.color = self.color;
    } else {
        Category* category = [self.categoriesRepo categoryByName:self.name];
        category.color = self.color;
    }
    
    [self.categoriesRepo saveChanges];
    
    return true;
}

@end
