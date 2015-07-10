//
//  LeaderboardViewController.m
//  BlindWizardApp
//
//  Created by N A on 6/22/15.
//  Copyright (c) 2015 Adronitis. All rights reserved.
//

#import "LeaderboardViewController.h"
#import "MTKObserving.h"
#import "LeaderboardViewModel.h"

@interface LeaderboardViewController ()

@end

@implementation LeaderboardViewController

- (void)viewDidLoad {
    //super
    [super viewDidLoad];
    
    //bind
    [self map:@keypath(self.viewModel.listOfTopScores) to:@keypath(self.displayLabel.text) null:@""];
}

- (void) dealloc {
    [self removeAllObservations];
}

@end
