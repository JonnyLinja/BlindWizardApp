//
//  ShiftEnemiesLeftGameAction.h
//  BlindWizardApp
//
//  Created by N A on 7/4/15.
//  Copyright (c) 2015 Adronitis. All rights reserved.
//

#import "GameAction.h"

@protocol GameDependencyFactory;
@class GameBoard;

@interface ShiftEnemiesLeftGameAction : NSObject <GameAction>
@property (nonatomic, assign, readonly) CGFloat duration;
@property (nonatomic, assign) NSInteger row;
- (id) initWithGameBoard:(GameBoard *)board factory:(id<GameDependencyFactory>)factory;
- (void) execute;
- (BOOL) isValid;
- (NSArray *) generateNextGameActions;
@end
