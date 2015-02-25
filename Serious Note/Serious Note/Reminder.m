//
//  Reminder.m
//  Serious Note
//
//  Created by Brian Ledbetter on 2/24/15.
//  Copyright (c) 2015 Brian Ledbetter. All rights reserved.
//

#import "Reminder.h"

@implementation Reminder

//create a Reminder, the standard init.  to be used when creating a new reminder with a unique ID.
- (instancetype)init{
    self = [super init];
    if (self) {
        //set reminderID as the current clocktime
        NSDate* currentTime = [NSDate date];
        self.reminderID = currentTime.timeIntervalSinceReferenceDate;
        //PLACEHOLDER: REPLACE THIS!
        self.userID = @"bob";
    }
    return self;
}

//serial a JSON blob into a reminder
- (instancetype)initWithJSON: (NSDictionary*)jsonDictionary{
    self = [super init];
    if (self) {
        // JSON serialize all the shit here
    }
    return self;
}


@end
