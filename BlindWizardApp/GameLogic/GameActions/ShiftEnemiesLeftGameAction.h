//
//  ShiftEnemiesLeftGameAction.h
//  BlindWizardApp
//
//  Created by N A on 7/4/15.
//  Copyright (c) 2015 Adronitis. All rights reserved.
//

#import "GameAction.h"

@interface ShiftEnemiesLeftGameAction : NSObject <GameAction>
@property (nonatomic, assign, readonly) CGFloat duration;
- (void) execute;
- (BOOL) isValid;
- (id<GameAction>) generateNextGameAction;
@end
