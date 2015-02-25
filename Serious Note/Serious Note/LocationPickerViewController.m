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
  self.mapView.rotateEnabled = false; // don't spin the map when you rotate the phone
  
   if ([CLLocationManager locationServicesEnabled]) {
    //NSString* returnString = [_myStack lastObject];
    NSInteger authorizationNumber = [CLLocationManager authorizationStatus];
    // begin switch through location manager's auth statuses
    //NSLog(@"The Auth Number is : %ld", (long)authorizationNumber);
    switch (authorizationNumber) {
      case 0:
        // Status 0 is Not Determined
        [self.locationManager requestAlwaysAuthorization];
        NSLog(@"Hit Status 0 in Authorization switch");
        break;
      case 1:
        // Status 1 is Restricted
        NSLog(@"Hit Status 1 in Authorization switch");
        break;
      case 2:
        // Status 2 is Denied
        NSLog(@"Location Sevices Authorization denied.");
        break;
      case 3:
        // Status 3 is Authorized
        self.mapView.showsUserLocation = true;
        [self.locationManager startUpdatingLocation];
        break;
      case 4:
        // Status 4 is Always Authorized
        self.mapView.showsUserLocation = true;
        // for very fine, data heavy, specific location data
        [self.locationManager startUpdatingLocation];
        // for less fine (based off wifi) location data [but less battery heavy]
        //[self.locationManager startMonitoringSignificantLocationChanges];
        // for monitoring region changes
        //[self.locationManager startMonitoringForRegion:<#(CLRegion *)#>]
        break;
      default:
        NSLog(@"Hit default case in AuthNumber switch");
        break;
    }
  } else {
    // pop an alert warning user that location services are not enabled
  }
    
  UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(mapLongPressed:)];
  
  [self.mapView addGestureRecognizer:longPress];
  
} // viewDidLoad()

- (void)viewWillAppear:(BOOL)animated
{
  [super viewWillAppear:animated];
  
  NSArray *monitoredRegions = [self.locationManager.monitoredRegions allObjects];
  NSLog(@"Number of monitored regions: %lu", (unsigned long)monitoredRegions.count);

} // viewWilAppear()


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
  if ([annotation isEqual:[mapView userLocation]]){
    return nil;
  }
  
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
