//
//  WaveController.m
//  BlindWizardApp
//
//  Created by N A on 7/8/15.
//  Copyright (c) 2015 Adronitis. All rights reserved.
//

#import "WaveController.h"
#import "MTKObserving.h"
#import "GameConstants.h"
#import "GameBoard.h"
#import "GameFlow.h"
#import "GameDependencyFactory.h"
#import "CallNextWaveGameAction.h"

@interface WaveController ()
@property (nonatomic, assign) CGFloat delay;
@property (nonatomic, assign) CGFloat multiplier;
@property (nonatomic, strong) GameBoard *board; //inject
@property (nonatomic, strong) GameFlow *flow; //inject
@property (nonatomic, strong) id<GameDependencyFactory> factory; //inject
@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, assign) NSInteger count;
@end

@implementation WaveController

- (id) initWithInitialDelay:(CGFloat)initialDelay multiplier:(CGFloat)multiplier gameBoard:(GameBoard *)board gameFlow:(GameFlow *)flow dependencyFactory:(id<GameDependencyFactory>)factory {
    self = [super init];
    if(!self) return nil;
    
    self.delay = initialDelay;
    self.multiplier = multiplier;
    self.board = board;
    self.flow = flow;
    self.factory = factory;
    
    //bind
    [self observeProperty:@keypath(self.board.isActive) withBlock:^(__weak typeof(self) self, NSNumber  *old, NSNumber *newVal) {
        if([newVal boolValue]) {
            [self startTimer];
        }else {
            [self stopTimer];
        }
    }];
    
    //notifications
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(waveCreated) name:GameActionCallNextWaveComplete object:nil];
    
    return self;
}

- (void) commandCallNextWave {
    [self stopTimer];
    [self executeCallNextWave];
}

- (void) startTimer {
    self.timer = [NSTimer scheduledTimerWithTimeInterval:self.delay target:self selector:@selector(executeCallNextWave) userInfo:nil repeats:NO];
}

- (void) stopTimer {
    [self.timer invalidate];
    self.timer = nil;
}

- (void) executeCallNextWave {
    self.count++;
    self.delay *= self.multiplier;
    CallNextWaveGameAction *action = [self.factory callNextWaveGameActionWithBoard:self.board];
    [self.flow addGameAction:action];
}

- (void) waveCreated {
    self.count--;
    
    if(self.count == 0) {
        [self startTimer];
    }
}

- (void) dealloc {
    [self removeAllObservations];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
