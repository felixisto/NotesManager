//
//  RepositoryDataListener.m
//  NotesManager
//
//  Created by Kristiyan Butev on 17.06.21.
//

#import "RepositoryDataListener.h"

@implementation RepositoryDataListenerWeak

- (instancetype)initWithValue:(nullable id<RepositoryDataListener>)value {
    if (self = [super init]) {
        self.value = value;
    }
    return self;
}

@end
