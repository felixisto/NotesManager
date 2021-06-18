//
//  TaskViewItemParser.h
//  NotesManager
//
//  Created by Kristiyan Butev on 16.06.21.
//

#ifndef TaskViewItemParser_h
#define TaskViewItemParser_h

#import <Foundation/Foundation.h>
#import "TaskViewItem.h"
#import "UserTask+CoreDataClass.h"
#import "Category+HELPERS.h"

@protocol TaskViewItemParser <NSObject>

- (nonnull TaskViewItem*)parse:(nonnull UserTask*)task;

@end

@interface TaskViewItemStandardParser : NSObject <TaskViewItemParser>

@end

#endif /* TaskViewItemParser_h */
