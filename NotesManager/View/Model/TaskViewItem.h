//
//  TaskViewItem.h
//  NotesManager
//
//  Created by Kristiyan Butev on 16.06.21.
//

#ifndef TaskViewItem_h
#define TaskViewItem_h

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface TaskViewItem : NSObject

@property (nonatomic, assign) BOOL isActive;
@property (nonatomic, nullable, copy) NSString* name;
@property (nonatomic, nullable, copy) NSString* categoryName;
@property (nonatomic, nullable, strong) UIColor* categoryColor;
@property (nonatomic, nullable, strong) NSDate* expiration;
@property (nonatomic, assign) BOOL notifyOnExpiration;

@end

#endif /* TaskViewItem_h */
