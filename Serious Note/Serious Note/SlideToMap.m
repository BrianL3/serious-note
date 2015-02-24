//
//  SlideToMap.m
//  Serious Note
//
//  Created by Brian Ledbetter on 2/23/15.
//  Copyright (c) 2015 Brian Ledbetter. All rights reserved.
//

#import "SlideToMap.h"

@implementation SlideToMap


-(void)perform{
    TriggerDecisionViewController* fromVC = self.sourceViewController;
    LocationPickerViewController* toVC = self.destinationViewController;
    
    [fromVC.view addSubview:toVC.view];
    
    toVC.view.center = CGPointMake(fromVC.view.center.x, fromVC.view.center.y + fromVC.view.frame.size.height);
    
    /*
     [self addChildViewController:self.searchVC];
     self.searchVC.view.frame = self.view.frame;
     [self.view addSubview:self.searchVC.view];
     [self.searchVC didMoveToParentViewController:self];
     
     */
    
    [UIView animateWithDuration:0.3 animations:^{
        
        //animate a slide up
        // weakSelf.topVC.view.center = CGPointMake(weakSelf.view.frame.size.width * 1.25, weakSelf.topVC.view.center.y);
        toVC.view.center = CGPointMake(fromVC.view.center.x, fromVC.view.center.y);
    } completion:^(BOOL finished) {
        [toVC.view removeFromSuperview]; // remove from temp super view
        

        [fromVC presentViewController:toVC animated:NO completion:NULL]; // present VC
        
    }];
}


@end
