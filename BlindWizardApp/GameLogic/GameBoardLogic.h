//
//  GameBoardLogic.h
//  BlindWizardApp
//
//  Created by N A on 6/30/15.
//  Copyright (c) 2015 Adronitis. All rights reserved.
//

#import <Foundation/Foundation.h>

@class RandomGenerator;

@interface GameBoardLogic : NSObject
@property (nonatomic, strong) RandomGenerator *randomGenerator; //inject
@property (nonatomic, assign) NSInteger numRows;
@property (nonatomic, assign) NSInteger numColumns;
@property (nonatomic, strong) NSMutableArray *data;

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

- (void) executeShiftLeftOnRow:(NSInteger)row;
- (void) executeShiftRightOnRow:(NSInteger)row;
- (void) executeDrop;
- (void) executeCreate;
@end
