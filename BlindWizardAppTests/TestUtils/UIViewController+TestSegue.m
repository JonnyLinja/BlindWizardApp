//
//  UIViewController+TestSegue.m
//  PentaShiftApp
//
//  Created by N A on 6/10/15.
//  Copyright (c) 2015 N A. All rights reserved.
//

#import "UIViewController+TestSegue.h"
#import <objc/runtime.h>

@implementation UIViewController (TestSegue)

+ (void)load {
    static dispatch_once_t once_token;
    dispatch_once(&once_token,  ^{
        SEL prepForSegueSelector = @selector(prepareForSegue:sender:);
        SEL segueInterceptSelector = @selector(segueInterceptSelectorForSegue:sender:);
        Method originalMethod = class_getInstanceMethod(self, prepForSegueSelector);
        Method extendedMethod = class_getInstanceMethod(self, segueInterceptSelector);
        method_exchangeImplementations(originalMethod, extendedMethod);
        
        SEL shouldPerformSegueSelector = @selector(shouldPerformSegueWithIdentifier:sender:);
        SEL shouldPerformInterceptSelector = @selector(shouldPerformInterceptSelectorForIdentifier:sender:);
        originalMethod = class_getInstanceMethod(self, shouldPerformSegueSelector);
        extendedMethod = class_getInstanceMethod(self, shouldPerformInterceptSelector);
        method_exchangeImplementations(originalMethod, extendedMethod);
    });
}


- (void) segueInterceptSelectorForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    self.segueDestinationViewController = segue.destinationViewController;
    [self segueInterceptSelectorForSegue:segue sender:sender];
}

- (void) setSegueDestinationViewController:(UIViewController *)segueDestinationViewController {
    objc_setAssociatedObject(self, @"SegueDestinationViewController", segueDestinationViewController, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (UIViewController *) segueDestinationViewController {
    return objc_getAssociatedObject(self, @"SegueDestinationViewController");
}


- (BOOL) shouldPerformInterceptSelectorForIdentifier:(NSString *)identifier sender:(id)sender {
    BOOL orig = [self shouldPerformInterceptSelectorForIdentifier:identifier sender:sender];
    if(orig) {
        self.segueIdentifier = identifier;
    }
    return orig;
}

- (void) setSegueIdentifier:(NSString *)segueIdentifier {
    objc_setAssociatedObject(self, @"SegueIdentifier", segueIdentifier, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSString *) segueIdentifier {
    return objc_getAssociatedObject(self, @"SegueIdentifier");
}

@end