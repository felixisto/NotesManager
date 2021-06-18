//
//  CategoryCell.h
//  NotesManager
//
//  Created by Kristiyan Butev on 16.06.21.
//

#ifndef CategoryCell_h
#define CategoryCell_h

#import <UIKit/UIKit.h>

#define CategoryCell_CELL_ID @"CategoryCell"

@interface CategoryCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIView *solidColorView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

@end

#endif /* CategoryCell_h */
