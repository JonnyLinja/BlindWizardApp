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

@implementation EnemyView

- (void) setViewModel:(EnemyViewModel *)viewModel {
    _viewModel = viewModel;
    
    [self removeAllObservations];
    [self observeProperty:@keypath(self.viewModel.animationType) withSelector:@selector(runAnimation)];
}

- (void) runAnimation {
    switch (self.viewModel.animationType) {
        case CreateAnimation:
            [self runCreateAnimation];
            break;
            
        default:
            break;
    }
}

- (void) runCreateAnimation {
    self.alpha = 0;
    [UIView animateWithDuration:0.1 animations:^{
        self.alpha = 1;
    }];
}

- (void) dealloc {
    [self removeAllObservations];
}

@end
