//
//  SlideToTimeSegue.m
//  Serious Note
//
//  Created by Brian Ledbetter on 2/23/15.
//  Copyright (c) 2015 Brian Ledbetter. All rights reserved.
//

#import "SlideToTimeSegue.h"

@implementation SlideToTimeSegue

-(void)perform{
    TriggerDecisionViewController* fromVC = self.sourceViewController;
    TimePickerViewController* toVC = self.destinationViewController;
    
    [fromVC.view addSubview:toVC.view];


    [UIView animateWithDuration:0.4 animations:^{

        //animate a slide up
        
    } completion:^(BOOL finished) {
        [toVC.view removeFromSuperview]; // remove from temp super view
        [fromVC presentViewController:toVC animated:NO completion:NULL]; // present VC

    }];
    
    
    /*

     
     
     UIViewController *sourceViewController = self.sourceViewController;
     UIViewController *destinationViewController = self.destinationViewController;
     
     // Add the destination view as a subview, temporarily
     [sourceViewController.view addSubview:destinationViewController.view];
     
     // Transformation start scale
     destinationViewController.view.transform = CGAffineTransformMakeScale(0.05, 0.05);
     
     // Store original centre point of the destination view
     CGPoint originalCenter = destinationViewController.view.center;
     // Set center to start point of the button
     destinationViewController.view.center = self.originatingPoint;
     
     [UIView animateWithDuration:0.5
     delay:0.0
     options:UIViewAnimationOptionCurveEaseInOut
     animations:^{
     // Grow!
     destinationViewController.view.transform = CGAffineTransformMakeScale(1.0, 1.0);
     destinationViewController.view.center = originalCenter;
     }
     completion:^(BOOL finished){
     [destinationViewController.view removeFromSuperview]; // remove from temp super view
     [sourceViewController presentViewController:destinationViewController animated:NO completion:NULL]; // present VC
     }];

     
     */
}

@end
