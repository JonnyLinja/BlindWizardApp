//
//  BoardViewController.m
//  BlindWizardApp
//
//  Created by N A on 6/25/15.
//  Copyright (c) 2015 Adronitis. All rights reserved.
//

#import "BoardViewController.h"
#import "BoardViewModel.h"
#import "GridCalculatorFactory.h"

@interface BoardViewController ()

@end

@implementation BoardViewController

//TODO: one time only check
- (void) viewDidAppear:(BOOL)animated {
    //calculator injection
    NSNumber *width = @(self.view.frame.size.width);
    NSNumber *height = @(self.view.frame.size.height);
    GridCalculator *calculator = [self.calculatorFactory gridCalculatorWithWidth:width height:height];
    self.viewModel.gridCalculator = calculator;
}

- (IBAction)swipedLeft:(UISwipeGestureRecognizer *)sender {
    CGPoint point = [sender locationInView:self.view];
    [self.viewModel swipeLeftFromPoint:point];
}

- (IBAction)swipedRight:(UISwipeGestureRecognizer *)sender {
    CGPoint point = [sender locationInView:self.view];
    [self.viewModel swipeRightFromPoint:point];
}

@end
