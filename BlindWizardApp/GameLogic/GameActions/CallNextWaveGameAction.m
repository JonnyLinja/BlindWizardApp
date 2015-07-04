//
//  CallNextWaveGameAction.m
//  BlindWizardApp
//
//  Created by N A on 7/3/15.
//  Copyright (c) 2015 Adronitis. All rights reserved.
//

#import "CallNextWaveGameAction.h"
#import "RandomGenerator.h"
#import "GameBoard.h"
#import "GameConstants.h"

@implementation CallNextWaveGameAction

- (void) execute {
    //loop through columns
    for(NSInteger column=0; column<self.gameBoard.numColumns; column++) {
        //loop through rows of that column
        for(NSInteger row=0; row<self.gameBoard.numRows; row++) {
            //current
            NSInteger index = [self.gameBoard indexFromRow:row column:column];
            NSNumber *n = [self.gameBoard.data objectAtIndex:index];
            
            if([n integerValue] == 0) {
                //found a free spot
                
                //add
                NSNumber *newNumber = @([self.randomGenerator generate]);
                [self.gameBoard.data setObject:newNumber atIndexedSubscript:index];
                
                //notify
                [[NSNotificationCenter defaultCenter] postNotificationName:GameUpdateCreateEnemy
                                                                    object:self
                                                                  userInfo:@{
                                                                             @"column" : @(column),
                                                                             @"row" : @(row),
                                                                             @"type" : newNumber
                                                                             }];
                
                //exit loop
                break;
            }
        }
    }
}

- (BOOL) isValid {
    return YES;
}

- (NSArray *) generateNextGameActions {
    return @[[self.factory createDestroyEnemyGroupsGameActionWithBoard:self.gameBoard]];
}

@end
