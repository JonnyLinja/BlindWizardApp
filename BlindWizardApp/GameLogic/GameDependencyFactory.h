//
//  GameDependencyFactory.h
//  BlindWizardApp
//
//  Created by N A on 7/3/15.
//  Copyright (c) 2015 Adronitis. All rights reserved.
//

#import "GameAction.h"

@class GameBoard;

@protocol GameDependencyFactory <NSObject>
- (GameBoard *) createGameBoardWithRows:(NSInteger)rows columns:(NSInteger)columns;
- (id<GameAction>) createCallNextWaveGameActionWithBoard:(GameBoard *)board;
- (id<GameAction>) createShiftEnemiesLeftGameActionWithBoard:(GameBoard *)board row:(NSInteger)row;
- (id<GameAction>) createShiftEnemiesRightGameActionWithBoard:(GameBoard *)board row:(NSInteger)row;
@end