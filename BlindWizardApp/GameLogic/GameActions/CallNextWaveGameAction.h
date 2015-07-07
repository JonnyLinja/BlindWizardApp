//
//  CallNextWaveGameAction.h
//  BlindWizardApp
//
//  Created by N A on 7/3/15.
//  Copyright (c) 2015 Adronitis. All rights reserved.
//

#import "GameAction.h"

@class RandomGenerator;
@class GameBoard;

@interface CallNextWaveGameAction : NSObject <GameAction>
@property (nonatomic, assign, readonly) CGFloat duration;
- (id) initWithGameBoard:(GameBoard *)board factory:(id<GameDependencyFactory>)factory randomGenerator:(RandomGenerator *)randomGenerator;
- (void) execute;
- (BOOL) isValid;
- (NSArray *) generateNextGameActions;
@end
