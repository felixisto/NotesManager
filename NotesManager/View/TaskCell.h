//
//  TaskCell.h
//  NotesManager
//
//  Created by Kristiyan Butev on 16.06.21.
//

#ifndef TaskCell_h
#define TaskCell_h

#import <UIKit/UIKit.h>

#define TaskCell_CELL_ID @"TaskCell"

@interface TaskCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIView *solidColorView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *expirationLabel;

- (void)setExpiration:(NSDate*)date;

@end

#endif /* TaskCell_h */
