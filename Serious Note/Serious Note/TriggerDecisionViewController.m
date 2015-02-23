//
//  TriggerDecisionViewController.m
//  Serious Note
//
//  Created by Brian Ledbetter on 2/23/15.
//  Copyright (c) 2015 Brian Ledbetter. All rights reserved.
//

#import "TriggerDecisionViewController.h"

@interface TriggerDecisionViewController ()
@property (strong, nonatomic) UITapGestureRecognizer* tapGestureRecognizer;
@property (strong, nonatomic) UIPanGestureRecognizer* panGestureRecognizer;
@property (weak, nonatomic) IBOutlet UIButton *upButton;
@property (weak, nonatomic) IBOutlet UIButton *downButton;
@property (strong, nonatomic) UIViewController* nextVC;
@property (strong, nonatomic) TimePickerViewController* timePickerVC;
@property (strong, nonatomic) LocationPickerViewController* locationPickerVC;




@end

@implementation TriggerDecisionViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    // set up gesture recogniers
    self.tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(closePanel)];
    self.panGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(slidePanel:)];

    [self.upButton setBackgroundImage: [UIImage imageNamed:@"uparrow"] forState:UIControlStateNormal];
    [self.downButton setBackgroundImage:[UIImage imageNamed:@"downarrow"] forState:UIControlStateNormal];



}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


// pan gesture slides it open/closed depending on direction
-(void)slidePanel:(id)sender {
    //self.panGestureRecognizer = (UIPanGestureRecognizer *) sender;
    CGPoint translatedPoint = [self.panGestureRecognizer translationInView:self.view];
    CGPoint velocity = [self.panGestureRecognizer velocityInView:self.view];
    
    if ([self.panGestureRecognizer state] == UIGestureRecognizerStateChanged) {
        if (velocity.x > 0 || self.nextVC.view.frame.origin.x >0) {
            //set translation
            self.nextVC.view.center = CGPointMake(self.nextVC.view.center.x + translatedPoint.x, self.nextVC.view.center.y);
            [self.panGestureRecognizer setTranslation:CGPointZero inView:self.view];
        }//eo if-velocity
    }//eo if-state changed
    
    // if the pan stops, snap the hamburger either open or closed
    if ([self.panGestureRecognizer state] == UIGestureRecognizerStateEnded) {
        __weak TriggerDecisionViewController *weakSelf = self;
        if (self.nextVC.view.frame.origin.x > self.view.frame.size.width/3) {
            self.upButton.userInteractionEnabled = false;
            self.downButton.userInteractionEnabled = false;

            [UIView animateWithDuration:0.4 animations:^{
                weakSelf.nextVC.view.center = CGPointMake(weakSelf.view.frame.size.width * 1.25, weakSelf.nextVC.view.center.y);
            } completion:^(BOOL finished) {
                [weakSelf.nextVC.view addGestureRecognizer:weakSelf.tapGestureRecognizer];
                
            }];
        }//eo if-they meant to open the hamburger
        else{
            //they meant to close it
            [UIView animateWithDuration:0.2 animations:^{
                weakSelf.nextVC.view.center = weakSelf.view.center;
            } completion:^(BOOL finished) {
                weakSelf.upButton.userInteractionEnabled = true;
                weakSelf.downButton.userInteractionEnabled = true;
            }];
            
            [self.nextVC.view removeGestureRecognizer:self.tapGestureRecognizer];
        }//eo if-they meant to open or close
    }//eo if-state ended
}//eo slidePanel func


//MARK: NAVIGATION  ====================================================================================================================================
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"SHOW_TIME"]){
        self.timePickerVC = segue.destinationViewController;
    }
    
}

//MARK: BUTTON PRESSES ======================================================================================================================================
- (IBAction)upButtonPressed:(id)sender {
    //set the nextVC to TimePicker
    self.nextVC = [[TimePickerViewController alloc] init];

    //add a weakself
    __weak TriggerDecisionViewController *weakSelf = self;
    
    // animate a move over
    [UIView animateWithDuration:.4 animations:^{
        weakSelf.nextVC.view.center = CGPointMake(weakSelf.nextVC.view.center.x + (weakSelf.view.frame.size.width*0.75), weakSelf.nextVC.view.center.y);
        
    } completion:^(BOOL finished) {
        //re-enable the burger when animation is done
        [weakSelf.nextVC.view addGestureRecognizer: weakSelf.tapGestureRecognizer];
    }];
    
    
}

- (IBAction)downButtonPressed:(id)sender {
}


//
//-(UINavigationController *)timePickerVC {
//    if (!_timePickerVC) {
//        _timePickerVC = [self.storyboard instantiateViewControllerWithIdentifier:@"TIME_VC"];
//    }
//    return _timePickerVC;
//}
//
//-(UINavigationController *)locationPickerVC {
//    if (!_locationPickerVC) {
//        _locationPickerVC = [self.storyboard instantiateViewControllerWithIdentifier:@"LOCATION_VC"];
//    }
//    return _timePickerVC;
//}



@end
