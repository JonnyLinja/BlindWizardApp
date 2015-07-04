//
//  Game.m
//  BlindWizardApp
//
//  Created by N A on 6/25/15.
//  Copyright (c) 2015 Adronitis. All rights reserved.
//

#import "Game.h"
#import "GameBoard.h"
#import "GameActionFlow.h"
#import "MTKObserving.h"

@interface Game ()
@property (nonatomic, assign) NSInteger score;
@property (nonatomic, assign) BOOL gameInProgress;
@property (nonatomic, strong) GameBoard *board;
@end

@implementation Game
/*
- (id) init {
    self = [super init];
    if(!self) return nil;
    
    [self map:@keypath(self.board.score) to:@keypath(self.score) null:@0];
    [self map:@keypath(self.board.isActive) to:@keypath(self.gameInProgress) null:@NO];
    
    return self;
}
*/
//TODO: confirm if board needs to be set before the map is called
//if it doesn't, use init
//if it does, use the board override

- (void) setBoard:(GameBoard *)board {
    [self removeAllObservations];

    _board = board;
    
    [self map:@keypath(self.board.score) to:@keypath(self.score) null:@0];
    [self map:@keypath(self.board.isActive) to:@keypath(self.gameInProgress) null:@NO];
}

- (void) commandStartGameWithRows:(NSInteger)rows columns:(NSInteger)columns {
    self.board = [self.factory createGameBoardWithRows:rows columns:columns];
}

- (void) commandCallNextWave {
    GameAction *action = [self.factory createCallNextWaveGameActionWithBoard:self.board];
    [self.flow addGameAction:action];
}

- (void) commandSwipeLeftOnRow:(NSInteger)row {
}

- (void) commandSwipeRightOnRow:(NSInteger)row {
}

- (void) dealloc {
    [self removeAllObservations];
}

@end
