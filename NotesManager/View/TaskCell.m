//
//  TaskCell.m
//  NotesManager
//
//  Created by Kristiyan Butev on 16.06.21.
//

#import "TaskCell.h"

#define TaskCell_1HourTime (60 * 60)

@implementation TaskCell

- (void)setExpiration:(NSDate*)date {
    if (date == nil) {
        self.expirationLabel.text = @"";
        return;
    }
    
    NSDateFormatter* formatter = [NSDateFormatter new];
    
    if ([date timeIntervalSinceNow] >= TaskCell_1HourTime) {
        // Show long version if expiration is set in far future
        formatter.dateFormat = @"MMM dd, HH:mm";
    } else {
        // Show short version otherwise
        formatter.dateFormat = @"HH:mm:ss";
    }
    
    NSString* expiredString = [date timeIntervalSinceNow] > 0 ? @"Expires" : @"Expired";
    
    self.expirationLabel.text = [NSString stringWithFormat:@"%@ on %@", expiredString, [formatter stringFromDate:date]];
}

@end
