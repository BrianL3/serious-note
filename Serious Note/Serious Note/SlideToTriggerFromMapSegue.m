//
//  SlideToTriggerFromMapSegue.m
//  Serious Note
//
//  Created by Brian Ledbetter on 2/23/15.
//  Copyright (c) 2015 Brian Ledbetter. All rights reserved.
//

#import "SlideToTriggerFromMapSegue.h"

@implementation SlideToTriggerFromMapSegue

-(void)perform{
    LocationPickerViewController* fromVC = self.sourceViewController;
    TriggerDecisionViewController* toVC = self.destinationViewController;
    
    [fromVC.view addSubview:toVC.view];
    
    toVC.view.center = CGPointMake(fromVC.view.center.x, fromVC.view.center.y - fromVC.view.frame.size.height);
    
    /*
     [self addChildViewController:self.searchVC];
     self.searchVC.view.frame = self.view.frame;
     [self.view addSubview:self.searchVC.view];
     [self.searchVC didMoveToParentViewController:self];
     
     */
    
    [UIView animateWithDuration:0.3 animations:^{
        
        //animate a slide up
        toVC.view.center = CGPointMake(fromVC.view.center.x, fromVC.view.center.y);
        
    } completion:^(BOOL finished) {
        [toVC.view removeFromSuperview]; // remove from temp super view
        [fromVC presentViewController:toVC animated:NO completion:NULL]; // present VC
        
    }];
}



@end
