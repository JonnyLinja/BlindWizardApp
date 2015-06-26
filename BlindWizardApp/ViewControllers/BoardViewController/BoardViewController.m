//
//  BoardViewController.m
//  BlindWizardApp
//
//  Created by N A on 6/25/15.
//  Copyright (c) 2015 Adronitis. All rights reserved.
//

#import "BoardViewController.h"
#import "BoardViewModel.h"

@interface BoardViewController ()

@end

@implementation BoardViewController

- (void)viewDidLoad {
    [super viewDidLoad];
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
