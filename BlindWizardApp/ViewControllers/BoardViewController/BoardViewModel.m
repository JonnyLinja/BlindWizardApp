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
#import "ObjectPosition.h"
#import "EnemyViewModel.h"

@implementation BoardViewModel

- (id) init {
    self = [super init];
    if(!self) return nil;
    
    NSMutableDictionary *d = [[NSMutableDictionary alloc] init];
    self.enemies = d;
    
    return self;
}

- (void) setGame:(Game *)game {
    _game = game;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(create:) name:[Game CreateNotificationName] object:self.game];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(move:) name:[Game MoveNotificationName] object:self.game];
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
    NSArray *array = [notification.userInfo objectForKey:@"indices"];
    for(ObjectPosition *position in array) {
        EnemyViewModel *evm = [self.gameFactory createEnemyAtPosition:position];
        [evm runCreateAnimation];
        [self.enemies setObject:evm forKey:position];
    }
}

- (void) move:(NSNotification *)notification {
    
}

- (void) danger:(NSNotification *)notification {
    
}

- (void) destroy:(NSNotification *)notification {
    
}

@end
