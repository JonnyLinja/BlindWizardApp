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
@class CallNextWaveGameAction;
@class CheckLoseGameAction;
@class ShiftEnemiesLeftGameAction;
@class ShiftEnemiesRightGameAction;
@class DropEnemiesDownGameAction;
@class DestroyEnemyGroupsGameAction;

@interface GameAssembly : TyphoonAssembly <GameDependencyFactory>
@property(nonatomic, strong, readonly) GeneralAssembly *generalAssembly;

- (Game *) game;
- (GameBoard *) gameBoardWithRows:(NSInteger)rows columns:(NSInteger)columns;
- (GameFlow *) gameFlowWithBoard:(GameBoard *)board;
- (CallNextWaveGameAction *) callNextWaveGameActionWithBoard:(GameBoard *)board;
- (CheckLoseGameAction *) checkLoseGameActionWithBoard:(GameBoard *)board;
- (ShiftEnemiesLeftGameAction *) shiftEnemiesLeftGameActionWithBoard:(GameBoard *)board row:(NSInteger)row;
- (ShiftEnemiesRightGameAction *) shiftEnemiesRightGameActionWithBoard:(GameBoard *)board row:(NSInteger)row;
- (DestroyEnemyGroupsGameAction *) destroyEnemyGroupsGameActionWithBoard:(GameBoard *)board;
- (DropEnemiesDownGameAction *) dropEnemiesDownGameActionWithBoard:(GameBoard *)board;

@end
