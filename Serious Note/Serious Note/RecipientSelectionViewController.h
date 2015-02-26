//
//  RecipientSelectionViewController.h
//  Serious Note
//
//  Created by Brian Ledbetter on 2/25/15.
//  Copyright (c) 2015 Brian Ledbetter. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Reminder.h"


@interface RecipientSelectionViewController : UIViewController
@property (strong, nonatomic) Reminder* selectedReminder;
@property (strong, nonatomic) NSDate* fireDate;
@end
