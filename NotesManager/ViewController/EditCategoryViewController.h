//
//  EditCategoryViewController.h
//  NotesManager
//
//  Created by Kristiyan Butev on 16.06.21.
//

#ifndef EditCategoryViewController_h
#define EditCategoryViewController_h

#import <UIKit/UIKit.h>
#import "EditCategoryPresenter.h"

@interface EditCategoryViewController : UIViewController <EditCategoryPresenterDelegate>

@property (nonatomic, copy) NSString* navigationTitle;

- (nonnull instancetype)init __attribute__((unavailable("Use buildWithPresenter:")));

@end

@interface EditCategoryViewController (BUILD)

+ (nonnull EditCategoryViewController*)buildWithPresenter:(nonnull id<EditCategoryPresenter>)presenter;

@end

#endif /* EditCategoryViewController_h */
