//
//  SlideLeftSegue.m
//  BlindWizardApp
//
//  Created by N A on 7/10/15.
//  Copyright (c) 2015 Adronitis. All rights reserved.
//

#import "SlideLeftSegue.h"

@implementation SlideLeftSegue

//not under test
- (void) perform {
    //declare vars
    UIViewController *startVC = self.sourceViewController;
    UIViewController *endVC = self.destinationViewController;
    UIView *startV = startVC.view;
    UIView *endV = endVC.view;
    
    //size
    CGSize screenSize = [UIScreen mainScreen].bounds.size;
    
    //initial frame
    endV.frame = CGRectMake(screenSize.width, 0, screenSize.width, screenSize.height);
    
    //insert
    UIWindow *window = (UIWindow *)startV.superview;
    [window insertSubview:endV aboveSubview:startV];
    
    [UIView animateWithDuration:0.3 animations:^{
        startV.center = CGPointMake(startV.center.x - screenSize.width, startV.center.y);
        endV.center = CGPointMake(endV.center.x - screenSize.width, endV.center.y);
    } completion:^(BOOL finished) {
        [startVC presentViewController:endVC animated:NO completion:nil];
    }];
}

@end
