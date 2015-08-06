//
//  BoardViewModel.m
//  BlindWizardApp
//
//  Created by N A on 6/25/15.
//  Copyright (c) 2015 Adronitis. All rights reserved.
//

#import "BoardViewModel.h"
#import "MTKObserving.h"
#import "Game.h"
#import "GameConstants.h"
#import "GridCalculator.h"
#import "GameObjectFactory.h"
#import "EnemyViewModel.h"
#import "GridStorage.h"
#import "EnemyOutlineViewModel.h"

@interface BoardViewModel ()
@property (nonatomic, strong) NSMutableDictionary *outlines;
@end

@implementation BoardViewModel

- (id) init {
    self = [super init];
    if(!self) return nil;
    
    self.outlines = [NSMutableDictionary new];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(executeGameUpdateCreateEnemy:) name:GameUpdateCreateEnemy object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(executeGameUpdateCreateEnemyOutline:) name:GameUpdateCreateEnemyOutline object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(executeGameUpdateShiftEnemyLeft:) name:GameUpdateShiftEnemyLeft object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(executeGameUpdateShiftEnemyRight:) name:GameUpdateShiftEnemyRight object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(executeGameUpdateMoveEnemyToRowHead:) name:GameUpdateMoveEnemyToRowHead object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(executeGameUpdateMoveEnemyToRowTail:) name:GameUpdateMoveEnemyToRowTail object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(executeGameUpdateDropEnemyDown:) name:GameUpdateDropEnemyDown object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(executeGameUpdateMarkEnemyAsDangerous:) name:GameUpdateMarkEnemyAsDangerous object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(executeGameUpdateMarkEnemyAsHarmless:) name:GameUpdateMarkEnemyAsHarmless object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(executeGameUpdateDestroyEnemy:) name:GameUpdateDestroyEnemy object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleGameActionComplete) name:GameActionComplete object:nil];

    return self;
}

- (void) setGame:(Game *)game {
    //save
    _game = game;
    
    //bind
    [self map:@keypath(self.game.gameInProgress) to:@keypath(self.isActive) null:@NO];
    [self observeProperty:@keypath(self.game.gameInProgress) withBlock:^(__weak typeof(self) self, NSNumber *oldVal, NSNumber *newVal) {
        if([newVal boolValue]) {
            [self.gridStorage removeAllObjects];
        }
    }];
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
    EnemyViewModel *evm = [self.factory createEnemyWithType:type atRow:row column:column];
    
    //animate
    [evm runCreateAnimation];
    
    //store
    [self.gridStorage promiseSetObject:evm forRow:row column:column];
}

- (void) executeGameUpdateCreateEnemyOutline:(NSNotification *)notification {
    //parse values
    NSInteger row = [[notification.userInfo objectForKey:@"row"] integerValue];
    NSInteger column = [[notification.userInfo objectForKey:@"column"] integerValue];
    NSInteger type = [[notification.userInfo objectForKey:@"type"] integerValue];
    NSNumber *key = @(column);
    
    //remove existing
    EnemyOutlineViewModel *eovm = [self.outlines objectForKey:key];
    if(eovm) {
        [eovm runDestroyAnimation];
    }

    //create
    eovm = [self.factory createEnemyOutlineWithType:type atRow:row column:column];
    
    //animate
    [eovm runCreateAnimation];
    
    //store
    [self.outlines setObject:eovm forKey:key];
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

    //get
    EnemyViewModel *evm = [self.gridStorage objectForRow:row column:column];
    
    //animate
    CGPoint snapPoint = [self.gridCalculator calculatePointForRow:row column:-1];
    CGPoint movePoint = [self.gridCalculator calculatePointForRow:row column:0];
    [evm snapToCGPoint:snapPoint thenAnimateMoveToCGPoint:movePoint];
    
    //store
    [self.gridStorage promiseSetObject:evm forRow:row column:0];
    
    //create duplicate at original spot
    EnemyViewModel *duplicate = [self.factory createEnemyWithType:evm.enemyType atRow:row column:column];
    
    //animate duplicate offscreen to the right
    CGPoint toPoint = [self.gridCalculator calculatePointForRow:row column:column+1];
    [duplicate animateMoveAndRemoveToCGPoint:toPoint];
}

- (void) executeGameUpdateMoveEnemyToRowTail:(NSNotification *)notification {
    //parse values
    NSInteger row = [[notification.userInfo objectForKey:@"row"] integerValue];
    NSInteger column = [[notification.userInfo objectForKey:@"column"] integerValue];
    NSInteger toColumn = self.gridCalculator.numColumns-1;
    
    //get
    EnemyViewModel *evm = [self.gridStorage objectForRow:row column:column];
    
    //animate
    CGPoint snapPoint = [self.gridCalculator calculatePointForRow:row column:self.gridCalculator.numColumns];
    CGPoint newPoint = [self.gridCalculator calculatePointForRow:row column:toColumn];
    [evm snapToCGPoint:snapPoint thenAnimateMoveToCGPoint:newPoint];
    
    //store
    [self.gridStorage promiseSetObject:evm forRow:row column:toColumn];
    
    //create duplicate
    EnemyViewModel *duplicate = [self.factory createEnemyWithType:evm.enemyType atRow:row column:column];
    
    //animate duplicate offscreen to the left
    CGPoint toPoint = [self.gridCalculator calculatePointForRow:row column:-1];
    [duplicate animateMoveAndRemoveToCGPoint:toPoint];
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
    [evm animateDropToCGPoint:toPoint];
    
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

- (void) executeGameUpdateMarkEnemyAsHarmless:(NSNotification *)notification {
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
    NSInteger score = [[notification.userInfo objectForKey:@"score"] integerValue];
    
    //get
    EnemyViewModel *evm = [self.gridStorage objectForRow:row column:column];
    
    //animate
    [evm runDestroyAnimationWithScore:score];
    
    //store
    [self.gridStorage promiseRemoveObjectForRow:row column:column];
}

- (void) handleGameActionComplete {
    [self.gridStorage fulfillPromises];
}

- (void) dealloc {
    [self removeAllObservations];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
