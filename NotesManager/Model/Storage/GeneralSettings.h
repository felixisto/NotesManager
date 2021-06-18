//
//  GeneralSettings.h
//  NotesManager
//
//  Created by Kristiyan Butev on 16.06.21.
//

#ifndef GeneralSettings_h
#define GeneralSettings_h

#import <Foundation/Foundation.h>
#import "GeneralSettingsListener.h"

typedef enum SettingsSorting: NSUInteger {
    SettingsSortingChronologically,
    SettingsSortingAlphabetically
} SettingsSorting;

@interface GeneralSettings : NSObject

@property (readonly) BOOL isFirstLaunch;
@property (assign) BOOL isNotificationDeliveryOn;
@property (assign) SettingsSorting tasksSorting;
@property (readonly) NSString* tasksSortingAsString;

+ (nonnull instancetype)shared;

- (nonnull instancetype)init __attribute__((unavailable("Singleton")));

- (void)subscribe:(nonnull id<GeneralSettingsListener>)listener;
- (void)unsubscribe:(nonnull id<GeneralSettingsListener>)listener;

@end

#endif /* GeneralSettings_h */
