//
//  LocationPickerViewController.m
//  Serious Note
//
//  Created by Brian Ledbetter on 2/23/15.
//  Copyright (c) 2015 Brian Ledbetter. All rights reserved.
//

#import "LocationPickerViewController.h"
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>
#import "AddReminderViewController.h"

@interface LocationPickerViewController () <CLLocationManagerDelegate, MKMapViewDelegate>
@property (weak, nonatomic) IBOutlet MKMapView *mapView;

@property (strong, nonatomic) MKPointAnnotation *selectedAnnotation;

@end

@implementation LocationPickerViewController

- (void)viewDidLoad
{
  [super viewDidLoad];
  
  
  CLLocationCoordinate2D workCoordinate = CLLocationCoordinate2DMake(47.6235481, -122.336212); // Code Fellows location
  
  MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance (workCoordinate, 1.0 * METERS_PER_MILE, 1.0 *METERS_PER_MILE);
  [self.mapView setRegion:region animated:true];
  
  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reminderAdded:) name:@"ReminderAdded" object:nil];
  
  //MARK: location-related code
  self.locationManager =[CLLocationManager new];
  self.locationManager.delegate = self;
  self.mapView.delegate = self;
  
  
  // check to see if location services are enabled
  if ([CLLocationManager locationServicesEnabled])
  {
    // check to see if using location services is authorized
    if ([CLLocationManager authorizationStatus] == 0) // not authorized
    {
      // request authorization
      [self.locationManager requestWhenInUseAuthorization];
    } // if not authorized
    else if ([CLLocationManager authorizationStatus] >= 3) // we are authorized
    {
      self.mapView.showsUserLocation = true;
      [self.locationManager startMonitoringSignificantLocationChanges];
    } // we're authorized
    else
    {
      // TODO: Add error-handling code here for states 1 and 2 (restricted or denied)
    } // error
  } // if location services enabled
  
  UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(mapLongPressed:)];
  
  [self.mapView addGestureRecognizer:longPress];
  
} // viewDidLoad()


- (void) mapLongPressed:(id) sender
{
  UILongPressGestureRecognizer *longPress = (UILongPressGestureRecognizer *)sender;
  
  if (longPress.state == 3) // 3 == press finished
  {
    // get x,y view coordinates that were pressed
    CGPoint location = [longPress locationInView:self.mapView];
    
    // convert from view's (x,y) to map's (lat,long)
    CLLocationCoordinate2D coordinates = [self.mapView convertPoint:location toCoordinateFromView:self.mapView];
    
    // create the annotation to mark the point on the map
    MKPointAnnotation *annotation = [MKPointAnnotation new];
    annotation.coordinate = coordinates;
    annotation.title = @"New Point of Interest";
    [self.mapView addAnnotation: annotation];
  } // if press finished
}// if longPress ended

// log changes in authorization status
- (void) locationManager: (CLLocationManager *) manager didChangeAuthorizationStatus: (CLAuthorizationStatus) status
{  
  // if we're moving to authorized status show the user's location on the map
  if ((status == 3) || (status == 4)) // the various authorized statuses are 3 and 4
  {
    self.mapView.showsUserLocation = true; // show the user location
  }
  
} // locationManager()

// log changes in location
- (void) locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
  // get the first element in the location array
  CLLocation *location = locations.firstObject;
  
  // we'll just log it for now
  NSLog(@"latitude: %f and longitude: %f", location.coordinate.latitude, location.coordinate.longitude);
} // locationManager()

// set up the pin as an annotation view
-(MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation
{
  MKPinAnnotationView *annotationView = [[MKPinAnnotationView alloc]initWithAnnotation:annotation reuseIdentifier:@"ANNOTATION_VIEW"];
  
  // set some of the pin's properties
  annotationView.animatesDrop = true;
  annotationView.pinColor = MKPinAnnotationColorGreen;
  
  // show the annotation's data when press on the pin's head
  annotationView.canShowCallout = true;
  
  // create a button that will display a new view for the location's reminder when pressed
  annotationView.rightCalloutAccessoryView = [UIButton buttonWithType:UIButtonTypeContactAdd];
  
  return annotationView;
} // mapView()

- (void) mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control
{
  // perform the segue to the reminder detail view
  self.selectedAnnotation = view.annotation;
  [self performSegueWithIdentifier:@"SHOW_DETAIL" sender:self];
} // mapView()

- (void) locationManager:(CLLocationManager *)manager didEnterRegion:(CLRegion *)region
{
  NSLog(@"did enter region");
  
  UILocalNotification *localNotification = [UILocalNotification new];
  localNotification.alertBody = @"region entered";
  localNotification.alertAction = @"region action";
  
  [[UIApplication sharedApplication] presentLocalNotificationNow:localNotification];
} // didEnterRegion

// handle the reminderAdded notification
- (void) reminderAdded:(NSNotification *) notification
{
  NSLog(@"reminder notification");
  
  // put a circular overlay over the region on the map
  
  // define the overlay
  NSDictionary *userInfo = notification.userInfo;
  
  // make the annotation title match the reminder
  self.selectedAnnotation.title = userInfo[@"title"];
  
  CLCircularRegion * region = userInfo[@"reminder"];
  MKCircle *circleOverlay = [MKCircle circleWithCenterCoordinate:region.center radius:region.radius];
  
  // add the overlay
  [self.mapView addOverlay:circleOverlay];
} // reminderAdded()

// set circular overlay properties
- (MKOverlayRenderer *) mapView:(MKMapView *)mapView rendererForOverlay:(id<MKOverlay>)overlay
{
  MKCircleRenderer *circleRenderer = [[MKCircleRenderer alloc] initWithOverlay:overlay];
  circleRenderer.fillColor = [UIColor lightGrayColor];
  circleRenderer.strokeColor = [UIColor redColor];
  circleRenderer.alpha = 0.3; // want to be able to see the map underneath
  
  return circleRenderer;
} // CircleRenderer

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
  if ([segue.identifier isEqualToString:@"SHOW_DETAIL"])
  {
    AddReminderViewController *addReminderVC = (AddReminderViewController *)segue.destinationViewController;
    addReminderVC.annotation = self.selectedAnnotation;
    addReminderVC.locationManager = self.locationManager;
  } // if SHOW_DETAIL
} // prepareForSegue()

// remove ourselves as a notification observer last thing before terminating
- (void)dealloc
{
  [[NSNotificationCenter defaultCenter] removeObserver:self];
} // dealloc

@end
