//
//  Game.m
//  BlindWizardApp
//
//  Created by N A on 6/25/15.
//  Copyright (c) 2015 Adronitis. All rights reserved.
//

#import "Game.h"
#import "GameBoardLogic.h"

@implementation Game

+ (NSString *) CreateNotificationName {
    return [GameBoardLogic CreateNotificationName];
}

+ (NSString *) ShiftLeftNotificationName {
    return [GameBoardLogic ShiftLeftNotificationName];
}

+ (NSString *) ShiftRightNotificationName {
    return [GameBoardLogic ShiftRightNotificationName];
}

+ (NSString *) MoveToRowHeadNotificationName {
    return [GameBoardLogic MoveToRowHeadNotificationName];
}

+ (NSString *) MoveToRowTailNotificationName {
    return [GameBoardLogic MoveToRowTailNotificationName];
}

+ (NSString *) DropNotificationName {
    return [GameBoardLogic DropNotificationName];
}

+ (NSString *) DangerNotificationName {
    return [GameBoardLogic DangerNotificationName];
}

+ (NSString *) PacifyNotificationName {
    return [GameBoardLogic PacifyNotificationName];
}

+ (NSString *) DestroyNotificationName {
    return [GameBoardLogic DestroyNotificationName];
}

+ (NSString *) GameActionCompleteNotificationName {
    return [GameBoardLogic GameActionCompleteNotificationName];
}

- (void) startGame {
    
}

- (void) callNextWave {
    
}

- (void) swipeLeftOnRow:(NSInteger)row {
    
}

- (void) swipeRightOnRow:(NSInteger)row {
    
}

@end
