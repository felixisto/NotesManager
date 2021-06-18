//
//  CategoryViewItemParser.h
//  NotesManager
//
//  Created by Kristiyan Butev on 17.06.21.
//

#ifndef CategoryViewItemParser_h
#define CategoryViewItemParser_h

#import <Foundation/Foundation.h>
#import "CategoryViewItem.h"
#import "Category+CoreDataClass.h"
#import "Category+HELPERS.h"

@protocol CategoryViewItemParser <NSObject>

- (nonnull CategoryViewItem*)parse:(nonnull Category*)category;

@end

@interface CategoryViewItemStandardParser : NSObject <CategoryViewItemParser>

@end

#endif /* CategoryViewItemParser_h */
