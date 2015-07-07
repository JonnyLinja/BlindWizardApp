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
#import "GridCalculatorFactory.h"

@interface PlayViewController ()

@end

@implementation PlayViewController

- (void)viewDidLoad {
    //super
    [super viewDidLoad];
    
    //bind
    [self map:@keypath(self.viewModel.score) to:@keypath(self.scoreLabel.text) null:@"0 Points"];
    [self map:@keypath(self.viewModel.gameInProgress) to:@keypath(self.playAgainButton.hidden) null:@YES];
}

//TODO: one time only check
- (void) viewDidAppear:(BOOL)animated {
    //calculator injection
    NSNumber *width = @(self.boardView.frame.size.width);
    NSNumber *height = @(self.boardView.frame.size.height);
    GridCalculator *calculator = [self.factory gridCalculatorWithWidth:width height:height];
    self.viewModel.calculator = calculator;
    
    //start
    [self.viewModel startGame];
}

- (IBAction)tappedNextWave:(id)sender {
    [self.viewModel callNextWave];
}

- (IBAction)tappedPlayAgain:(id)sender {
    [self.viewModel startGame];
}

- (void) dealloc {
    [self removeAllObservations];
}

@end
