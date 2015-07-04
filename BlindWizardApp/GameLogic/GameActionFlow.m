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
    [self.queue add:gameAction];
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
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, duration * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
        self.isReady = YES;
    });
}

- (void) dealloc {
    [self removeAllObservations];
}

@end
