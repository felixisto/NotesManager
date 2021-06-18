//
//  TaskExpirationTrackerListener.h
//  NotesManager
//
//  Created by Kristiyan Butev on 16.06.21.
//

#ifndef TaskExpirationTrackerListener_h
#define TaskExpirationTrackerListener_h

#import <Foundation/Foundation.h>

@protocol TaskExpirationTrackerListener <NSObject>

- (void)onTaskExpired:(nonnull NSString*)name;

@end

@interface TaskExpirationTrackerListenerWeak : NSObject

@property (nonatomic, weak) id<TaskExpirationTrackerListener> value;

- (instancetype)initWithValue:(nullable id<TaskExpirationTrackerListener>)value;

@end

#endif /* TaskExpirationTrackerListener_h */
