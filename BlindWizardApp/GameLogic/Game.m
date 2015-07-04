//
//  Game.m
//  BlindWizardApp
//
//  Created by N A on 6/25/15.
//  Copyright (c) 2015 Adronitis. All rights reserved.
//

#import "Game.h"
#import "GameConstants.h"
#import "GameActionFlow.h"
#import "GameBoardLogic.h"

@implementation Game

- (id) init {
    self = [super init];
    if(!self) return nil;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(executeGameActionCallNextWave:) name:GameActionCallNextWave object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(executeGameActionShiftEnemiesLeft:) name:GameActionShiftEnemiesLeft object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(executeGameActionShiftEnemiesRight:) name:GameActionShiftEnemiesRight object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(executeGameActionDestroyEnemyGroups:) name:GameActionDestroyEnemyGroups object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(executeGameActionDropEnemiesDown:) name:GameActionDropEnemiesDown object:nil];
    
    return self;
}

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

#pragma mark - Dealloc

- (void) dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
