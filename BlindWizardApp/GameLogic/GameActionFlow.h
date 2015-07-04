//
//  GameActionFlow.h
//  BlindWizardApp
//
//  Created by N A on 7/1/15.
//  Copyright (c) 2015 Adronitis. All rights reserved.
//

#import <Foundation/Foundation.h>

@class GameActionQueue;
@class GameActionValidator;

@interface GameActionFlow : NSObject
@property (nonatomic, strong) GameActionQueue *gameActionQueue; //inject
@property (nonatomic, strong) GameActionValidator *gameActionValidator; //inject
@property (nonatomic, assign, readonly) BOOL isReady;

//commands
- (void) commandCallNextWave;
- (void) commandSwipeLeftOnRow:(NSInteger)row;
- (void) commandSwipeRightOnRow:(NSInteger)row;

@end
