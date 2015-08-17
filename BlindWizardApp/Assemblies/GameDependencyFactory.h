//
//  GameDependencyFactory.h
//  BlindWizardApp
//
//  Created by N A on 7/3/15.
//  Copyright (c) 2015 Adronitis. All rights reserved.
//

#import "GameAction.h"

@class GameFlow;
@class GameBoard;
@class LoadInitialEnemiesGameAction;
@class CallNextWaveGameAction;
@class CreateEnemyOutlinesGameAction;
@class CheckLoseGameAction;
@class ShiftEnemiesLeftGameAction;
@class ShiftEnemiesRightGameAction;
@class DestroyEnemyGroupsGameAction;
@class CheckDangerousGameAction;
@class DropEnemiesDownGameAction;
@class DelayGameAction;
@class RepositionEnemyOutlinesGameAction;
@class WaveController;

@protocol GameDependencyFactory <NSObject>
- (GameBoard *) gameBoardWithRows:(NSNumber *)rows columns:(NSNumber *)columns;
- (GameFlow *) gameFlowWithBoard:(GameBoard *)board;
- (LoadInitialEnemiesGameAction *) loadInitialEnemiesGameActionWithBoard:(GameBoard *)board;
- (CallNextWaveGameAction *) callNextWaveGameActionWithBoard:(GameBoard *)board;
- (CreateEnemyOutlinesGameAction *) createEnemyOutlinesGameActionWithBoard:(GameBoard *)board;
- (CheckLoseGameAction *) checkLoseGameActionWithBoard:(GameBoard *)board;
- (ShiftEnemiesLeftGameAction *) shiftEnemiesLeftGameActionWithBoard:(GameBoard *)board row:(NSNumber *)row;
- (ShiftEnemiesRightGameAction *) shiftEnemiesRightGameActionWithBoard:(GameBoard *)board row:(NSNumber *)row;
- (DestroyEnemyGroupsGameAction *) destroyEnemyGroupsGameActionWithBoard:(GameBoard *)board;
- (DropEnemiesDownGameAction *) dropEnemiesDownGameActionWithBoard:(GameBoard *)board;
- (CheckDangerousGameAction *) checkDangerousGameActionWithBoard:(GameBoard *)board;
- (DelayGameAction *) delayGameActionWithDuration:(NSNumber *)duration;
- (RepositionEnemyOutlinesGameAction *) repositionEnemyOutlinesGameActionWithBoard:(GameBoard *)board;
- (WaveController *) waveControllerWithBoard:(GameBoard *)board flow:(GameFlow *)flow;
@end