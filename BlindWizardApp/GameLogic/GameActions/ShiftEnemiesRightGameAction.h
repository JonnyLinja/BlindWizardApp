//
//  ShiftEnemiesRightGameAction.h
//  BlindWizardApp
//
//  Created by N A on 7/4/15.
//  Copyright (c) 2015 Adronitis. All rights reserved.
//

#import "GameAction.h"

@interface ShiftEnemiesRightGameAction : NSObject <GameAction>
@property (nonatomic, strong) id<GameDependencyFactory> factory; //inject
@property (nonatomic, strong) GameBoard *gameBoard; //inject
@property (nonatomic, assign, readonly) CGFloat duration;
@property (nonatomic, assign) NSInteger row;
- (void) execute;
- (BOOL) isValid;
- (NSArray *) generateNextGameActions;
@end
