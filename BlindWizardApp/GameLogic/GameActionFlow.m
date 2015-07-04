//
//  GameActionFlow.m
//  BlindWizardApp
//
//  Created by N A on 7/1/15.
//  Copyright (c) 2015 Adronitis. All rights reserved.
//

#import "GameActionFlow.h"
#import "Queue.h"
#import "MTKObserving.h"

@interface GameActionFlow ()
@property (nonatomic, assign) BOOL isReady;
@end

@implementation GameActionFlow

- (id) init {
    self = [super init];
    if(!self) return nil;
    
    self.isReady = YES;
    [self observeProperties:@[@keypath(self.isReady), @keypath(self.queue.hasObject)] withSelector:@selector(runGameAction)];
    
    return self;
}

- (void) addGameAction:(id<GameAction>)gameAction {
    
}

- (void) runGameAction {
    //valid check
    if(!self.isReady || !self.queue.hasObject) return;
    
    //ready
    self.isReady = NO;
    
    //game action
    id<GameAction> gameAction = [self.queue pop];
    
    if(![gameAction isValid]) {
        //invalid
        self.isReady = YES;
    }else {
        //valid
        
        //execute
        [gameAction execute];
        
        //wait
        [self setReadyAfter:gameAction.duration];
        
        //set next
        [self.queue push:[gameAction generateNextGameAction]];
    }
}

- (void) setReadyAfter:(CGFloat)duration {
    __weak typeof(self) weakSelf = self;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, duration * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
        weakSelf.isReady = YES;
    });
}

- (void) dealloc {
    [self removeAllObservations];
}

/*
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

*/
@end
