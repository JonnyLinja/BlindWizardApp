//
//  GameActionFlow.m
//  BlindWizardApp
//
//  Created by N A on 7/1/15.
//  Copyright (c) 2015 Adronitis. All rights reserved.
//

#import "GameActionFlow.h"
#import "GameActionQueue.h"
#import "MTKObserving.h"
#import "GameAction.h"
#import "GameActionValidator.h"

@interface GameActionFlow ()
@property (nonatomic, assign) BOOL isReady;
@end

@implementation GameActionFlow

- (id) init {
    self = [super init];
    if(!self) return nil;
    
    self.isReady = YES;
    
    return self;
}

- (void) addGameAction:(GameAction *)gameAction {
    
}

- (void) setGameActionQueue:(GameActionQueue *)gameActionQueue {
    //save
    _gameActionQueue = gameActionQueue;
    
    //bind
    [self observeProperties:@[@keypath(self.isReady), @keypath(self.gameActionQueue.hasGameAction)] withSelector:@selector(runGameAction)];
}

- (void) runGameAction {
    //valid check
    if(!self.isReady || !self.gameActionQueue.hasGameAction) return;
    
    //game action
    GameAction *gameAction = [self.gameActionQueue pop];
    
    //valid check
    if(![self.gameActionValidator isGameActionValid:gameAction]) return;
    
    //isReady
    [self setNotReadyForDuration:gameAction.duration];
    
    //notify
    [gameAction notifyCompleted];
}

- (void) setNotReadyForDuration:(CGFloat)duration {
    self.isReady = NO;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, duration * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
        self.isReady = YES;
    });
}

- (void) commandCallNextWave {
    [self.gameActionQueue pushCommandCallNextWave];
}

- (void) commandSwipeLeftOnRow:(NSInteger)row {
    [self.gameActionQueue pushCommandSwipeLeftOnRow:row];
}

- (void) commandSwipeRightOnRow:(NSInteger)row {
    [self.gameActionQueue pushCommandSwipeRightOnRow:row];
}

@end
