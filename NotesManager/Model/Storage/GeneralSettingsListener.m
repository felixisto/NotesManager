//
//  GeneralSettingsListener.m
//  NotesManager
//
//  Created by Kristiyan Butev on 17.06.21.
//

#import "GeneralSettingsListener.h"

@implementation GeneralSettingsListenerWeak

- (instancetype)initWithValue:(nullable id<GeneralSettingsListener>)value {
    if (self = [super init]) {
        self.value = value;
    }
    return self;
}

@end
