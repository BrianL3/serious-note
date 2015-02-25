//
//  TimeReminderDetailViewController.h
//  Serious Note
//
//  Created by Brian Ledbetter on 2/24/15.
//  Copyright (c) 2015 Brian Ledbetter. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RecorderViewController.h"

@interface TimeReminderDetailViewController : UIViewController
@property (strong, nonatomic) NSDate* selectedDate;
@property BOOL hasAudio;
@property (strong, nonatomic) NSURL* audioFileLocation;
@end
