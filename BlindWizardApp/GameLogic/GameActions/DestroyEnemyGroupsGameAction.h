//
//  DestroyEnemyGroupsGameAction.h
//  BlindWizardApp
//
//  Created by N A on 7/4/15.
//  Copyright (c) 2015 Adronitis. All rights reserved.
//

#import "GameAction.h"

@protocol GameDependencyFactory;
@class GameBoard;
@class ScoreCalculator;

@interface DestroyEnemyGroupsGameAction : NSObject <GameAction>
@property (nonatomic, assign, readonly) CGFloat duration;
- (id) initWithGameBoard:(GameBoard *)board factory:(id<GameDependencyFactory>)factory scoreCalculator:(ScoreCalculator *)calculator;
- (void) execute;
- (BOOL) isValid;
- (NSArray *) generateNextGameActions;
@end
