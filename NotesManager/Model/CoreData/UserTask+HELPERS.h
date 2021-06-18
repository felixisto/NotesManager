//
//  UserTask+HELPERS.h
//  NotesManager
//
//  Created by Kristiyan Butev on 17.06.21.
//

#ifndef UserTask_HELPERS_h
#define UserTask_HELPERS_h

#import "UserTask+CoreDataClass.h"

@interface UserTask (HELPERS)

- (NSTimeInterval)timeUntilExpiration;

- (BOOL)isExpirationDateReached;

@end

#endif /* UserTask_HELPERS_h */
