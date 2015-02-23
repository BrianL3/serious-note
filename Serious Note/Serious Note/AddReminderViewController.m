//
//  AddReminderViewController.m
//  Serious Note
//
//  Created by John Leonard on 2/23/15.
//  Copyright (c) 2015 Brian Ledbetter. All rights reserved.
//

#import "AddReminderViewController.h"

@interface AddReminderViewController ()

@property (strong, nonatomic) NSString *reminderName;
@property (weak, nonatomic) IBOutlet UITextField *userText;


@end

@implementation AddReminderViewController

- (void)viewDidLoad
{
  [super viewDidLoad];
  
  NSLog(@"lat: %f, long: %f", self.annotation.coordinate.latitude, self.annotation.coordinate.longitude);
}

- (IBAction)addVoice:(id)sender
{
  // put code to add voice reminder here
  
  NSLog(@"Add Voice button pressed");
  // make sure that monitoring is available
  if([CLLocationManager isMonitoringAvailableForClass:[CLCircularRegion class]])
  {
    if (self.userText.text.length == 0)
    {
      self.userText.text = @"Generic Reminder";
    }
    
    // create a 200m-diameter region around the pin
    CLCircularRegion *region = [[CLCircularRegion alloc] initWithCenter:self.annotation.coordinate radius:200 identifier:self.userText.text];
    
    // start checking to see if user enters region
    [self.locationManager startMonitoringForRegion:region];
    
    // send a notification to any observers that a reminder has been added
    [[NSNotificationCenter defaultCenter] postNotificationName:@"ReminderAdded" object:self userInfo:@{@"reminder": region, @"title" : self.userText.text}];
    [self.navigationController popViewControllerAnimated:true];
    
  } // if monitoring is available
  
  // if the user didn't name
}

- (IBAction)addText:(id)sender
{
  // make sure that monitoring is available
  if([CLLocationManager isMonitoringAvailableForClass:[CLCircularRegion class]])
  {
    if (self.userText.text.length == 0)
    {
      self.userText.text = @"Generic Reminder";
    }
    
    // create a 200m-diameter region around the pin
    CLCircularRegion *region = [[CLCircularRegion alloc] initWithCenter:self.annotation.coordinate radius:200 identifier:self.userText.text];
    
    // start checking to see if user enters region
    [self.locationManager startMonitoringForRegion:region];
    
    // send a notification to any observers that a reminder has been added
    [[NSNotificationCenter defaultCenter] postNotificationName:@"ReminderAdded" object:self userInfo:@{@"reminder": region, @"title" : self.userText.text}];
    [self.navigationController popViewControllerAnimated:true];
    
  } // if monitoring is available
  
  // if the user didn't name
} // pressedAddText()

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
