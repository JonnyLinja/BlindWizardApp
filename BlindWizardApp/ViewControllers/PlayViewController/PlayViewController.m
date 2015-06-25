//
//  PlayViewController.m
//  BlindWizardApp
//
//  Created by N A on 6/22/15.
//  Copyright (c) 2015 Adronitis. All rights reserved.
//

#import "PlayViewController.h"
#import "PlayViewModel.h"
#import "MTKObserving.h"

@interface PlayViewController ()

@end

@implementation PlayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self map:@keypath(self.viewModel.score) to:@keypath(self.scoreLabel.text) null:@"0 Points"];
}

- (IBAction)nextWave:(id)sender {
    [self.viewModel callNextWave];
}

- (void) dealloc {
    [self removeAllObservations];
}

@end
