//
//  Game.h
//  BlindWizardApp
//
//  Created by N A on 6/25/15.
//  Copyright (c) 2015 Adronitis. All rights reserved.
//

#import <Foundation/Foundation.h>

@class GameActionFlow;
@class GameBoardLogic;

@interface Game : NSObject
@property (nonatomic, strong) GameActionFlow *gameActionFlow; //inject
@property (nonatomic, strong) GameBoardLogic *gameBoardLogic; //inject
@property (nonatomic, assign, readonly) BOOL gameInProgress;
@property (nonatomic, assign, readonly) NSInteger score;

//commands
- (void) commandStartGame;
- (void) commandCallNextWave;
- (void) commandSwipeLeftOnRow:(NSInteger)row;
- (void) commandSwipeRightOnRow:(NSInteger)row;

//game actions
- (void) executeGameActionCallNextWave:(NSNotification *)notification;
- (void) executeGameActionShiftEnemiesLeft:(NSNotification *)notification;
- (void) executeGameActionShiftEnemiesRight:(NSNotification *)notification;
- (void) executeGameActionDestroyEnemyGroups:(NSNotification *)notification;
- (void) executeGameActionDropEnemiesDown:(NSNotification *)notification;
@end
