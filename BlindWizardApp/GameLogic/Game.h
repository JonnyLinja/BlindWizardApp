//
//  Game.h
//  BlindWizardApp
//
//  Created by N A on 6/25/15.
//  Copyright (c) 2015 Adronitis. All rights reserved.
//

#import <Foundation/Foundation.h>

@class GameBoardLogic;

@interface Game : NSObject
@property (nonatomic, strong) GameBoardLogic *gameBoardLogic;
@property (nonatomic, assign, readonly) BOOL gameInProgress;
@property (nonatomic, assign, readonly) NSInteger score;

//notifications
+ (NSString *) CreateNotificationName;
+ (NSString *) ShiftLeftNotificationName;
+ (NSString *) ShiftRightNotificationName;
+ (NSString *) MoveToRowHeadNotificationName;
+ (NSString *) MoveToRowTailNotificationName;
+ (NSString *) DropNotificationName;
+ (NSString *) DangerNotificationName;
+ (NSString *) PacifyNotificationName;
+ (NSString *) DestroyNotificationName;
+ (NSString *) GameActionCompleteNotificationName;

//public
- (void) commandStartGame;
- (void) commandCallNextWave;
- (void) commandSwipeLeftOnRow:(NSInteger)row;
- (void) commandSwipeRightOnRow:(NSInteger)row;

@end
