//
//  UserTask+HELPERS.m
//  NotesManager
//
//  Created by Kristiyan Butev on 17.06.21.
//

#import "UserTask+HELPERS.h"

@implementation UserTask (HELPERS)

- (NSTimeInterval)timeUntilExpiration {
    return [self.expiration timeIntervalSinceNow];
}

- (BOOL)isExpirationDateReached {
    return [self timeUntilExpiration] <= 0;
}

@end

