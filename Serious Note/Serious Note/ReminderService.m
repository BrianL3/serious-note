//
//  ReminderService.m
//  Serious Note
//
//  Created by Brian Ledbetter on 2/24/15.
//  Copyright (c) 2015 Brian Ledbetter. All rights reserved.
//

#import "ReminderService.h"

@interface ReminderService()

@property (strong, nonatomic) NSString* apiURL;
@property (strong, nonatomic) NSURLSession* urlSession;

@end

@implementation ReminderService

// this method creates a singleton
+(id)sharedService {
    static ReminderService *mySharedService = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        mySharedService = [[self alloc] init];
        mySharedService.apiURL = @"http://seriousnote-server.herokuapp.com/api/v1/seriousnote/";
        NSURLSessionConfiguration* ephemeralConfig = [NSURLSessionConfiguration ephemeralSessionConfiguration];
        mySharedService.urlSession = [NSURLSession sessionWithConfiguration:ephemeralConfig];



    });
    return mySharedService;
}//eo sharedService func



-(void)addReminder: (Reminder*)reminder{
    
    NSLog(@"%d", reminder.reminderID);
    
    //our server URL
    NSString* serverURLString = self.apiURL;
    //serverURLString = [serverURLString stringByAppendingString:reminder.userID];
    NSURL* serverURL = [[NSURL alloc] initWithString:serverURLString];
    
    //user the network controller singleton to POST a reminder
    //NSString* contentDataString = [[NSString alloc] initWithData:reminder.audioContent encoding:NSUTF8StringEncoding];

    
    NSString* bodyString = [NSString stringWithFormat:@"{\"reminderID\":%d,\"userID\":%ld, \"textContent\":\"%@\",\"mediaType\":%d,\"mediaContent\":\"%@\"}", reminder.reminderID, reminder.userID, reminder.textContent, reminder.mediaType, reminder.audioContent];

    NSData* bodyData = [bodyString dataUsingEncoding:(NSUTF8StringEncoding)];
    
    // a little error checking
    NSUInteger length  = bodyData.length;
    NSLog(@"the data is of length: %lu", length);
    
    NSMutableURLRequest* postRequest = [[NSMutableURLRequest alloc] initWithURL:serverURL];
    postRequest.HTTPMethod = @"POST";
    NSString* lengthString = [NSString stringWithFormat:@"%lu", length];
    [postRequest setValue:lengthString forHTTPHeaderField:@"Content-Length"];
    [postRequest setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    postRequest.HTTPBody = bodyData;
    
    NSURLSessionDataTask *postDataTask = [self.urlSession dataTaskWithRequest:postRequest completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        if (!error){
            NSHTTPURLResponse* httpResponse = (NSHTTPURLResponse*)response;
            NSInteger statusCode = httpResponse.statusCode;
            switch (statusCode) {
                case 200 ... 299:
                    NSLog(@"200 Status OK");
                    break;
                case 300 ... 399:
                    NSLog(@"POST Failed, status code: %ld", statusCode);
                    break;
                case 400 ... 499:
                    NSLog(@"POST Failed, status code: %ld", (long)statusCode);
                    break;
                default:
                    NSLog(@"Shit is fucked, try again");
                    break;
            }
        }
    }];
    [postDataTask resume];
}

-(void)removeReminder: (NSString*)reminderIdentity{
    
}


@end
