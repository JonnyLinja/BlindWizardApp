//
//  CallNextWaveGameAction.h
//  BlindWizardApp
//
//  Created by N A on 7/3/15.
//  Copyright (c) 2015 Adronitis. All rights reserved.
//

#import "GameAction.h"

@protocol GameDependencyFactory;
@class GameBoard;

@interface CallNextWaveGameAction : NSObject <GameAction>
@property (nonatomic, assign, readonly) CGFloat duration;
- (id) initWithGameBoard:(GameBoard *)board factory:(id<GameDependencyFactory>)factory;
- (void) execute;
- (BOOL) isValid;
- (NSArray *) generateNextGameActions;
@end
