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
@class CallNextWaveGameAction;
@class CheckLoseGameAction;
@class ShiftEnemiesLeftGameAction;
@class ShiftEnemiesRightGameAction;
@class DestroyEnemyGroupsGameAction;
@class DropEnemiesDownGameAction;

@protocol GameDependencyFactory <NSObject>
- (GameBoard *) gameBoardWithRows:(NSNumber *)rows columns:(NSNumber *)columns;
- (GameFlow *) gameFlowWithBoard:(GameBoard *)board;
- (CallNextWaveGameAction *) callNextWaveGameActionWithBoard:(GameBoard *)board;
- (CheckLoseGameAction *) checkLoseGameActionWithBoard:(GameBoard *)board;
- (ShiftEnemiesLeftGameAction *) shiftEnemiesLeftGameActionWithBoard:(GameBoard *)board row:(NSNumber *)row;
- (ShiftEnemiesRightGameAction *) shiftEnemiesRightGameActionWithBoard:(GameBoard *)board row:(NSNumber *)row;
- (DestroyEnemyGroupsGameAction *) destroyEnemyGroupsGameActionWithBoard:(GameBoard *)board;
- (DropEnemiesDownGameAction *) dropEnemiesDownGameActionWithBoard:(GameBoard *)board;
@end