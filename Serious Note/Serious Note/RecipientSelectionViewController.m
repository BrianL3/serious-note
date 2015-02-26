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
        self.userLabel.text = self.selectedReminder.userID;
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
