//
//  WaveController.m
//  BlindWizardApp
//
//  Created by N A on 7/8/15.
//  Copyright (c) 2015 Adronitis. All rights reserved.
//

#import "WaveController.h"
#import "Game.h"

@interface WaveController ()
@property (nonatomic, assign) CGFloat delay;
@property (nonatomic, assign) CGFloat multiplier;
@property (nonatomic, strong) Game *game;
@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, assign) NSInteger count;
@end

@implementation WaveController

- (id) initWithInitialDelay:(CGFloat)initialDelay multiplier:(CGFloat)multiplier Game:(Game *)game {
    self = [super init];
    if(!self) return nil;
    
    self.delay = initialDelay;
    self.multiplier = multiplier;
    self.game = game;
    
    return self;
}

- (void) commandCallNextWave {
    
}

@end
