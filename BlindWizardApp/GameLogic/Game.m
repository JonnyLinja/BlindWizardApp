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

@interface Game ()
@property (nonatomic, assign) BOOL gameInProgress;
@property (nonatomic, strong) GameBoard *board;
@end

@implementation Game

#pragma mark - Commands

- (void) commandStartGameWithRows:(NSInteger)rows columns:(NSInteger)columns {
    self.board = [self.factory createGameBoardWithRows:rows columns:columns];
    self.gameInProgress = YES;
}

- (void) commandCallNextWave {
}

- (void) commandSwipeLeftOnRow:(NSInteger)row {
}

- (void) commandSwipeRightOnRow:(NSInteger)row {
}

@end
