//
//  EditTaskView.h
//  NotesManager
//
//  Created by Kristiyan Butev on 16.06.21.
//

#ifndef EditTaskView_h
#define EditTaskView_h

#import <UIKit/UIKit.h>

@interface EditTaskView : UIView

@property (weak, nonatomic) IBOutlet UIPickerView *categoriesPicker;
@property (weak, nonatomic) IBOutlet UITextField *nameTextField;
@property (weak, nonatomic) IBOutlet UIDatePicker *datePicker;
@property (weak, nonatomic) IBOutlet UISwitch *notificationSwitch;

@end

#endif /* EditTaskView_h */
