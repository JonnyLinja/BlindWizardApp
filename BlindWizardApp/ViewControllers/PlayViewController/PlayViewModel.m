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
@property (nonatomic, assign) BOOL gameInProgress;
@property (nonatomic, strong) NSString *score;
@end

@implementation PlayViewModel

- (void) setGame:(Game *)game {
    //store
    _game = game;
    
    //reset observations
    [self removeAllObservations];
    
    //score
    [self observeProperty:@keypath(self.game.score) withBlock:
     ^(__weak typeof(self) self, NSNumber *oldScore, NSNumber *newScore) {
         self.score = [NSString stringWithFormat:@"%@ points", [newScore stringValue]];
     }];
    
    //in progress
    [self map:@keypath(self.game.gameInProgress) to:@keypath(self.gameInProgress) null:@NO];
}

- (void) callNextWave {
    [self.game callNextWave];
}

- (void) startGame {
    [self.game startGame];
}

- (void) dealloc {
    [self removeAllObservations];
}

@end
