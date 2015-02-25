//
//  ReminderService.m
//  Serious Note
//
//  Created by Brian Ledbetter on 2/24/15.
//  Copyright (c) 2015 Brian Ledbetter. All rights reserved.
//

#import "ReminderService.h"

@interface ReminderService()



@end

@implementation ReminderService

// this method creates a singleton
+(id)sharedService {
    static ReminderService *mySharedService = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        mySharedService = [[self alloc] init];
    });
    return mySharedService;
}//eo sharedService func



-(void)addReminder: (Reminder*)reminder{
    //our server URL
    NSURL* serverURL = [[NSURL alloc] initWithString:@""];
    
    //user the network controller singleton to POST a reminder
    NSString* bodyString = [NSString stringWithFormat:@"&user_id=%@&reminder_id=%d", reminder.userID, reminder.reminderID];
    NSData* bodyData = [bodyString dataUsingEncoding:(NSASCIIStringEncoding)];
    
    // a little error checking
    NSUInteger length  = bodyData.length;
    NSLog(@"the data is of length: %lu", length);
    
    NSMutableURLRequest* postRequest = [[NSMutableURLRequest alloc] initWithURL:serverURL];
    postRequest.HTTPMethod = @"POST";
    NSString* lengthString = [NSString stringWithFormat:@"%lu", length];
    [postRequest setValue:lengthString forHTTPHeaderField:@"Content-Length"];
    [postRequest setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    postRequest.HTTPBody = bodyData;
        
}

-(void)removeReminder: (NSString*)reminderIdentity{
    
}

@end
