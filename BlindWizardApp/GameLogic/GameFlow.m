//
//  GameFlow.m
//  BlindWizardApp
//
//  Created by N A on 7/1/15.
//  Copyright (c) 2015 Adronitis. All rights reserved.
//

#import "GameFlow.h"
#import "GameAction.h"
#import "Queue.h"
#import "MTKObserving.h"
#import "GameConstants.h"
#import "GameBoard.h"

@interface GameFlow ()
@property (nonatomic, strong) Queue *queue; //inject
@property (nonatomic, strong) GameBoard *gameBoard; //inject
@property (nonatomic, assign) BOOL isReady;
@end

@implementation GameFlow

- (id) initWithGameBoard:(GameBoard *)gameBoard queue:(Queue *)queue {
    self = [super init];
    if(!self) return nil;
    
    self.gameBoard = gameBoard;
    self.queue = queue;
    
    self.isReady = YES;
    [self observeProperties:@[@keypath(self.isReady), @keypath(self.queue.hasObject)] withSelector:@selector(runGameAction)];
    
    return self;
}

- (void) addGameAction:(id<GameAction>)gameAction {
    [self.queue add:gameAction];
}

- (BOOL) shouldRunGameAction {
    return self.isReady && self.queue.hasObject && self.gameBoard.isActive;
}

- (void) runGameAction {
    //valid check
    if(![self shouldRunGameAction]) return;
    
    //not ready
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
        [self insertGameActions:[gameAction generateNextGameActions]];
        
        //notify
        [[NSNotificationCenter defaultCenter] postNotificationName:GameActionComplete object:nil];
    }
}

- (void) setReadyAfter:(CGFloat)duration {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, duration * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
        self.isReady = YES;
    });
}

- (void) insertGameActions:(NSArray *)array {
    NSEnumerator* enumerator = [array reverseObjectEnumerator];
    for(id<GameAction> action in enumerator) {
        [self.queue push:action];
    }
}

- (void) dealloc {
    [self removeAllObservations];
}

@end
