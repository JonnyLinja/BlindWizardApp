//
//  GameDependencyFactory.h
//  BlindWizardApp
//
//  Created by N A on 7/3/15.
//  Copyright (c) 2015 Adronitis. All rights reserved.
//

#import "GameAction.h"

@protocol GameAction;
@class GameFlow;
@class GameBoard;

@protocol GameDependencyFactory <NSObject>
- (GameBoard *) gameBoardWithRows:(NSInteger)rows columns:(NSInteger)columns;
- (GameFlow *) gameFlowWithBoard:(GameBoard *)board;
- (id<GameAction>) callNextWaveGameActionWithBoard:(GameBoard *)board;
- (id<GameAction>) checkLoseGameActionWithBoard:(GameBoard *)board;
- (id<GameAction>) shiftEnemiesLeftGameActionWithBoard:(GameBoard *)board row:(NSInteger)row;
- (id<GameAction>) shiftEnemiesRightGameActionWithBoard:(GameBoard *)board row:(NSInteger)row;
- (id<GameAction>) destroyEnemyGroupsGameActionWithBoard:(GameBoard *)board;
- (id<GameAction>) dropEnemiesDownGameActionWithBoard:(GameBoard *)board;
@end