//
//  Reminder.h
//  Serious Note
//
//  Created by Brian Ledbetter on 2/24/15.
//  Copyright (c) 2015 Brian Ledbetter. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Reminder : NSObject

- (instancetype)initWithTime: (NSDate*)reminderTime withText:(NSString*)text withAudio:(NSData*)audioData withVideo:(NSData*)videoData;


typedef enum _MediaType {
    textType = 0,
    audioType,
    videoType,
    unknownType = -1
} MediaType;

typedef enum _MessageType {
    timeBased = 0,
    locationBased,
    unknownBased = -1
} MessageType;

@property (strong, nonatomic) NSString* userID;
@property int reminderID;
@property (strong, nonatomic) NSString* textContent;
@property (strong, nonatomic) NSData* audioContent;
@property (strong, nonatomic) NSData* videoContent;
@property (assign, nonatomic) MediaType mediaType;
@property int recipientNumber;
@property (assign, nonatomic) MessageType messageType;


@end
