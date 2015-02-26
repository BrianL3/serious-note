 //
//  AddReminderViewController.m
//  Serious Note
//
//  Created by John Leonard on 2/23/15.
//  Copyright (c) 2015 Brian Ledbetter. All rights reserved.
//

#import "AddReminderViewController.h"
#import "RecorderViewController.h"
#import "RecipientSelectionViewController.h"

#define METERS_PER_MILE 1609.344

@interface AddReminderViewController () <MKMapViewDelegate, UITextFieldDelegate>

@property (strong, nonatomic) NSString *reminderName;
@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *doneButton;
@property (weak, nonatomic) IBOutlet UITextField *textField;
@property (nonatomic) BOOL hasAudio;
@property (strong, nonatomic) NSURL *audioFileLocation;
@property (strong, nonatomic) NSData *audioData;
@property (strong, nonatomic) Reminder *myReminder;

@end

@implementation AddReminderViewController

- (void)viewDidLoad
{
  [super viewDidLoad];
  
  CLLocationCoordinate2D mapCoord = self.annotation.coordinate;

  MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance (mapCoord, 0.25 * METERS_PER_MILE, 0.25 * METERS_PER_MILE);
  [self.mapView setRegion:region animated:true];
  
  [self.mapView addAnnotation: self.annotation];
  
  //NSLog(@"lat: %f, long: %f", mapCoord.latitude, mapCoord.longitude);
  
  // set up textView stuff
  self.doneButton.enabled = false;
  self.textField.delegate = self;
  [self.textField becomeFirstResponder];
  
} // viewDidLoad()

- (IBAction)addVoice:(id)sender {
  // put code to add voice reminder here
  
  NSLog(@"Add Voice button pressed");
  self.doneButton.enabled = true;
  
} // addVoice()

// set up the pin as an annotation view
-(MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation
{
  MKPinAnnotationView *annotationView = [[MKPinAnnotationView alloc]initWithAnnotation:annotation reuseIdentifier:@"LOCAL_ANNOTATION_VIEW"];
  
  // set some of the pin's properties
  annotationView.animatesDrop = true;
  annotationView.pinColor = MKPinAnnotationColorGreen;
  
  // show the annotation's data when press on the pin's head
  annotationView.canShowCallout = false;
  
  return annotationView;
} // mapView()

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
  
  if (range.length + range.location > textField.text.length)
  {
    self.doneButton.enabled = false;
    return false;
  }
  
  NSUInteger newLength = textField.text.length + (string.length - range.length);
  if (newLength <= 50) {
    self.doneButton.enabled = true;
  }
  
  else // length limit exceeded - let user know
  {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Text Length Exceeded" message:@"Text is limitd to 50 characters" delegate:self cancelButtonTitle:@"OK"
      otherButtonTitles:nil];
    [alert show];
  }
  
  return (newLength > 50) ? false : true;
  
} // shouldChangeCharactersInRange

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
  [self.textField resignFirstResponder];
  return true;
} // textFieldShouldReturn()

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
  if ([segue.identifier isEqualToString:@"MAP_TO_RECORD"]){
    RecorderViewController *modalVC = [[RecorderViewController alloc] init];
    modalVC = segue.destinationViewController;
    // completion block instead of delegate pattern
    modalVC.audioSet = ^(NSURL *response) {
      self.hasAudio = true;
      self.audioFileLocation = response;
      if(self.audioFileLocation){
        NSError * __autoreleasing tmpError;
        
        self.audioData = [[NSData alloc] initWithContentsOfURL:self.audioFileLocation options: NSDataReadingMapped error:&tmpError];
        //   audioData = [[NSData alloc] initWithContentsOfURL:self.audioFileLocation];
        if (tmpError) {
          NSLog(@"%@", tmpError.localizedDescription);
        }
      }
      
      NSLog(@"the audio was properly set to following filepath:%@", response);
    };
  } // segue MAP_TO_RECORD
  
  if ([segue.identifier isEqualToString:@"LOCATION_CHOOSE_RECIPIENT"])
  {
    // make sure that monitoring is available
    if([CLLocationManager isMonitoringAvailableForClass:[CLCircularRegion class]])
    {
      if (self.textField.text.length == 0)
      {
        // create a unique string to use as a title by appending the last 5 digits of the time to the word "Generic"
        NSDate* currentTime = [NSDate date];
        int CurrTime = currentTime.timeIntervalSinceReferenceDate;
        NSString *addOn = [NSString stringWithFormat:@"Genric%d", CurrTime % 100000]; // get the last 5 digits
        self.textField.text = addOn;
      }
      
      // create a 200m-diameter region around the pin
      CLCircularRegion *region = [[CLCircularRegion alloc] initWithCenter:self.annotation.coordinate radius:200 identifier:self.textField.text];
      
      // start checking to see if user enters region
      [self.locationManager startMonitoringForRegion:region];
      
      // send a notification to any observers that a reminder has been added
      [[NSNotificationCenter defaultCenter] postNotificationName:@"ReminderAdded" object:self userInfo:@{@"reminder": region, @"title" : self.textField.text}];
    } // add region to monitored regions
    
    // segue to the Recipient Selection VC, push reminder
    
    RecipientSelectionViewController* destinationVC = [[RecipientSelectionViewController alloc] init];
    destinationVC = segue.destinationViewController;
    
    // at what location will the reminder be triggered?
    CLLocation *reminderLocation = [[CLLocation alloc] initWithLatitude:self.annotation.coordinate.latitude longitude:self.annotation.coordinate.longitude];
    
    if (self.textField.text.length > 0 && ![self.textField.text isEqualToString:@"Generic Reminder"]) // reminder contains text
    {
      self.myReminder = [[Reminder alloc] initWithLocation: reminderLocation withText:self.annotation.title withAudio:nil withVideo:nil];
    }
    
    else
    {
      // NSLog(@"created an audio reminder: %@", audioData.description);
      self.myReminder = [[Reminder alloc] initWithLocation: reminderLocation withText:nil withAudio:(NSData*)self.audioData withVideo:nil];
    }
    destinationVC.selectedReminder = self.myReminder;
    
  } // segue LOCATION_CHOOSE_RECIPIENT

}

@end
