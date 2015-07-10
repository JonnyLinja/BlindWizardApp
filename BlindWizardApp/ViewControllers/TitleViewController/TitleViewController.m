//
//  TitleViewController.m
//  BlindWizardApp
//
//  Created by N A on 6/22/15.
//  Copyright (c) 2015 Adronitis. All rights reserved.
//

#import "TitleViewController.h"
#import "SlideRightUnwindSegue.h"
#import "SlideDownUnwindSegue.h"

@interface TitleViewController ()

@end

@implementation TitleViewController

- (IBAction)unwindToTitleViewController:(UIStoryboardSegue *)segue {
}

//not under test
- (UIStoryboardSegue *)segueForUnwindingToViewController:(UIViewController *)toViewController fromViewController:(UIViewController *)fromViewController identifier:(NSString *)identifier {
    if([identifier isEqualToString:@"UnwindFromPlayToTitleViewController"]) {
        SlideRightUnwindSegue *segue = [[SlideRightUnwindSegue alloc] initWithIdentifier:identifier source:fromViewController destination:toViewController];
        return segue;
    }
    
    if([identifier isEqualToString:@"UnwindFromLeaderboardToTitleViewController"]) {
        SlideDownUnwindSegue *segue = [[SlideDownUnwindSegue alloc] initWithIdentifier:identifier source:fromViewController destination:toViewController];
        return segue;
    }
    
    return [super segueForUnwindingToViewController:toViewController fromViewController:fromViewController identifier:identifier];
}

@end
