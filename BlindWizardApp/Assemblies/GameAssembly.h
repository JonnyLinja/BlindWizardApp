//
//  GameAssembly.h
//  BlindWizardApp
//
//  Created by N A on 7/6/15.
//  Copyright (c) 2015 Adronitis. All rights reserved.
//

#import "TyphoonAssembly.h"
#import "GameDependencyFactory.h"

@class GeneralAssembly;

@class Game;
@class GameBoard;
@class GameFlow;
@class LoadInitialEnemiesGameAction;
@class CallNextWaveGameAction;
@class CheckLoseGameAction;
@class ShiftEnemiesLeftGameAction;
@class ShiftEnemiesRightGameAction;
@class DropEnemiesDownGameAction;
@class DestroyEnemyGroupsGameAction;
@class CheckDangerousGameAction;
@class WaveController;
@class ScoreCalculator;

@interface GameAssembly : TyphoonAssembly <GameDependencyFactory>
@property(nonatomic, strong, readonly) GeneralAssembly *generalAssembly;

- (Game *) game;
- (GameBoard *) gameBoardWithRows:(NSNumber *)rows columns:(NSNumber *)columns;
- (GameFlow *) gameFlowWithBoard:(GameBoard *)board;
- (LoadInitialEnemiesGameAction *) loadInitialEnemiesGameActionWithBoard:(GameBoard *)board;
- (CallNextWaveGameAction *) callNextWaveGameActionWithBoard:(GameBoard *)board;
- (CheckLoseGameAction *) checkLoseGameActionWithBoard:(GameBoard *)board;
- (ShiftEnemiesLeftGameAction *) shiftEnemiesLeftGameActionWithBoard:(GameBoard *)board row:(NSNumber *)row;
- (ShiftEnemiesRightGameAction *) shiftEnemiesRightGameActionWithBoard:(GameBoard *)board row:(NSNumber *)row;
- (DestroyEnemyGroupsGameAction *) destroyEnemyGroupsGameActionWithBoard:(GameBoard *)board;
- (DropEnemiesDownGameAction *) dropEnemiesDownGameActionWithBoard:(GameBoard *)board;
- (CheckDangerousGameAction *) checkDangerousGameActionWithBoard:(GameBoard *)board;
- (WaveController *) waveControllerWithBoard:(GameBoard *)board flow:(GameFlow *)flow;
- (DelayGameAction *) delayGameActionWithDuration:(NSNumber *)duration;
- (ScoreCalculator *) scoreCalculator;

@end
