//
//  SlideDownUnwindSegue.m
//  BlindWizardApp
//
//  Created by N A on 7/10/15.
//  Copyright (c) 2015 Adronitis. All rights reserved.
//

#import "SlideDownUnwindSegue.h"

@implementation SlideDownUnwindSegue

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
    endV.frame = CGRectMake(0, -screenSize.height, screenSize.width, screenSize.height);
    
    //insert
    UIWindow *window = (UIWindow *)startV.superview;
    [window insertSubview:endV aboveSubview:startV];
    
    [UIView animateWithDuration:0.3 animations:^{
        startV.center = CGPointMake(startV.center.x, startV.center.y + screenSize.height);
        endV.center = CGPointMake(endV.center.x, endV.center.y + screenSize.height);
    } completion:^(BOOL finished) {
        [startVC dismissViewControllerAnimated:NO completion:nil];
    }];
}

@end
