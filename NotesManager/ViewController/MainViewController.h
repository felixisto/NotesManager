//
//  MainViewController.h
//  NotesManager
//
//  Created by Kristiyan Butev on 16.06.21.
//

#ifndef MainViewController_h
#define MainViewController_h

#import <UIKit/UIKit.h>
#import "MainPresenter.h"

@interface MainViewController : UIViewController <MainPresenterDelegate>

- (nonnull instancetype)init __attribute__((unavailable("Use buildWithPresenter:")));

@end

@interface MainViewController (BUILD)

+ (nonnull MainViewController*)buildWithPresenter:(nonnull id<MainPresenter>)presenter;

@end

#endif /* MainViewController_h */
