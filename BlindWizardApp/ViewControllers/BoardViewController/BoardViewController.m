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
#import "GameObjectFactoryFactory.h"
#import "MTKObserving.h"

@interface BoardViewController ()

@end

@implementation BoardViewController

- (void) viewDidLoad {
    //super
    [super viewDidLoad];
    
    //bind
    [self observeProperty:@keypath(self.viewModel.isActive) withBlock:^(__weak typeof(self) self, NSNumber *old, NSNumber *newVal) {
        if([newVal boolValue]) {
            [self removeAllSubviews];
        }
    }];
}

- (void) removeAllSubviews {
    for(UIView *v in self.view.subviews) {
        [v removeFromSuperview];
    }
}

- (void) viewDidAppear:(BOOL)animated {
    //super
    [super viewDidAppear:animated];

    if (animated) { //hack prevent segue calling this too early, not under test
        //calculator injection
        NSNumber *width = @(self.view.frame.size.width);
        NSNumber *height = @(self.view.frame.size.height);
        GridCalculator *calculator = [self.calculatorFactory gridCalculatorWithWidth:width height:height];
        self.viewModel.gridCalculator = calculator;
        
        //factory injection
        GameObjectFactory *factory = [self.gameObjectFactoryFactory gameObjectFactoryWithView:self.view gridCalculator:calculator];
        self.viewModel.factory = factory;
    }
}

- (IBAction)swipedLeft:(UISwipeGestureRecognizer *)sender {
    CGPoint point = [sender locationInView:self.view];
    [self.viewModel swipeLeftFromPoint:point];
}

- (IBAction)swipedRight:(UISwipeGestureRecognizer *)sender {
    CGPoint point = [sender locationInView:self.view];
    [self.viewModel swipeRightFromPoint:point];
}

- (void) dealloc {
    [self removeAllObservations];
}

@end
