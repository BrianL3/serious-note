//
//  TimePickerViewController.m
//  Serious Note
//
//  Created by Brian Ledbetter on 2/23/15.
//  Copyright (c) 2015 Brian Ledbetter. All rights reserved.
//

#import "TimePickerViewController.h"
#import "ReminderService.h"

@interface TimePickerViewController ()

@property (weak, nonatomic) IBOutlet UIDatePicker *reminderDatePicker;
@property (strong, nonatomic) NSDate* selectedDate;


@end

@implementation TimePickerViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    //no setting reminders on dates in the past
    self.reminderDatePicker.minimumDate = [[NSDate alloc] init];


    
    
}
- (IBAction)doneButtonPressed:(id)sender {
    self.selectedDate = self.reminderDatePicker.date;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"TIME_REMINDER_DETAIL"]) {
        if (self.selectedDate){
        NSLog(@"a date was passed successfully");
        }
        TimeReminderDetailViewController* destinationVC = (TimeReminderDetailViewController*)segue.destinationViewController;
        destinationVC.selectedDate = self.selectedDate;
    }
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}


@end
