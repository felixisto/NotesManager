//
//  SettingsView.h
//  NotesManager
//
//  Created by Kristiyan Butev on 16.06.21.
//

#ifndef SettingsView_h
#define SettingsView_h

#import <UIKit/UIKit.h>

@interface SettingsView : UIView

@property (weak, nonatomic) IBOutlet UIButton *sortingButton;
@property (weak, nonatomic) IBOutlet UIButton *notificationsEnabledButton;
@property (weak, nonatomic) IBOutlet UITableView *categoriesTable;

@end

#endif /* SettingsView_h */
