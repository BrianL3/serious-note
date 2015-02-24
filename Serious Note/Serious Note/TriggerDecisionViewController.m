//
//  TriggerDecisionViewController.m
//  Serious Note
//
//  Created by Brian Ledbetter on 2/23/15.
//  Copyright (c) 2015 Brian Ledbetter. All rights reserved.
//

#import "TriggerDecisionViewController.h"

@interface TriggerDecisionViewController ()

@property (weak, nonatomic) IBOutlet UIButton *upButton;
@property (weak, nonatomic) IBOutlet UIButton *downButton;
@property (strong, nonatomic) UIViewController* nextVC;
@property (strong, nonatomic) TimePickerViewController* timePickerVC;
@property (strong, nonatomic) LocationPickerViewController* locationPickerVC;




@end

@implementation TriggerDecisionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



//MARK: NAVIGATION  ====================================================================================================================================
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"SHOW_TIME"]){
        self.timePickerVC = segue.destinationViewController;
    }
    if ([segue.identifier isEqualToString:@"SHOW_LOCATION"]) {
        self.locationPickerVC = segue.destinationViewController;
    }
    
    if ([segue.identifier isEqualToString:@"SLIDE_TO_TIME"]) {
        self.timePickerVC = segue.destinationViewController;
    }
    
}

//MARK: BUTTON PRESSES ======================================================================================================================================
- (IBAction)upButtonPressed:(id)sender {
    [self performSegueWithIdentifier:@"SLIDE_TO_TIME" sender:self];
}

- (IBAction)downButtonPressed:(id)sender {
    [self performSegueWithIdentifier:@"SLIDE_TO_MAP" sender:self];

}


//
-(UIViewController *)timePickerVC {
    if (!_timePickerVC) {
        _timePickerVC = [self.storyboard instantiateViewControllerWithIdentifier:@"TIME_VC"];
    }
    return _timePickerVC;
}

-(UIViewController *)locationPickerVC {
    if (!_locationPickerVC) {
        _locationPickerVC = [self.storyboard instantiateViewControllerWithIdentifier:@"LOCATION_VC"];
    }
    return _timePickerVC;
}



@end
