//
//  AddReminderViewController.m
//  Serious Note
//
//  Created by John Leonard on 2/23/15.
//  Copyright (c) 2015 Brian Ledbetter. All rights reserved.
//

#import "AddReminderViewController.h"

#define METERS_PER_MILE 1609.344

@interface AddReminderViewController () <MKMapViewDelegate, UITextViewDelegate>

@property (strong, nonatomic) NSString *reminderName;
@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (weak, nonatomic) IBOutlet UITextView *textView;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *doneButton;

@end

@implementation AddReminderViewController

- (void)viewDidLoad
{
  [super viewDidLoad];
  
  CLLocationCoordinate2D mapCoord = self.annotation.coordinate;

  MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance (mapCoord, 0.25 * METERS_PER_MILE, 0.25 * METERS_PER_MILE);
  [self.mapView setRegion:region animated:true];
  
  [self.mapView addAnnotation: self.annotation];
  
  NSLog(@"lat: %f, long: %f", mapCoord.latitude, mapCoord.longitude);
  
  [self.textView becomeFirstResponder];
  
} // viewDidLoad()

- (IBAction)addVoice:(id)sender {
  // put code to add voice reminder here
  
  NSLog(@"Add Voice button pressed");
  
} // addVoice()

- (IBAction)doneButtonPressed:(id)sender {
  // make sure that monitoring is available
  if([CLLocationManager isMonitoringAvailableForClass:[CLCircularRegion class]])
  {
    if (self.textView.text.length == 0)
    {
      self.textView.text = @"Generic Reminder";
    }
    
    // create a 200m-diameter region around the pin
    CLCircularRegion *region = [[CLCircularRegion alloc] initWithCenter:self.annotation.coordinate radius:200 identifier:self.textView.text];
    
    // start checking to see if user enters region
    [self.locationManager startMonitoringForRegion:region];
    
    // send a notification to any observers that a reminder has been added
    [[NSNotificationCenter defaultCenter] postNotificationName:@"ReminderAdded" object:self userInfo:@{@"reminder": region, @"title" : self.textView.text}];
    [self.navigationController popViewControllerAnimated:true];
    
  } // if monitoring is available
  
} // pressedAddText()

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

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
  NSString* oldText = self.textView.text;
  NSString* newText = [oldText stringByReplacingCharactersInRange:range withString:string];
  self.doneButton.enabled = (newText.length > 0 || newText.length < 50);
  
  return true;
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
  [self.textView resignFirstResponder];
  
  return true;
}



@end
