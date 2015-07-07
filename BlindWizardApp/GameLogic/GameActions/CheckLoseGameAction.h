//
//  CheckLoseGameAction.h
//  BlindWizardApp
//
//  Created by N A on 7/4/15.
//  Copyright (c) 2015 Adronitis. All rights reserved.
//

#import "GameAction.h"

@class GameBoard;

@interface CheckLoseGameAction : NSObject <GameAction>
- (id) initWithGameBoard:(GameBoard *)board;
@property (nonatomic, assign, readonly) CGFloat duration;
- (void) execute;
- (BOOL) isValid;
- (NSArray *) generateNextGameActions;
@end
