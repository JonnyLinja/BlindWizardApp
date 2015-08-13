//
//  DelayGameAction.h
//  BlindWizardApp
//
//  Created by N A on 8/11/15.
//  Copyright (c) 2015 Adronitis. All rights reserved.
//

#import "GameAction.h"

@interface DelayGameAction : NSObject <GameAction>

@property (nonatomic, assign, readonly) CGFloat duration;
- (id) initWithDuration:(CGFloat)duration;
- (void) execute;
- (BOOL) isValid;
- (NSArray *) generateNextGameActions;
@end
