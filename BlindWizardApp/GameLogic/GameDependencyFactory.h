//
//  GameDependencyFactory.h
//  BlindWizardApp
//
//  Created by N A on 7/3/15.
//  Copyright (c) 2015 Adronitis. All rights reserved.
//

@class GameBoard;
@class GameAction;

@protocol GameDependencyFactory <NSObject>
- (GameBoard *) createGameBoardWithRows:(NSInteger)rows columns:(NSInteger)columns;
- (GameAction *) createCallNextWaveGameActionWithBoard:(GameBoard *)board;
- (GameAction *) createShiftEnemiesLeftGameActionWithBoard:(GameBoard *)board row:(NSInteger)row;
- (GameAction *) createShiftEnemiesRightGameActionWithBoard:(GameBoard *)board row:(NSInteger)row;
@end