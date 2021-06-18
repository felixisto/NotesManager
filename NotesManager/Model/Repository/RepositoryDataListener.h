//
//  RepositoryDataListener.h
//  NotesManager
//
//  Created by Kristiyan Butev on 17.06.21.
//

#ifndef RepositoryDataListener_h
#define RepositoryDataListener_h

#import <Foundation/Foundation.h>

@protocol RepositoryDataListener <NSObject>

- (void)onItemCreate:(NSString*)itemName;
- (void)onItemDelete:(NSString*)itemName;
- (void)onRepositoryDataChanged;

@end

@interface RepositoryDataListenerWeak : NSObject

@property (nonatomic, weak) id<RepositoryDataListener> value;

- (instancetype)initWithValue:(nullable id<RepositoryDataListener>)value;

@end

#endif /* RepositoryDataListener_h */
