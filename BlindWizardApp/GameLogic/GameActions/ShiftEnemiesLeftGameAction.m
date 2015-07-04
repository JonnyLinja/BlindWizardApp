//
//  ShiftEnemiesLeftGameAction.m
//  BlindWizardApp
//
//  Created by N A on 7/4/15.
//  Copyright (c) 2015 Adronitis. All rights reserved.
//

#import "ShiftEnemiesLeftGameAction.h"
#import "GameBoard.h"
#import "GameConstants.h"

@implementation ShiftEnemiesLeftGameAction

- (void) execute {
    NSNumber *castedRow = @(self.row);
    NSInteger index = self.row*self.gameBoard.numColumns;
    NSNumber *head = [self.gameBoard.data objectAtIndex:index];
    index++;
    
    //shift left
    for(NSInteger column=1; column<self.gameBoard.numColumns; column++,index++) {
        //data
        NSNumber *n = [self.gameBoard.data objectAtIndex:index];
        
        //save
        [self.gameBoard.data setObject:n atIndexedSubscript:index-1];
        
        //notify
        if([n integerValue] != 0) {
            [[NSNotificationCenter defaultCenter] postNotificationName:GameUpdateShiftEnemyLeft
                                                                object:self
                                                              userInfo:@{
                                                                         @"row" : castedRow,
                                                                         @"column" : @(column)
                                                                         }];
        }
    }
    
    //move to tail
    [self.gameBoard.data setObject:head atIndexedSubscript:index-1];
    
    //notify
    if([head integerValue] != 0) {
        [[NSNotificationCenter defaultCenter] postNotificationName:GameUpdateMoveEnemyToRowTail
                                                            object:self
                                                          userInfo:@{
                                                                     @"row" : castedRow,
                                                                     @"column" : @0
                                                                     }];
    }
}

- (BOOL) isValid {
    NSInteger index = self.row*self.gameBoard.numColumns;
    for(NSInteger column=0; column<self.gameBoard.numColumns; column++,index++) {
        NSNumber *n = [self.gameBoard.data objectAtIndex:index];
        if([n integerValue] != 0) {
            return YES;
        }
    }
    
    return NO;
}

- (CGFloat) duration {
    return 0.3;
}

- (NSArray *) generateNextGameActions {
    return @[
             [self.factory createDropEnemiesDownGameActionWithBoard:self.gameBoard],
             [self.factory createDestroyEnemyGroupsGameActionWithBoard:self.gameBoard]
             ];
}

@end
