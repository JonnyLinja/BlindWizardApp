//
//  DropEnemiesDownGameAction.m
//  BlindWizardApp
//
//  Created by N A on 7/4/15.
//  Copyright (c) 2015 Adronitis. All rights reserved.
//

#import "DropEnemiesDownGameAction.h"
#import "GameBoard.h"
#import "GameConstants.h"

@implementation DropEnemiesDownGameAction

- (NSInteger) indexFromRow:(NSInteger)row column:(NSInteger)column {
    return (row * self.gameBoard.numColumns) + column;
}

- (void) execute {
    //loop through columns
    for(NSInteger column=0; column<self.gameBoard.numColumns; column++) {
        NSInteger replaceIndex = -1;
        NSInteger toRow = -1;
        
        //loop through rows of that column
        for(NSInteger row=0; row<self.gameBoard.numRows; row++) {
            //current
            NSInteger index = [self indexFromRow:row column:column];
            NSNumber *n = [self.gameBoard.data objectAtIndex:index];
            
            if(replaceIndex == -1) {
                //nothing to replace yet
                
                if([n integerValue] == 0) {
                    //it's 0, need to replace it
                    replaceIndex = index;
                    toRow = row;
                }
            }else {
                //searching to replace
                
                if([n integerValue] != 0) {
                    //found something
                    
                    //replace
                    [self.gameBoard.data setObject:n atIndexedSubscript:replaceIndex];
                    [self.gameBoard.data setObject:@0 atIndexedSubscript:index];
                    
                    //notify
                    [[NSNotificationCenter defaultCenter] postNotificationName:GameUpdateDropEnemyDown
                                                                        object:self
                                                                      userInfo:@{
                                                                                 @"column" : @(column),
                                                                                 @"fromRow" : @(row),
                                                                                 @"toRow" : @(toRow)
                                                                                 }];
                    //update vars
                    replaceIndex = index;
                    toRow = row;
                }
            }
        }
    }
}

- (BOOL) isValid {
    //scan columns
    for(NSInteger column=0; column<self.gameBoard.numColumns; column++) {
        BOOL atLeastOneEmpty = NO;
        
        //scan rows
        for(NSInteger row=0; row<self.gameBoard.numRows; row++) {
            //current
            NSInteger index = [self indexFromRow:row column:column];
            NSInteger n = [[self.gameBoard.data objectAtIndex:index] integerValue];
            
            if(!atLeastOneEmpty && n == 0) {
                //found at least one empty
                atLeastOneEmpty = YES;
            }else if(atLeastOneEmpty && n != 0) {
                //found something to drop
                return YES;
            }
        }
    }
    
    return NO;
}

- (CGFloat) duration {
    return 0.3;
}

- (NSArray *) generateNextGameActions {
    return @[[self.factory createDestroyEnemyGroupsGameActionWithBoard:self.gameBoard]];
}

@end
