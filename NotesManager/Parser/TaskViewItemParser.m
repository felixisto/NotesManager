//
//  TaskViewItemParser.m
//  NotesManager
//
//  Created by Kristiyan Butev on 16.06.21.
//

#import "TaskViewItemParser.h"

@implementation TaskViewItemStandardParser

- (nonnull TaskViewItem*)parse:(nonnull UserTask*)task {
    TaskViewItem* item = [TaskViewItem new];
    item.isActive = task.isActive;
    item.name = task.name;
    item.categoryName = task.category.name;
    item.categoryColor = task.category.colorAsUIColor;
    item.expiration = task.expiration;
    item.notifyOnExpiration = task.notifyOnExpiration;
    return item;
}

@end
