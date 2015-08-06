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

#import "BoardViewController.h"
#import "BoardViewModel.h"

@interface PlayViewController ()

@end

@implementation PlayViewController

- (void)viewDidLoad {
    //super
    [super viewDidLoad];
    
    //bind
    [self map:@keypath(self.viewModel.score) to:@keypath(self.scoreLabel.text) null:@"0 Points"];
    [self map:@keypath(self.viewModel.boardVisibility) to:@keypath(self.boardView.alpha) null:@1];
}

- (void) viewDidAppear:(BOOL)animated {
    //super
    [super viewDidAppear:animated];
    
    if (animated) { //hack prevent segue calling this too early, not under test
        //inject
        [self injectDependencies];
        
        //hack guarantee start occurs after boardvc view did appear
        //TODO: figure out how to avoid hack, or at least test it properly
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.01 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self startGame];
        });
    }
}

- (void) injectDependencies {
    //calculator injection
    NSNumber *width = @(self.boardView.frame.size.width);
    NSNumber *height = @(self.boardView.frame.size.height);
    GridCalculator *calculator = [self.factory gridCalculatorWithWidth:width height:height];
    self.viewModel.calculator = calculator;
}

- (void) startGame {
    //start
    [self.viewModel startGame];
    
    //map
    [self map:@keypath(self.viewModel.gameInProgress) to:@keypath(self.playAgainButton.hidden) null:@YES];
}

- (IBAction)tappedNextWave:(id)sender {
    [self.viewModel callNextWave];
}

- (IBAction)tappedPlayAgain:(id)sender {
    [self.viewModel startGame];
}

//this is not under test, not sure how to as it crosses multiple "units" and this is really ugly to boot
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    //super - needed for tests
    [super prepareForSegue:segue sender:sender];
    
    //pass game object
    if([segue.identifier isEqualToString:@"BoardViewController"]) {
        BoardViewController *bvc = segue.destinationViewController;
        bvc.viewModel.game = self.viewModel.game;
    }
}

- (void) dealloc {
    [self removeAllObservations];
}

@end
