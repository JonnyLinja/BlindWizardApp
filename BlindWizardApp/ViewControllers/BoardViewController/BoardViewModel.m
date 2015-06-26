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

@implementation BoardViewModel

- (void) setGame:(Game *)game {
    _game = game;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(create:) name:[Game CreateNotificationName] object:self.game];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(move:) name:[Game MoveNotificationName] object:self.game];
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
    
}

- (void) move:(NSNotification *)notification {
    
}

- (void) destroy:(NSNotification *)notification {
    
}

@end
