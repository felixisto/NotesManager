//
//  CategoryViewItemParser.m
//  NotesManager
//
//  Created by Kristiyan Butev on 17.06.21.
//

#import "CategoryViewItemParser.h"

@implementation CategoryViewItemStandardParser

- (nonnull CategoryViewItem*)parse:(nonnull Category*)category {
    CategoryViewItem* item = [CategoryViewItem new];
    item.name = category.name;
    item.color = category.colorAsUIColor;
    item.numberOfTasks = category.tasks.count;
    return item;
}

@end
