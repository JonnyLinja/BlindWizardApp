//
//  BoardViewModel.m
//  BlindWizardApp
//
//  Created by N A on 6/25/15.
//  Copyright (c) 2015 Adronitis. All rights reserved.
//

#import "BoardViewModel.h"
#import "Game.h"
#import "GameConstants.h"
#import "GridCalculator.h"
#import "GameFactory.h"
#import "EnemyViewModel.h"
#import "GridStorage.h"

@implementation BoardViewModel

- (void) setGame:(Game *)game {
    //save
    _game = game;
    
    //notifications - not under test but necessary
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(executeGameUpdateCreateEnemy:) name:GameUpdateCreateEnemy object:self.game];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(executeGameUpdateShiftEnemyLeft:) name:GameUpdateShiftEnemyLeft object:self.game];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(executeGameUpdateShiftEnemyRight:) name:GameUpdateShiftEnemyRight object:self.game];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(executeGameUpdateMoveEnemyToRowHead:) name:GameUpdateMoveEnemyToRowHead object:self.game];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(executeGameUpdateMoveEnemyToRowTail:) name:GameUpdateMoveEnemyToRowTail object:self.game];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(executeGameUpdateDropEnemyDown:) name:GameUpdateDropEnemyDown object:self.game];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(executeGameUpdateMarkEnemyAsDangerous:) name:GameUpdateMarkEnemyAsDangerous object:self.game];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(executeGameUpdateMarkEnemyAsPacified:) name:GameUpdateMarkEnemyAsPacified object:self.game];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(executeGameUpdateDestroyEnemy:) name:GameUpdateDestroyEnemy object:self.game];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleGameActionComplete) name:GameActionComplete object:self.game];
}

- (void) swipeLeftFromPoint:(CGPoint)point {
    NSInteger row = [self.gridCalculator calculateRowForYPos:point.y];
    [self.game commandSwipeLeftOnRow:row];
}

- (void) swipeRightFromPoint:(CGPoint)point {
    NSInteger row = [self.gridCalculator calculateRowForYPos:point.y];
    [self.game commandSwipeRightOnRow:row];
}

- (void) executeGameUpdateCreateEnemy:(NSNotification *)notification {
    //parse values
    NSInteger row = [[notification.userInfo objectForKey:@"row"] integerValue];
    NSInteger column = [[notification.userInfo objectForKey:@"column"] integerValue];
    NSInteger type = [[notification.userInfo objectForKey:@"type"] integerValue];
    
    //create
    EnemyViewModel *evm = [self.gameFactory createEnemyWithType:type atRow:row column:column];
    
    //animate
    [evm runCreateAnimation];
    
    //store
    [self.gridStorage promiseSetObject:evm forRow:row column:column];
}

- (void) executeGameUpdateShiftEnemyLeft:(NSNotification *)notification {
    //parse values
    NSInteger row = [[notification.userInfo objectForKey:@"row"] integerValue];
    NSInteger column = [[notification.userInfo objectForKey:@"column"] integerValue];
    NSInteger toColumn = column-1;
    
    //get
    EnemyViewModel *evm = [self.gridStorage objectForRow:row column:column];
    
    //animate
    CGPoint newPoint = [self.gridCalculator calculatePointForRow:row column:toColumn];
    [evm animateMoveToCGPoint:newPoint];
    
    //store
    [self.gridStorage promiseSetObject:evm forRow:row column:toColumn];
}

- (void) executeGameUpdateShiftEnemyRight:(NSNotification *)notification {
    //parse values
    NSInteger row = [[notification.userInfo objectForKey:@"row"] integerValue];
    NSInteger column = [[notification.userInfo objectForKey:@"column"] integerValue];
    NSInteger toColumn = column+1;
    
    //get
    EnemyViewModel *evm = [self.gridStorage objectForRow:row column:column];
    
    //animate
    CGPoint newPoint = [self.gridCalculator calculatePointForRow:row column:toColumn];
    [evm animateMoveToCGPoint:newPoint];
    
    //store
    [self.gridStorage promiseSetObject:evm forRow:row column:toColumn];
}

- (void) executeGameUpdateMoveEnemyToRowHead:(NSNotification *)notification {
    //parse values
    NSInteger row = [[notification.userInfo objectForKey:@"row"] integerValue];
    NSInteger column = [[notification.userInfo objectForKey:@"column"] integerValue];
    NSInteger toColumn = column+1;

    //get
    EnemyViewModel *evm = [self.gridStorage objectForRow:row column:column];
    
    //animate
    CGPoint newPoint = [self.gridCalculator calculatePointForRow:row column:toColumn];
    CGPoint snapPoint = [self.gridCalculator calculatePointForRow:row column:0];
    [evm animateMoveToCGPoint:newPoint thenSnapToCGPoint:snapPoint];
    
    //store
    [self.gridStorage promiseSetObject:evm forRow:row column:0];
    
    //create duplicate
    EnemyViewModel *duplicate = [self.gameFactory createEnemyWithType:evm.enemyType atRow:row column:-1];
    
    //animate duplicate
    [duplicate animateMoveToCGPoint:snapPoint removeAfter:YES];
}

- (void) executeGameUpdateMoveEnemyToRowTail:(NSNotification *)notification {
    //parse values
    NSInteger row = [[notification.userInfo objectForKey:@"row"] integerValue];
    NSInteger column = [[notification.userInfo objectForKey:@"column"] integerValue];
    NSInteger toColumn = column-1;
    NSInteger lastColumn = self.gridCalculator.numColumns-1;
    
    //get
    EnemyViewModel *evm = [self.gridStorage objectForRow:row column:column];
    
    //animate
    CGPoint newPoint = [self.gridCalculator calculatePointForRow:row column:toColumn];
    CGPoint snapPoint = [self.gridCalculator calculatePointForRow:row column:lastColumn];
    [evm animateMoveToCGPoint:newPoint thenSnapToCGPoint:snapPoint];
    
    //store
    [self.gridStorage promiseSetObject:evm forRow:row column:lastColumn];
    
    //create duplicate
    EnemyViewModel *duplicate = [self.gameFactory createEnemyWithType:evm.enemyType atRow:row column:lastColumn+1];
    
    //animate duplicate
    [duplicate animateMoveToCGPoint:snapPoint removeAfter:YES];
}

- (void) executeGameUpdateDropEnemyDown:(NSNotification *)notification {
    //parse values
    NSInteger fromRow = [[notification.userInfo objectForKey:@"fromRow"] integerValue];
    NSInteger toRow = [[notification.userInfo objectForKey:@"toRow"] integerValue];
    NSInteger column = [[notification.userInfo objectForKey:@"column"] integerValue];

    //get
    EnemyViewModel *evm = [self.gridStorage objectForRow:fromRow column:column];
    
    //animate
    CGPoint toPoint = [self.gridCalculator calculatePointForRow:toRow column:column];
    [evm animateMoveToCGPoint:toPoint];
    
    //store
    [self.gridStorage promiseSetObject:evm forRow:toRow column:column];
}

- (void) executeGameUpdateMarkEnemyAsDangerous:(NSNotification *)notification {
    //parse values
    NSInteger row = [[notification.userInfo objectForKey:@"row"] integerValue];
    NSInteger column = [[notification.userInfo objectForKey:@"column"] integerValue];
    
    //get
    EnemyViewModel *evm = [self.gridStorage objectForRow:row column:column];
    
    //animate
    [evm runDangerAnimation];
}

- (void) executeGameUpdateMarkEnemyAsPacified:(NSNotification *)notification {
    //parse values
    NSInteger row = [[notification.userInfo objectForKey:@"row"] integerValue];
    NSInteger column = [[notification.userInfo objectForKey:@"column"] integerValue];
    
    //get
    EnemyViewModel *evm = [self.gridStorage objectForRow:row column:column];
    
    //animate
    [evm stopDangerAnimation];
}

- (void) executeGameUpdateDestroyEnemy:(NSNotification *)notification {
    //parse values
    NSInteger row = [[notification.userInfo objectForKey:@"row"] integerValue];
    NSInteger column = [[notification.userInfo objectForKey:@"column"] integerValue];
    
    //get
    EnemyViewModel *evm = [self.gridStorage objectForRow:row column:column];
    
    //animate
    [evm runDestroyAnimation];
    
    //store
    [self.gridStorage promiseRemoveObjectForRow:row column:column];
}

- (void) handleGameActionComplete {
    [self.gridStorage fulfillPromises];
}

- (void) dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self]; //not under test
}

@end
