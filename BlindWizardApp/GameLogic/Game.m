//
//  Game.m
//  BlindWizardApp
//
//  Created by N A on 6/25/15.
//  Copyright (c) 2015 Adronitis. All rights reserved.
//

#import "Game.h"
#import "GameActionFlow.h"
#import "GameBoardLogic.h"

@implementation Game

#pragma mark - Commands

- (void) commandStartGame {
    
}

- (void) commandCallNextWave {
    [self.gameActionFlow commandCallNextWave];
}

- (void) commandSwipeLeftOnRow:(NSInteger)row {
    [self.gameActionFlow commandSwipeLeftOnRow:row];
}

- (void) commandSwipeRightOnRow:(NSInteger)row {
    [self.gameActionFlow commandSwipeRightOnRow:row];
}

#pragma mark - Game Actions

- (void) executeGameActionCallNextWave:(NSNotification *)notification {
    [self.gameBoardLogic executeGameActionCallNextWave];
}

- (void) executeGameActionShiftEnemiesLeft:(NSNotification *)notification {
    NSInteger row = [[notification.userInfo objectForKey:@"row"] integerValue];
    [self.gameBoardLogic executeGameActionShiftEnemiesLeftOnRow:row];
}

- (void) executeGameActionShiftEnemiesRight:(NSNotification *)notification {
    NSInteger row = [[notification.userInfo objectForKey:@"row"] integerValue];
    [self.gameBoardLogic executeGameActionShiftEnemiesRightOnRow:row];
}

- (void) executeGameActionDestroyEnemyGroups:(NSNotification *)notification {
    [self.gameBoardLogic executeGameActionDestroyEnemyGroups];
}

- (void) executeGameActionDropEnemiesDown:(NSNotification *)notification {
    [self.gameBoardLogic executeGameActionDropEnemiesDown];
}

@end
