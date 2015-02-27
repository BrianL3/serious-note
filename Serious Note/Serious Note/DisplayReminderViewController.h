//
//  DisplayReminderViewController.h
//  Serious Note
//
//  Created by Brian Ledbetter on 2/26/15.
//  Copyright (c) 2015 Brian Ledbetter. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Reminder.h"

@interface DisplayReminderViewController : UIViewController
@property (strong, nonatomic) Reminder* selectedReminder;
@end
