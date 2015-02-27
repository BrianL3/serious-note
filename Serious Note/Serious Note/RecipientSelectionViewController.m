//
//  RecipientSelectionViewController.m
//  Serious Note
//
//  Created by Brian Ledbetter on 2/25/15.
//  Copyright (c) 2015 Brian Ledbetter. All rights reserved.
//

#import "RecipientSelectionViewController.h"
#import "ReminderService.h"

@interface RecipientSelectionViewController ()
@property (weak, nonatomic) IBOutlet UILabel *textLabel;
@property (weak, nonatomic) IBOutlet UILabel *userLabel;
@property (weak, nonatomic) IBOutlet UILabel *mediaTypeLabel;
@property (weak, nonatomic) IBOutlet UILabel *messsageTypeLabel;
@property (weak, nonatomic) IBOutlet UIButton *postButton;

@end

@implementation RecipientSelectionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    if (self.selectedReminder.userID) {
        self.userLabel.text = [NSString stringWithFormat: @"UserPhone#: %ld", self.selectedReminder.userID];
    }

    switch (self.selectedReminder.mediaType) {
        case 0:{
            self.textLabel.text = self.selectedReminder.textContent;
            self.mediaTypeLabel.text = @"Reminder Type: Text";
            break;
        }
        case 1:{
            self.mediaTypeLabel.text = @"Reminder Type: Audio";
            break;
        }
        case 2:{
            self.mediaTypeLabel.text = @"Reminder Type: Video";
            break;
        }
        default:
            self.mediaTypeLabel.text = @"ReminderType: UNKNOWN";
            break;
    }
    switch (self.selectedReminder.messageType) {
        case 0:
            self.messsageTypeLabel.text = @"Time-Based Reminder";
            break;
        case 1:
            self.messsageTypeLabel.text = @"Location-Based Reminder";
            break;
        default:
            self.messsageTypeLabel.text = @"MessageType: UNKNOWN";
            break;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)postButtonPressed:(id)sender {
    [[ReminderService sharedService] addReminder:self.selectedReminder];
    NSLog(@"The POST button fired.");
}
- (IBAction)getButtonPressed:(id)sender {
    [[ReminderService sharedService] getReminder:self.selectedReminder.reminderID completionHandler:^(Reminder *result, NSString *error) {
        self.view.backgroundColor = [UIColor colorWithRed:2/255 green:34/25 blue:215/255 alpha:1.0];
        self.selectedReminder = result;
        if (self.selectedReminder.userID) {
            self.userLabel.text = [NSString stringWithFormat: @"UserPhone#: %ld", self.selectedReminder.userID];
        }
        
        switch (self.selectedReminder.mediaType) {
            case 0:{
                self.textLabel.text = self.selectedReminder.textContent;
                self.mediaTypeLabel.text = @"Reminder Type: Text";
                break;
            }
            case 1:{
                self.mediaTypeLabel.text = @"Reminder Type: Audio";
                break;
            }
            case 2:{
                self.mediaTypeLabel.text = @"Reminder Type: Video";
                break;
            }
            default:
                self.mediaTypeLabel.text = @"ReminderType: UNKNOWN";
                break;
        }
        switch (self.selectedReminder.messageType) {
            case 0:
                self.messsageTypeLabel.text = @"Time-Based Reminder";
                break;
            case 1:
                self.messsageTypeLabel.text = @"Location-Based Reminder";
                break;
            default:
                self.messsageTypeLabel.text = @"MessageType: UNKNOWN";
                break;
        }
    }];
}

//MARK: SCHEDULE A TIMED REMINDER:
// call when reminder set / done button pressed
-(void)scheduleReminderNotification: (Reminder*)reminder{
    UILocalNotification *localNotification = [[UILocalNotification alloc] init];
    if (!localNotification){
        return;
    }
    NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"hh-mm -a";
    NSDate* date = [dateFormatter dateFromString:[dateFormatter stringFromDate:self.fireDate]];

    [localNotification setFireDate:date];
    [localNotification setTimeZone:[NSTimeZone defaultTimeZone]];
    // Setup alert notification
    [localNotification setAlertBody:[NSString stringWithFormat: @"Reminder: %@", reminder.textContent]];
    [localNotification setAlertAction:@"Open App"];
    [localNotification setHasAction:YES];

    //schedule it
    [[UIApplication sharedApplication] scheduleLocalNotification:localNotification];

    
}
/*
 
 //This array maps the alarms uid to the index of the alarm so that we can cancel specific local notifications
 
 NSNumber* uidToStore = [NSNumber numberWithInt:indexOfObject];
 NSDictionary *userInfo = [NSDictionary dictionaryWithObject:uidToStore forKey:@"notificationID"];
 localNotification.userInfo = userInfo;
 NSLog(@"Uid Store in userInfo %@", [localNotification.userInfo objectForKey:@"notificationID"]);
 
 // Schedule the notification
 [[UIApplication sharedApplication] scheduleLocalNotification:localNotification];
 
 */


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
