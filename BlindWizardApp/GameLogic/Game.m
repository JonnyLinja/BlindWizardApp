//
//  Game.m
//  BlindWizardApp
//
//  Created by N A on 6/25/15.
//  Copyright (c) 2015 Adronitis. All rights reserved.
//

#import "Game.h"
#import "GameDependencyFactory.h"
#import "GameBoard.h"
#import "GameFlow.h"
#import "MTKObserving.h"
#import "CallNextWaveGameAction.h"
#import "ShiftEnemiesLeftGameAction.h"
#import "ShiftEnemiesRightGameAction.h"

@interface Game ()
@property (nonatomic, strong) id<GameDependencyFactory> factory; //inject
@property (nonatomic, strong) GameFlow *flow; //inject
@property (nonatomic, assign) NSInteger score;
@property (nonatomic, assign) BOOL gameInProgress;
@property (nonatomic, strong) GameBoard *board;
@end

@implementation Game

- (id) initWithDependencyFactory:(id<GameDependencyFactory>)factory {
    self = [super init];
    if(!self) return nil;
    
    self.factory = factory;
    
    return self;
}

- (void) commandStartGameWithRows:(NSInteger)rows columns:(NSInteger)columns {
    [self removeAllObservations];
    
    self.board = [self.factory gameBoardWithRows:rows columns:columns];
    self.flow = [self.factory gameFlowWithBoard:self.board];
    
    [self map:@keypath(self.board.score) to:@keypath(self.score) null:@0];
    [self map:@keypath(self.board.isActive) to:@keypath(self.gameInProgress) null:@NO];
}

- (void) commandCallNextWave {
    id<GameAction> action = [self.factory callNextWaveGameActionWithBoard:self.board];
    [self.flow addGameAction:action];
}

- (void) commandSwipeLeftOnRow:(NSInteger)row {
    id<GameAction> action = [self.factory shiftEnemiesLeftGameActionWithBoard:self.board row:row];
    [self.flow addGameAction:action];
}

- (void) commandSwipeRightOnRow:(NSInteger)row {
    id<GameAction> action = [self.factory shiftEnemiesRightGameActionWithBoard:self.board row:row];
    [self.flow addGameAction:action];
}

- (void) dealloc {
    [self removeAllObservations];
}

@end
