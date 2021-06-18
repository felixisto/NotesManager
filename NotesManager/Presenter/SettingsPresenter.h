//
//  SettingsPresenter.h
//  NotesManager
//
//  Created by Kristiyan Butev on 16.06.21.
//

#ifndef SettingsPresenter_h
#define SettingsPresenter_h

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "CategoriesRepository.h"
#import "CategoryViewItem.h"
#import "CategoryViewItemParser.h"

@protocol EditCategoryPresenter;
@protocol CategoryDataValidator;

@protocol SettingsPresenterDelegate <NSObject>

- (void)reloadData;

- (void)openCreateCategoryScreenWithPresenter:(nonnull id<EditCategoryPresenter>)presenter;
- (void)openEditCategoryScreenWithPresenter:(nonnull id<EditCategoryPresenter>)presenter;

@end

@protocol SettingsPresenter <NSObject>

@property (nonatomic, weak, nullable) id<SettingsPresenterDelegate> delegate;

@property (readonly) NSArray<CategoryViewItem*>* data;

- (void)reloadData;

- (void)onAddCategoryTap;
- (void)onCategoryTap:(CategoryViewItem*)category;

- (void)onNotificationsEnabledTap;
- (void)onSortingTap;

@end

@interface SettingsPresenterImpl : NSObject<SettingsPresenter>

- (nonnull instancetype)init __attribute__((unavailable("Use initWithRepo:")));
- (nonnull instancetype)initWithRepo:(nonnull id<CategoriesRepository>)repository
                      categoryParser:(nonnull id<CategoryViewItemParser>)categoryParser
                   categoryValidator:(nonnull id<CategoryDataValidator>)categoryValidator;

@end

#endif /* SettingsPresenter_h */
