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
- (instancetype)initWithTime: (NSDate*)reminderTime withText:(NSString*)text withAudio:(NSData*)audioData withVideo:(NSData*)videoData{
    self = [super init];
    if (self) {
        self.messageType = timeBased;
        //set reminderID as the current clocktime
        NSDate* currentTime = [NSDate date];
        self.reminderID = currentTime.timeIntervalSinceReferenceDate;
        //PLACEHOLDER: REPLACE THIS!
        self.userID = -1;
        //creating the time reminder
        if (audioData) {
            self.audioContent = audioData;
            self.mediaType = audioType;
        }
        if (text) {
            self.textContent = text;
            self.mediaType = textType;
        }
        if (videoData) {
            self.videoContent = videoData;
            self.mediaType = videoType;
        }

    }
    NSLog(@"A reminder object was just created with type: %d", self.mediaType);
    return self;
}

//create a location-based Reminder, to be used when creating a new reminder with a unique ID.
- (instancetype)initWithLocation: (CLLocation*) reminderLocation withText:(NSString*)text withAudio:(NSData*)audioData withVideo:(NSData*)videoData
{
  self = [super init];
  if (self) {
    self.messageType = locationBased;
    //set reminderID as the current clocktime
    NSDate* currentTime = [NSDate date];
    self.reminderID = currentTime.timeIntervalSinceReferenceDate;
    //PLACEHOLDER: REPLACE THIS!
    self.userID = -1;
    if (audioData) {
      self.audioContent = audioData;
      self.mediaType = audioType;
    }
    if (text) {
      self.textContent = text;
      self.mediaType = textType;
    }
    if (videoData) {
      self.videoContent = videoData;
      self.mediaType = videoType;
    }
    
  } // if self
  NSLog(@"A reminder object was just created with type: %d", self.mediaType);
  return self;
} // initWithLocation()


//serial a JSON blob into a reminder
- (instancetype)initWithJSON: (NSDictionary*)jsonDictionary{
    NSLog(@"the jsonDictionary as received by the initializer is: %@", jsonDictionary);

    NSObject* whatIsThis = jsonDictionary[@"mediaContent"];
    NSLog(@"the class type of the mediaContent is: %@", whatIsThis.class);

    
    
    self = [super init];
    if (self) {
        //casting
        NSNumber* reminderIDPlaceholder = (NSNumber*)jsonDictionary[@"reminderID"];
        _reminderID = reminderIDPlaceholder.integerValue;
        //casting
        NSNumber* userIDPlaceholder = (NSNumber*)jsonDictionary[@"userID"];
        self.userID = userIDPlaceholder.integerValue;
        //casting
        NSNumber* mediaTypePlaceholder = (NSNumber*)jsonDictionary[@"mediaType"];
        _mediaType = (MediaType)mediaTypePlaceholder;

        _textContent = (NSString*)jsonDictionary[@"textContent"];
        _audioContent = (NSData*)jsonDictionary[@"mediaContent"];
    }
    return self;
}
/*
{
    "__v" = 0;
    "_id" = 54f0a9f5c5c64b0300da8042;
    mediaContent = "(null)";
    mediaType = 0;
    reminderID = 446751091;
    textContent = utsiyd;
    userID = "-1";
}
 */

@end
