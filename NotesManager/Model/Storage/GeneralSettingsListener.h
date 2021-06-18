//
//  GeneralSettingsListener.h
//  NotesManager
//
//  Created by Kristiyan Butev on 17.06.21.
//

#ifndef GeneralSettingsListener_h
#define GeneralSettingsListener_h

#import <Foundation/Foundation.h>

@protocol GeneralSettingsListener <NSObject>

- (void)onSettingsChanged;

@end

@interface GeneralSettingsListenerWeak : NSObject

@property (nonatomic, weak) id<GeneralSettingsListener> value;

- (instancetype)initWithValue:(nullable id<GeneralSettingsListener>)value;

@end

#endif /* GeneralSettingsListener_h */
