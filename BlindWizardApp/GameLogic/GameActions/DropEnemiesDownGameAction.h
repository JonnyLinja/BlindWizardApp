//
//  DropEnemiesDownGameAction.h
//  BlindWizardApp
//
//  Created by N A on 7/4/15.
//  Copyright (c) 2015 Adronitis. All rights reserved.
//

#import "GameAction.h"

@protocol GameDependencyFactory;
@class GameBoard;

@interface DropEnemiesDownGameAction : NSObject <GameAction>
@property (nonatomic, assign, readonly) CGFloat duration;
- (id) initWithGameBoard:(GameBoard *)board factory:(id<GameDependencyFactory>)factory duration:(CGFloat)duration;
- (void) execute;
- (BOOL) isValid;
- (NSArray *) generateNextGameActions;
@end
