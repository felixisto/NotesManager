//
//  GeneralSettings.m
//  NotesManager
//
//  Created by Kristiyan Butev on 16.06.21.
//

#import "GeneralSettings.h"

@interface GeneralSettings ()

@property (nonatomic, assign) BOOL isFirstLaunch;

@property (strong, nonnull) NSMutableArray<GeneralSettingsListenerWeak*>* listeners;

@end

@implementation GeneralSettings

+ (nonnull instancetype)shared {
    static GeneralSettings* shared;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        shared = [GeneralSettings new];
    });
    return shared;
}

- (instancetype)init {
    if (self = [super init]) {
        self.listeners = [NSMutableArray new];
        self.isFirstLaunch = ![[NSUserDefaults standardUserDefaults] boolForKey:@"isPastFirstLaunch"];
        [self setFirstLaunch];
        
        if (self.isFirstLaunch) {
            self.isNotificationDeliveryOn = true;
            self.tasksSorting = SettingsSortingChronologically;
        }
    }
    return self;
}

- (void)setFirstLaunch {
    [[NSUserDefaults standardUserDefaults] setBool:true forKey:@"isPastFirstLaunch"];
}

- (BOOL)isNotificationDeliveryOn {
    return [[NSUserDefaults standardUserDefaults] boolForKey:@"isNotificationDeliveryOn"];
}

- (void)setIsNotificationDeliveryOn:(BOOL)isNotificationDeliveryOn {
    [[NSUserDefaults standardUserDefaults] setBool:isNotificationDeliveryOn forKey:@"isNotificationDeliveryOn"];
    
    [self alertListenersOfChanges];
}

- (SettingsSorting)tasksSorting {
    return [[NSUserDefaults standardUserDefaults] boolForKey:@"tasksSorting"];
}

- (void)setTasksSorting:(SettingsSorting)sorting {
    [[NSUserDefaults standardUserDefaults] setInteger:sorting forKey:@"tasksSorting"];
    
    [self alertListenersOfChanges];
}

- (NSString*)tasksSortingAsString {
    return self.tasksSorting == SettingsSortingAlphabetically ? @"Alphabetical" : @"Chronological";
}

#pragma mark - Listeners

- (void)alertListenersOfChanges {
    for (GeneralSettingsListenerWeak* l in [NSArray arrayWithArray:self.listeners]) {
        [l.value onSettingsChanged];
    }
}

- (void)subscribe:(nonnull id<GeneralSettingsListener>)listener {
    [self unsubscribe:listener];
    
    [self.listeners addObject:[[GeneralSettingsListenerWeak alloc] initWithValue:listener]];
}

- (void)unsubscribe:(nonnull id<GeneralSettingsListener>)listener {
    for (GeneralSettingsListenerWeak* l in [NSArray arrayWithArray:self.listeners]) {
        if (l.value == nil || l.value == listener) {
            [self.listeners removeObject:l];
        }
    }
}

@end
