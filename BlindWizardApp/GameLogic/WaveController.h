//
//  WaveController.h
//  BlindWizardApp
//
//  Created by N A on 7/8/15.
//  Copyright (c) 2015 Adronitis. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreGraphics/CoreGraphics.h>

@class Game;

@interface WaveController : NSObject
- (id) initWithInitialDelay:(CGFloat)initialDelay multiplier:(CGFloat)multiplier Game:(Game *)game;
- (void) commandCallNextWave;
@end
