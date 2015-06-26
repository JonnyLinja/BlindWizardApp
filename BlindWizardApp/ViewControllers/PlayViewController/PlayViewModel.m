//
//  PlayViewModel.m
//  BlindWizardApp
//
//  Created by N A on 6/25/15.
//  Copyright (c) 2015 Adronitis. All rights reserved.
//

#import "PlayViewModel.h"
#import "MTKObserving.h"
#import "Game.h"

@interface PlayViewModel ()
@property (nonatomic, strong) NSString *score;
@end

@implementation PlayViewModel

- (void) setGame:(Game *)game {
    _game = game;
    
    [self removeAllObservations];
    
    [self observeProperty:@keypath(self.game.score) withBlock:
     ^(__weak typeof(self) self, NSNumber *oldScore, NSNumber *newScore) {
         self.score = [NSString stringWithFormat:@"%@ points", [newScore stringValue]];
     }];
}

- (void) callNextWave {
    [self.game callNextWave];
}

- (void) startGame {
    
}

- (void) dealloc {
    [self removeAllObservations];
}

@end
