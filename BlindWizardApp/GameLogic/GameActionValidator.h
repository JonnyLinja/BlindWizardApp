//
//  GameActionValidator.h
//  BlindWizardApp
//
//  Created by N A on 7/3/15.
//  Copyright (c) 2015 Adronitis. All rights reserved.
//

#import <Foundation/Foundation.h>

@class GameAction;

@interface GameActionValidator : NSObject
- (BOOL) isGameActionValid:(GameAction *)gameAction;
@end