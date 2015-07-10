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
#import "GridCalculator.h"
#import "TopScores.h"

@interface PlayViewModel ()
@property (nonatomic, assign) BOOL gameInProgress;
@property (nonatomic, strong) NSString *score;
@property (nonatomic, assign) CGFloat boardVisibility;
@end

@implementation PlayViewModel

- (void) setGame:(Game *)game {
    //store
    _game = game;
    
    //reset observations
    [self removeAllObservations];
    
    //score
    [self map:@keypath(self.game.score) to:@keypath(self.score) transform:^NSString *(NSNumber *value) {
        return [NSString stringWithFormat:@"%@ points", [value stringValue]];
    }];
    
    //in progress
    [self map:@keypath(self.game.gameInProgress) to:@keypath(self.gameInProgress) null:@NO];
    [self map:@keypath(self.game.gameInProgress) to:@keypath(self.boardVisibility) transform:^NSNumber *(NSNumber *value) {
        if([value boolValue]) {
            return @1;
        }else {
            return @0.1;
        }
    }];
    [self observeProperty:@keypath(self.game.gameInProgress) withBlock:^(__weak typeof(self) self, NSNumber *old, NSNumber *newValue) {
        if([newValue boolValue] == 0) {
            [self.topScores addScore:game.score];
        }
    }];
}

- (void) callNextWave {
    [self.game commandCallNextWave];
}

- (void) startGame {
    [self.game commandStartGameWithRows:self.calculator.numRows columns:self.calculator.numColumns];
}

- (void) dealloc {
    [self removeAllObservations];
}

@end
