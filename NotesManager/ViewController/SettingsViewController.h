//
//  SettingsViewController.h
//  NotesManager
//
//  Created by Kristiyan Butev on 16.06.21.
//

#ifndef SettingsViewController_h
#define SettingsViewController_h

#import <UIKit/UIKit.h>
#import "SettingsPresenter.h"

@interface SettingsViewController : UIViewController <SettingsPresenterDelegate>

- (nonnull instancetype)init __attribute__((unavailable("Use buildWithPresenter:")));

@end

@interface SettingsViewController (BUILD)

+ (nonnull SettingsViewController*)buildWithPresenter:(nonnull id<SettingsPresenter>)presenter;

@end

#endif /* SettingsViewController_h */
