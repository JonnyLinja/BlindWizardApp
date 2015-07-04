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
@property (nonatomic, strong) id<GameDependencyFactory> factory; //inject
@property (nonatomic, strong) GameBoard *gameBoard; //inject
@property (nonatomic, strong) RandomGenerator *randomGenerator; //inject
@property (nonatomic, assign, readonly) CGFloat duration;
- (void) execute;
- (BOOL) isValid;
- (id<GameAction>) generateNextGameAction;
@end
