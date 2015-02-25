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
    //user the network controller singleton to POST a reminder
    
    //METHOD 2: is is the 2nd way you can pass back info with a POST, and this is passing back info in the Body of the HTTP Request
    //    let bodyString = "\(code!)&client_id=\(self.clientID)&client_secret=\(self.clientSecret)"
    //    let bodyData = bodyString.dataUsingEncoding(NSASCIIStringEncoding, allowLossyConversion: true)
    //    let length = bodyData!.length
    //    let postRequest = NSMutableURLRequest(URL: NSURL(string: "https://github.com/login/oauth/access_token")!)
    //    postRequest.HTTPMethod = "POST"
    //    postRequest.setValue("\(length)", forHTTPHeaderField: "Content-Length")
    //    postRequest.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
    //    postRequest.HTTPBody = bodyData
    
}

-(void)removeReminder: (NSString*)reminderIdentity{
    
}

@end
