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
@class GameBoard;
@class GameFlow;
@protocol GameDependencyFactory;

@interface WaveController : NSObject
- (id) initWithInitialDelay:(CGFloat)initialDelay multiplier:(CGFloat)multiplier gameBoard:(GameBoard *)board gameFlow:(GameFlow *)flow dependencyFactory:(id<GameDependencyFactory>)factory;
- (void) commandCallNextWave;
@end
