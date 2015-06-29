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

@implementation BoardViewModel

- (id) init {
    self = [super init];
    if(!self) return nil;
    
    //NSMutableDictionary *d = [[NSMutableDictionary alloc] init];
    //self.enemies = d;
    self.enemies = [NSMutableDictionary new];
    //NSLog(@"enemies! %@", self.enemies);
    
    return self;
}

- (void) setGame:(Game *)game {
    _game = game;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(create:) name:[Game CreateNotificationName] object:self.game];
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
    EnemyViewModel *evm = [self.gameFactory createEnemyAtRow:row column:column];
    [evm runCreateAnimation];
    [self.enemies setObject:evm forKey:[NSString stringWithFormat:@"%li:%li", row, column]];
}

- (void) shiftLeft:(NSNotification *)notification {
    NSInteger row = [[notification.userInfo objectForKey:@"row"] integerValue];
    NSInteger column = [[notification.userInfo objectForKey:@"column"] integerValue];
    NSString *position = [NSString stringWithFormat:@"%li:%li", row, column];
    NSString *newPosition = [NSString stringWithFormat:@"%li:%li", row, column-1];

    EnemyViewModel *evm = [self.enemies objectForKey:position];
    CGPoint newPoint = [self.gridCalculator calculatePointForRow:row column:column-1];
    
    [evm animateMoveToCGPoint:newPoint];
    
    [self.enemies setObject:evm forKey:newPosition];
    [self.enemies removeObjectForKey:position];
}

- (void) danger:(NSNotification *)notification {
    
}

- (void) destroy:(NSNotification *)notification {
    
}

@end
