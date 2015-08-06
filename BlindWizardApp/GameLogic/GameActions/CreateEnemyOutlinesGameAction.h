//
//  CreateEnemyOutlinesGameAction.h
//  BlindWizardApp
//
//  Created by N A on 8/5/15.
//  Copyright (c) 2015 Adronitis. All rights reserved.
//

#import "GameAction.h"

@class RandomGenerator;
@class GameBoard;

@interface CreateEnemyOutlinesGameAction : NSObject <GameAction>
@property (nonatomic, assign, readonly) CGFloat duration;
- (id) initWithGameBoard:(GameBoard *)board randomGenerator:(RandomGenerator *)randomGenerator;
- (void) execute;
- (BOOL) isValid;
- (NSArray *) generateNextGameActions;

@end
