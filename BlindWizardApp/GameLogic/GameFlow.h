//
//  GameFlow.h
//  BlindWizardApp
//
//  Created by N A on 7/1/15.
//  Copyright (c) 2015 Adronitis. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol GameAction;
@class Queue;
@class GameBoard;

@interface GameFlow : NSObject
- (id) initWithGameBoard:(GameBoard *)gameBoard queue:(Queue *)queue;
- (void) addGameAction:(id<GameAction>)gameAction;
@end
