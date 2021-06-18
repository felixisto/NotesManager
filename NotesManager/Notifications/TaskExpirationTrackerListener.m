//
//  TaskExpirationTrackerListener.m
//  NotesManager
//
//  Created by Kristiyan Butev on 17.06.21.
//

#import "TaskExpirationTrackerListener.h"

@implementation TaskExpirationTrackerListenerWeak

- (instancetype)initWithValue:(nullable id<TaskExpirationTrackerListener>)value {
    if (self = [super init]) {
        self.value = value;
    }
    return self;
}

@end
