//
//  Game.h
//  BlindWizardApp
//
//  Created by N A on 6/25/15.
//  Copyright (c) 2015 Adronitis. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Game : NSObject
@property (nonatomic, assign) NSInteger numRows;
@property (nonatomic, assign) NSInteger numColumns;
@property (nonatomic, assign, readonly) BOOL gameInProgress;
@property (nonatomic, assign, readonly) NSInteger score;

//notificaitons
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
- (void) startGame;
- (void) callNextWave;
- (void) swipeLeftOnRow:(NSInteger)row;
- (void) swipeRightOnRow:(NSInteger)row;

//testing only
@property (nonatomic, strong) NSMutableArray *data;
- (void) executeShiftLeftOnRow:(NSInteger)row;

@end
