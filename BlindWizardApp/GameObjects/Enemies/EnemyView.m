//
//  EnemyView.m
//  BlindWizardApp
//
//  Created by N A on 6/26/15.
//  Copyright (c) 2015 Adronitis. All rights reserved.
//

#import "EnemyView.h"
#import "EnemyViewModel.h"
#import "MTKObserving.h"

@interface EnemyView ()
@property (nonatomic, strong) EnemyViewModel *viewModel; //inject
@end

@implementation EnemyView

- (id) initWithViewModel:(EnemyViewModel *)viewModel {
    self = [super init];
    if(!self) return nil;
    
    //vm
    self.viewModel = viewModel;
    
    //bind
    [self removeAllObservations];
    [self observeProperty:@keypath(self.viewModel.animationType) withSelector:@selector(runAnimation)];
    
    //view
    self.backgroundColor = [UIColor clearColor];
    self.layer.borderColor = [self.viewModel color].CGColor;
    self.layer.borderWidth = 5;
    self.layer.anchorPoint = CGPointMake(0.5, 0.5);
    
    return self;
}

- (void) runAnimation {
    //run
    switch (self.viewModel.animationType) {
        case CreateAnimation:
            [self runCreateAnimation];
            break;
        case MoveAnimation:
            [self runMoveAnimation];
            break;
        case MoveAndSnapAnimation:
            [self runMoveAndSnapAnimation];
            break;
        case MoveAndRemoveAnimation:
            [self runMoveAndRemoveAnimation];
            break;
        case DestroyAndRemoveAnimation:
            [self destroyAndRemoveAnimation];
            break;
        default:
            break;
    }
    
    //reset
    self.viewModel.animationType = NoAnimation;
}

- (void) runCreateAnimation {
    self.alpha = 0;
    [UIView animateWithDuration:2 animations:^{
        self.alpha = 1;
    }];
}

- (void) runMoveAnimation {
    self.backgroundColor = self.viewModel.color;
    [UIView animateWithDuration:self.viewModel.moveDuration animations:^{
        self.frame = CGRectMake(self.viewModel.movePoint.x, self.viewModel.movePoint.y, self.bounds.size.width, self.bounds.size.height);
    }completion:^(BOOL finished) {
        self.backgroundColor = [UIColor clearColor];
    }];
}

- (void) runMoveAndSnapAnimation {
    self.backgroundColor = self.viewModel.color;
    [UIView animateWithDuration:self.viewModel.moveDuration animations:^{
        self.frame = CGRectMake(self.viewModel.movePoint.x, self.viewModel.movePoint.y, self.bounds.size.width, self.bounds.size.height);
    }completion:^(BOOL finished) {
        self.backgroundColor = [UIColor clearColor];
        self.frame = CGRectMake(self.viewModel.snapPoint.x, self.viewModel.snapPoint.y, self.bounds.size.width, self.bounds.size.height);
    }];
}

- (void) runMoveAndRemoveAnimation {
    self.backgroundColor = self.viewModel.color;
    [UIView animateWithDuration:self.viewModel.moveDuration animations:^{
        self.frame = CGRectMake(self.viewModel.movePoint.x, self.viewModel.movePoint.y, self.bounds.size.width, self.bounds.size.height);
    }completion:^(BOOL finished) {
        self.backgroundColor = [UIColor clearColor];
        [self removeFromSuperview];
    }];
}

- (void) destroyAndRemoveAnimation {
    [self.superview sendSubviewToBack:self];
    [UIView animateWithDuration:2 animations:^{
        self.transform = CGAffineTransformMakeScale(0.05, 0.05);
    }completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

- (void) dealloc {
    [self removeAllObservations];
}

@end
