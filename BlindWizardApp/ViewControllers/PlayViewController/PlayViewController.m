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
    //super
    [super viewDidLoad];
    
    //bind
    [self map:@keypath(self.viewModel.score) to:@keypath(self.scoreLabel.text) null:@"0 Points"];
    [self map:@keypath(self.viewModel.gameInProgress) to:@keypath(self.playAgainButton.hidden) null:@YES];
    
    //start
    [self.viewModel startGameWithSize:self.boardView.frame.size];
}

- (IBAction)tappedNextWave:(id)sender {
    [self.viewModel callNextWave];
}

- (IBAction)tappedPlayAgain:(id)sender {
    [self.viewModel startGameWithSize:self.boardView.frame.size];
}

- (void) dealloc {
    [self removeAllObservations];
}

@end
