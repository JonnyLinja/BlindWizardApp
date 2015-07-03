//
//  BoardViewModel.h
//  BlindWizardApp
//
//  Created by N A on 6/25/15.
//  Copyright (c) 2015 Adronitis. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreGraphics/CoreGraphics.h>

@class Game;
@class GridCalculator;
@class GameFactory;
@class GridStorage;

@interface BoardViewModel : NSObject

@property (nonatomic, strong) Game *game; //inject
@property (nonatomic, strong) GridCalculator *gridCalculator; //inject
@property (nonatomic, strong) GameFactory *gameFactory; //inject
@property (nonatomic, strong) GridStorage *gridStorage; //inject

//commands
- (void) swipeLeftFromPoint:(CGPoint)point;
- (void) swipeRightFromPoint:(CGPoint)point;

//game updates
- (void) executeGameUpdateCreateEnemy:(NSNotification *)notification;
- (void) executeGameUpdateShiftEnemyLeft:(NSNotification *)notification;
- (void) executeGameUpdateShiftEnemyRight:(NSNotification *)notification;
- (void) executeGameUpdateMoveEnemyToRowHead:(NSNotification *)notification;
- (void) executeGameUpdateMoveEnemyToRowTail:(NSNotification *)notification;
- (void) executeGameUpdateDropEnemyDown:(NSNotification *)notification;
- (void) executeGameUpdateMarkEnemyAsDangerous:(NSNotification *)notification;
- (void) executeGameUpdateMarkEnemyAsPacified:(NSNotification *)notification;
- (void) executeGameUpdateDestroyEnemy:(NSNotification *)notification;
- (void) handleGameActionComplete;
@end
