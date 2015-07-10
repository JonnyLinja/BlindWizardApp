//
//  CheckDangerousGameAction.h
//  BlindWizardApp
//
//  Created by N A on 7/10/15.
//  Copyright (c) 2015 Adronitis. All rights reserved.
//

#import "GameAction.h"

@class GameBoard;

@interface CheckDangerousGameAction : NSObject  <GameAction>
@property (nonatomic, assign, readonly) CGFloat duration;
- (id) initWithGameBoard:(GameBoard *)board;
- (void) execute;
- (BOOL) isValid;
- (NSArray *) generateNextGameActions;
@end
