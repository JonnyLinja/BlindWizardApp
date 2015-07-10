//
//  UIViewController+TestSegue.h
//  PentaShiftApp
//
//  Created by N A on 6/10/15.
//  Copyright (c) 2015 N A. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIViewController (TestSegue)
@property (nonatomic, strong) UIViewController *segueDestinationViewController; //doesn't work for unwind
@property (nonatomic, strong) NSString *segueIdentifier; //works for unwind
@end
