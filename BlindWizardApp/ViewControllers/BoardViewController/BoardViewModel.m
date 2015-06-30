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
    //save
    _game = game;
    
    //notifications
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(create:) name:[Game CreateNotificationName] object:self.game];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(shiftLeft:) name:[Game ShiftLeftNotificationName] object:self.game];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(shiftRight:) name:[Game ShiftRightNotificationName] object:self.game];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(moveToRowHead:) name:[Game MoveToRowHeadNotificationName] object:self.game];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(moveToRowTail:) name:[Game MoveToRowTailNotificationName] object:self.game];
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

- (void) shiftLeft:(NSNotification *)notification {
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

- (void) shiftRight:(NSNotification *)notification {
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

- (void) moveToRowHead:(NSNotification *)notification {
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

- (void) moveToRowTail:(NSNotification *)notification {
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

- (void) danger:(NSNotification *)notification {
    
}

- (void) destroy:(NSNotification *)notification {
    
}

- (void) dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
