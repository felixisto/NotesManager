//
//  EditTaskViewController.h
//  NotesManager
//
//  Created by Kristiyan Butev on 16.06.21.
//

#ifndef EditTaskViewController_h
#define EditTaskViewController_h

#import <UIKit/UIKit.h>
#import "EditTaskPresenter.h"

@interface EditTaskViewController : UIViewController <EditTaskPresenterDelegate>

// Used for editing and not creating tasks. When true, the save button will be moved to the left, and a new expire button will
// be visible on the right side of the navigation bar.
@property (nonatomic, assign) BOOL isExpireButtonVisible;
@property (nonatomic, copy) NSString* navigationTitle;

- (nonnull instancetype)init __attribute__((unavailable("Use buildWithPresenter:")));

@end

@interface EditTaskViewController (BUILD)

+ (nonnull EditTaskViewController*)buildWithPresenter:(nonnull id<EditTaskPresenter>)presenter;

@end

#endif /* EditTaskViewController_h */
