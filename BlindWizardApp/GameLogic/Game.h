//
//  Game.h
//  BlindWizardApp
//
//  Created by N A on 6/25/15.
//  Copyright (c) 2015 Adronitis. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Game : NSObject
@property (nonatomic, assign, readonly) BOOL gameInProgress;
@property (nonatomic, assign, readonly) NSInteger score;
+ (NSString *) CreateNotificationName;
+ (NSString *) ShiftLeftNotificationName;
+ (NSString *) ShiftRightNotificationName;
+ (NSString *) MoveToRowHeadNotificationName;
+ (NSString *) MoveToRowTailNotificationName;
+ (NSString *) DropNotificationName;
+ (NSString *) DangerNotificationName;
+ (NSString *) DestroyNotificationName;
- (void) startGame;
- (void) callNextWave;
- (void) swipeLeftOnRow:(NSInteger)row;
- (void) swipeRightOnRow:(NSInteger)row;
@end
