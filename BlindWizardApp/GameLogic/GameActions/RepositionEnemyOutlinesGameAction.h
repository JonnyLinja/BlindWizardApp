//
//  RepositionEnemyOutlinesGameAction.h
//  BlindWizardApp
//
//  Created by N A on 8/14/15.
//  Copyright (c) 2015 Adronitis. All rights reserved.
//

#import "GameAction.h"

@class GameBoard;

@interface RepositionEnemyOutlinesGameAction : NSObject <GameAction>
- (id) initWithGameBoard:(GameBoard *)board;
@end
