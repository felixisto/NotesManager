//
//  EditCategoryView.h
//  NotesManager
//
//  Created by Kristiyan Butev on 16.06.21.
//

#ifndef EditCategoryView_h
#define EditCategoryView_h

#import <UIKit/UIKit.h>
#import "ColorPickerView.h"

@interface EditCategoryView : UIView

@property (weak, nonatomic) IBOutlet UITextField *nameTextField;
@property (weak, nonatomic) IBOutlet ColorPickerView *pickColorView;

@property (strong) UIColor* pickedColor;

@end

#endif /* EditCategoryView_h */
