//
//  EditCategoryView.m
//  NotesManager
//
//  Created by Kristiyan Butev on 16.06.21.
//

#import "EditCategoryView.h"

@implementation EditCategoryView

- (UIColor*)pickedColor {
    return self.pickColorView.pickedColor;
}

- (void)setPickedColor:(UIColor *)pickedColor {
    self.pickColorView.pickedColor = pickedColor;
}

@end
