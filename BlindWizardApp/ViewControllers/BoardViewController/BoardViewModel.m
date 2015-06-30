//
//  BoardViewModel.m
//  BlindWizardApp
//
//  Created by N A on 6/25/15.
//  Copyright (c) 2015 Adronitis. All rights reserved.
//

#import "BoardViewModel.h"
#import "Game.h"
#import "GridCalculator.h"
#import "GameFactory.h"
#import "EnemyViewModel.h"
#import "GridStorage.h"

@implementation BoardViewModel

- (void) setGame:(Game *)game {
    _game = game;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(create:) name:[Game CreateNotificationName] object:self.game];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(shiftLeft:) name:[Game ShiftLeftNotificationName] object:self.game];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(shiftRight:) name:[Game ShiftRightNotificationName] object:self.game];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(moveToRowHead:) name:[Game MoveToRowHeadNotificationName] object:self.game];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(danger:) name:[Game DangerNotificationName] object:self.game];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(destroy:) name:[Game DestroyNotificationName] object:self.game];
}

- (void) swipeLeftFromPoint:(CGPoint)point {
    NSInteger row = [self.gridCalculator calculateRowForYPos:point.y];
    [self.game swipeLeftOnRow:row];
}

- (void) swipeRightFromPoint:(CGPoint)point {
    NSInteger row = [self.gridCalculator calculateRowForYPos:point.y];
    [self.game swipeRightOnRow:row];
}

- (void) create:(NSNotification *)notification {
    NSInteger row = [[notification.userInfo objectForKey:@"row"] integerValue];
    NSInteger column = [[notification.userInfo objectForKey:@"column"] integerValue];
    NSInteger type = [[notification.userInfo objectForKey:@"type"] integerValue];
    
    EnemyViewModel *evm = [self.gameFactory createEnemyWithType:type atRow:row column:column];
    [evm runCreateAnimation];
    [self.gridStorage promiseSetObject:evm forRow:row column:column];
}

- (void) shiftLeft:(NSNotification *)notification {
    NSInteger row = [[notification.userInfo objectForKey:@"row"] integerValue];
    NSInteger column = [[notification.userInfo objectForKey:@"column"] integerValue];
    NSInteger toColumn = column-1;

    EnemyViewModel *evm = [self.gridStorage objectForRow:row column:column];
    CGPoint newPoint = [self.gridCalculator calculatePointForRow:row column:toColumn];
    
    [evm animateMoveToCGPoint:newPoint];
    [self.gridStorage promiseSetObject:evm forRow:row column:toColumn];
}

- (void) shiftRight:(NSNotification *)notification {
    NSInteger row = [[notification.userInfo objectForKey:@"row"] integerValue];
    NSInteger column = [[notification.userInfo objectForKey:@"column"] integerValue];
    NSInteger toColumn = column+1;
    
    EnemyViewModel *evm = [self.gridStorage objectForRow:row column:column];
    CGPoint newPoint = [self.gridCalculator calculatePointForRow:row column:toColumn];
    
    [evm animateMoveToCGPoint:newPoint];
    [self.gridStorage promiseSetObject:evm forRow:row column:toColumn];
}

- (void) moveToRowHead:(NSNotification *)notification {
    NSInteger row = [[notification.userInfo objectForKey:@"row"] integerValue];
    NSInteger column = [[notification.userInfo objectForKey:@"column"] integerValue];
    NSInteger toColumn = column+1;

    EnemyViewModel *evm = [self.gridStorage objectForRow:row column:column];
    CGPoint newPoint = [self.gridCalculator calculatePointForRow:row column:toColumn];
    CGPoint snapPoint = [self.gridCalculator calculatePointForRow:row column:0];

    [evm animateMoveToCGPoint:newPoint thenSnapToCGPoint:snapPoint];
    [self.gridStorage promiseSetObject:evm forRow:row column:0];
    
    EnemyViewModel *sprite = [self.gameFactory createEnemyWithType:evm.enemyType atRow:row column:-1];
    [sprite animateMoveToCGPoint:snapPoint removeAfter:YES];
}

- (void) danger:(NSNotification *)notification {
    
}

- (void) destroy:(NSNotification *)notification {
    
}

@end
