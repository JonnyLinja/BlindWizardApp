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
- (id<GameAction>) callNextWaveGameActionWithBoard:(GameBoard *)board;
- (id<GameAction>) checkLoseGameActionWithBoard:(GameBoard *)board;
- (id<GameAction>) shiftEnemiesLeftGameActionWithBoard:(GameBoard *)board row:(NSInteger)row;
- (id<GameAction>) shiftEnemiesRightGameActionWithBoard:(GameBoard *)board row:(NSInteger)row;
- (id<GameAction>) destroyEnemyGroupsGameActionWithBoard:(GameBoard *)board;
- (id<GameAction>) dropEnemiesDownGameActionWithBoard:(GameBoard *)board;

@end
