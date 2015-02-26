//
//  Reminder.h
//  Serious Note
//
//  Created by Brian Ledbetter on 2/24/15.
//  Copyright (c) 2015 Brian Ledbetter. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@interface Reminder : NSObject

- (instancetype)initWithTime: (NSDate*)reminderTime withText:(NSString*)text withAudio:(NSData*)audioData withVideo:(NSData*)videoData;

- (instancetype)initWithLocation: (CLLocation*) reminderLocation withText:(NSString*)text withAudio:(NSData*)audioData withVideo:(NSData*)videoData;

- (instancetype)initWithJSON: (NSDictionary*)jsonDictionary;



typedef enum _MediaType {
    textType = 0,
    audioType = 1,
    videoType = 2,
    unknownType = -1
} MediaType;

typedef enum _MessageType {
    timeBased = 0,
    locationBased = 1,
    unknownBased = -1
} MessageType;

@property NSInteger userID;
@property int reminderID;
@property (strong, nonatomic) NSString* textContent;
@property (strong, nonatomic) NSData* audioContent;
@property (strong, nonatomic) NSData* videoContent;
@property (assign, nonatomic) MediaType mediaType;
@property int recipientNumber;
@property (assign, nonatomic) MessageType messageType;


@end
