//
//  ReminderService.h
//  Serious Note
//
//  Created by Brian Ledbetter on 2/24/15.
//  Copyright (c) 2015 Brian Ledbetter. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Reminder.h"

@interface ReminderService : NSObject

+(id)sharedService;
-(void)addReminder: (Reminder*)reminder;
-(void)removeReminder: (NSString*)reminderIdentity;
-(void)getReminder: (int)reminderID completionHandler:(void (^)(Reminder *result, NSString *error))completionHandler;

@end
