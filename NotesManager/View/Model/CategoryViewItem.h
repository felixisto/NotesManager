//
//  CategoryViewItem.h
//  NotesManager
//
//  Created by Kristiyan Butev on 17.06.21.
//

#ifndef CategoryViewItem_h
#define CategoryViewItem_h

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface CategoryViewItem : NSObject

@property (nonatomic, nullable, copy) NSString* name;
@property (nonatomic, nullable, strong) UIColor* color;
@property (nonatomic, assign) NSUInteger numberOfTasks;

@end

#endif /* CategoryViewItem_h */
