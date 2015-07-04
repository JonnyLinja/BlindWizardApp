//
//  CallNextWaveGameAction.h
//  BlindWizardApp
//
//  Created by N A on 7/3/15.
//  Copyright (c) 2015 Adronitis. All rights reserved.
//

#import "GameAction.h"

@interface CallNextWaveGameAction : NSObject <GameAction>
@property (nonatomic, assign, readonly) CGFloat duration;
- (void) execute;
- (BOOL) isValid;
- (id<GameAction>) generateNextGameAction;
@end
