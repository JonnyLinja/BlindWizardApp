//
//  Game.m
//  BlindWizardApp
//
//  Created by N A on 6/25/15.
//  Copyright (c) 2015 Adronitis. All rights reserved.
//

#import "Game.h"

@implementation Game

#pragma mark - Test Helpers

+ (NSString *) CreateNotificationName {
    return @"GameCreateNotificationName";
}

+ (NSString *) ShiftLeftNotificationName {
    return @"GameShiftLeftNotificationName";
}

+ (NSString *) ShiftRightNotificationName {
    return @"GameShiftRightNotificationName";
}

+ (NSString *) MoveToRowHeadNotificationName {
    return @"GameMoveToRowHeadNotificationName";
}

+ (NSString *) MoveToRowTailNotificationName {
    return @"GameMoveToRowTailNotificationName";
}

+ (NSString *) DropNotificationName {
    return @"GameDropNotificationName";
}

+ (NSString *) DangerNotificationName {
    return @"GameDangerNotificationName";
}

+ (NSString *) PacifyNotificationName {
    return @"GamePacifyNotificationName";
}

+ (NSString *) DestroyNotificationName {
    return @"DestroyNotificationName";
}

+ (NSString *) GameActionCompleteNotificationName {
    return @"GameActionCompleteNotificationName";
}

#pragma mark - Commands

- (void) startGame {
    
}

- (void) callNextWave {
    
}

- (void) swipeLeftOnRow:(NSInteger)row {
    
}

- (void) swipeRightOnRow:(NSInteger)row {
    
}

#pragma mark - Execute

- (void) executeShiftLeftOnRow:(NSInteger)row {
    NSNumber *castedRow = @(row);
    NSInteger index = row*self.numColumns;
    NSNumber *head = [_data objectAtIndex:index];
    index++;
    
    //shift left
    for(NSInteger column=1; column<self.numColumns; column++,index++) {
        //data
        NSNumber *n = [self.data objectAtIndex:index];
        
        //save
        [self.data setObject:n atIndexedSubscript:index-1];
        
        //notify
        if([n integerValue] != 0) {
            [[NSNotificationCenter defaultCenter] postNotificationName:[Game ShiftLeftNotificationName]
                                                                object:self
                                                              userInfo:@{
                                                                         @"row" : castedRow,
                                                                         @"column" : @(column)
                                                                         }];
        }
    }
    
    //move to tail
    [self.data setObject:head atIndexedSubscript:index-1];
    
    //notify
    if([head integerValue] != 0) {
        [[NSNotificationCenter defaultCenter] postNotificationName:[Game MoveToRowTailNotificationName]
                                                            object:self
                                                          userInfo:@{
                                                                     @"row" : castedRow,
                                                                     @"column" : @0
                                                                     }];
    }
}

@end
