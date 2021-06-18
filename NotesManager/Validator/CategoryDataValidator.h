//
//  CategoryDataValidator.h
//  NotesManager
//
//  Created by Kristiyan Butev on 17.06.21.
//

#ifndef CategoryDataValidator_h
#define CategoryDataValidator_h

#import <Foundation/Foundation.h>
#import "CategoriesRepository.h"

@protocol CategoryDataValidator <NSObject>

- (BOOL)isNameTaken:(nonnull NSString*)name;
- (BOOL)isNameValid:(nonnull NSString*)name;

@end

@interface CategoryDataValidatorImpl : NSObject <CategoryDataValidator>

- (nonnull instancetype)init __attribute__((unavailable("Use initWithCategoriesRepo:")));
- (nonnull instancetype)initWithCategoriesRepo:(nonnull id<CategoriesRepository>)categoriesRepo;

@end

#endif /* CategoryDataValidator_h */
