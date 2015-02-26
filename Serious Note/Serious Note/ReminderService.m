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
    //our server URL
    NSString* serverURLString = self.apiURL;
    serverURLString = [serverURLString stringByAppendingString:reminder.userID];
    NSURL* serverURL = [[NSURL alloc] initWithString:serverURLString];
    
    //user the network controller singleton to POST a reminder
    NSString* bodyString = [NSString stringWithFormat:@"{\"reminderID\":%d,\"textContent\":%@}", reminder.reminderID, reminder.textContent];

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
    
    NSURLSessionDataTask *postDataTask = [self.urlSession dataTaskWithRequest:postRequest completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        if (!error){
            NSHTTPURLResponse* httpResponse = (NSHTTPURLResponse*)response;
            NSInteger statusCode = httpResponse.statusCode;
            switch (statusCode) {
                case 200 ... 299:
                    NSLog(@"200 Status OK");
                    break;
                    
                default:
                    NSLog(@"Shit is fucked, try again");
                    break;
            }
        }
    }];
    [postDataTask resume];

    
   // NSURLSession* dataTask =
    /*
     let dataTask = self.urlSession.dataTaskWithRequest(postRequest, completionHandler: { (data, response, error) -> Void in
     //check&proceed if Service Provide returns nil for Error
     if error == nil{
     //check&proceed if we can form a NSHTTPURLResponse from Service provider's response
     if let httpResponse = response as? NSHTTPURLResponse{
     //build a switch on the response's status code
     switch httpResponse.statusCode{
     case 200...299:
     //println("Status 200 OK")
     let tokenResponse = NSString(data: data, encoding: NSASCIIStringEncoding)
     //println("check where to split token response in order to get only the authToken: \(tokenResponse)")
     
     //splitting the token response
     let accessTokenComponent = tokenResponse?.componentsSeparatedByString("&").first as String
     let accessToken = accessTokenComponent.componentsSeparatedByString("=").last
     //println("Check Access Token \(accessToken)")
     
     //Save the AccessToken
     NSUserDefaults.standardUserDefaults().setObject(accessToken!, forKey: self.accessTokenUserDefaultsKey)
     NSUserDefaults.standardUserDefaults().synchronize()
     case 500...599:
     println("GitHub is down")
     default:
     println("hit default case")
     println(httpResponse.statusCode)
     }
     }
     }
     })
     dataTask.resume()
     
     
     
     SString *deviceID = [[NSUserDefaults standardUserDefaults] objectForKey:@"deviceID"];
     NSString *textContent = @"New note";
     NSString *noteDataString = [NSString stringWithFormat:@"deviceId=%@&textContent=%@", deviceID, textContent];
     
     NSURLSessionConfiguration *sessionConfiguration = [NSURLSessionConfiguration defaultSessionConfiguration];
     sessionConfiguration.HTTPAdditionalHeaders = @{
     @"api-key"       : @"API_KEY"
     };
     NSURLSession *session = [NSURLSession sessionWithConfiguration:sessionConfiguration];
     NSURL *url = [NSURL URLWithString:@"http://url_to_manage_post_requests"];
     NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
     request.HTTPBody = [noteDataString dataUsingEncoding:NSUTF8StringEncoding];
     request.HTTPMethod = @"POST";
     NSURLSessionDataTask *postDataTask = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
     // The server answers with an error because it doesn't receive the params
     }];
     [postDataTask resume];
     */
    
}

-(void)removeReminder: (NSString*)reminderIdentity{
    
}

@end
