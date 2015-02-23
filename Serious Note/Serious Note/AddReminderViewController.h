//
//  AddReminderViewController.h
//  Serious Note
//
//  Created by John Leonard on 2/23/15.
//  Copyright (c) 2015 Brian Ledbetter. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>

@interface AddReminderViewController : UIViewController

@property (strong, nonatomic) MKPointAnnotation *annotation;
@property (strong, nonatomic) CLLocationManager *locationManager;

@end
