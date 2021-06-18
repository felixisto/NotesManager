//
//  EditCategoryPresenter.h
//  NotesManager
//
//  Created by Kristiyan Butev on 16.06.21.
//

#ifndef EditCategoryPresenter_h
#define EditCategoryPresenter_h

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "CategoriesRepository.h"

@protocol CategoryDataValidator;

@protocol EditCategoryPresenterDelegate <NSObject>

- (void)showUnknownErrorAlert;
- (void)showNameIsTakenAlert;
- (void)showNameIsInvalidAlert;

@end

@protocol EditCategoryPresenter <NSObject>

@property (nonatomic, weak, nullable) id<EditCategoryPresenterDelegate> delegate;

// Create or edit category?
@property (nonatomic, assign) BOOL isCreate;
@property (nonatomic, copy) NSString* name;
@property (nonatomic, copy) UIColor* color;

// Returns true if successful.
- (BOOL)saveChanges;

@end

@interface EditCategoryPresenterImpl : NSObject<EditCategoryPresenter>

- (nonnull instancetype)init __attribute__((unavailable("Default init unavaiable")));
- (nonnull instancetype)initWithRepo:(nonnull id<CategoriesRepository>)repository
                   categoryValidator:(nonnull id<CategoryDataValidator>)categoryValidator;

@end

#endif /* EditCategoryPresenter_h */
