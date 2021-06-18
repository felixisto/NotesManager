//
//  CategoryDataValidator.m
//  NotesManager
//
//  Created by Kristiyan Butev on 17.06.21.
//

#import "CategoryDataValidator.h"

#define CATEGORYDATA_NAME_MAX_LENGTH 24

@interface CategoryDataValidatorImpl ()

@property (nonatomic, strong) id<CategoriesRepository> categoriesRepo;

@end

@implementation CategoryDataValidatorImpl

- (nonnull instancetype)initWithCategoriesRepo:(nonnull id<CategoriesRepository>)categoriesRepo {
    if (self = [super init]) {
        self.categoriesRepo = categoriesRepo;
    }
    return self;
}

- (BOOL)isNameTaken:(nonnull NSString*)name {
    return [self.categoriesRepo isNameTaken:name];
}

- (BOOL)isNameValid:(nonnull NSString*)name {
    return name.length > 0 && name.length <= CATEGORYDATA_NAME_MAX_LENGTH;
}

@end
