//
//  DisplayReminderViewController.m
//  Serious Note
//
//  Created by Brian Ledbetter on 2/26/15.
//  Copyright (c) 2015 Brian Ledbetter. All rights reserved.
//

#import "DisplayReminderViewController.h"

@interface DisplayReminderViewController ()
@property (weak, nonatomic) IBOutlet UILabel *messageTypeLabel;
@property (weak, nonatomic) IBOutlet UILabel *mediaTypeLabel;
@property (weak, nonatomic) IBOutlet UILabel *textContentLabel;
@property (weak, nonatomic) IBOutlet UILabel *reminderIDLabel;

@end

@implementation DisplayReminderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    if (self.selectedReminder.userID) {
        self.reminderIDLabel.text = [NSString stringWithFormat: @"ReminderID#: %ld", self.selectedReminder.userID];
    }
    
    switch (self.selectedReminder.mediaType) {
        case 0:{
            self.reminderIDLabel.text = self.selectedReminder.textContent;
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
            self.messageTypeLabel.text = @"Time-Based Reminder";
            break;
        case 1:
            self.messageTypeLabel.text = @"Location-Based Reminder";
            break;
        default:
            self.messageTypeLabel.text = @"MessageType: UNKNOWN";
            break;
    }}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
