//
//  DestroyEnemyGroupsGameAction.m
//  BlindWizardApp
//
//  Created by N A on 7/4/15.
//  Copyright (c) 2015 Adronitis. All rights reserved.
//

#import "DestroyEnemyGroupsGameAction.h"

@implementation DestroyEnemyGroupsGameAction

- (void) execute {
    /*
    NSMutableArray *rowsToDestroy = [NSMutableArray new];
    NSMutableArray *columnsToDestroy = [NSMutableArray new];
    NSMutableArray *indicesToDestroy = [NSMutableArray new];
    
    //scan rows for 3+
    for(NSInteger row=0; row<self.numRows; row++) {
        //reset
        NSInteger lastType = 0;
        NSInteger count = 1;
        
        //scan through columns
        for(NSInteger column=0; column<self.numColumns; column++) {
            //current
            NSInteger index = [self indexFromRow:row column:column];
            NSInteger n = [[self.data objectAtIndex:index] integerValue];
            
            if(n != 0 && lastType == n) {
                //same type, increment counter
                count++;
            }else {
                //new type or 0
                
                //set to be destroyed
                if(count >= 3) {
                    //loop connected objects
                    for(NSInteger c=column-count; c<column; c++) {
                        NSNumber *indexToDestroy = @([self indexFromRow:row column:c]);
                        if(![indicesToDestroy containsObject:indexToDestroy]) {
                            //add to be destroyed
                            [indicesToDestroy addObject:indexToDestroy];
                            [rowsToDestroy addObject:@(row)];
                            [columnsToDestroy addObject:@(c)];
                        }
                    }
                }
                
                //set to new type
                lastType = n;
                count = 1;
            }
        }
        
        //end row, set to be destroyed
        if(count >= 3) {
            //loop connected objects
            for(NSInteger c=self.numColumns-count; c<self.numColumns; c++) {
                NSNumber *indexToDestroy = @([self indexFromRow:row column:c]);
                if(![indicesToDestroy containsObject:indexToDestroy]) {
                    //add to be destroyed
                    [indicesToDestroy addObject:indexToDestroy];
                    [rowsToDestroy addObject:@(row)];
                    [columnsToDestroy addObject:@(c)];
                }
            }
        }
    }
    
    //scan columns for 3+
    for(NSInteger column=0; column<self.numColumns; column++) {
        //reset
        NSInteger lastType = 0;
        NSInteger count = 1;
        
        //scan through rows
        for(NSInteger row=0; row<self.numRows; row++) {
            //current
            NSInteger index = [self indexFromRow:row column:column];
            NSInteger n = [[self.data objectAtIndex:index] integerValue];
            
            if(n != 0 && lastType == n) {
                //same type, increment counter
                count++;
            }else {
                //new type or 0
                
                //set to be destroyed
                if(count >= 3) {
                    //loop connected objects
                    for(NSInteger r=row-count; r<row; r++) {
                        NSNumber *indexToDestroy = @([self indexFromRow:r column:column]);
                        if(![indicesToDestroy containsObject:indexToDestroy]) {
                            //add to be destroyed
                            [indicesToDestroy addObject:indexToDestroy];
                            [rowsToDestroy addObject:@(r)];
                            [columnsToDestroy addObject:@(column)];
                        }
                    }
                }
                
                //set to new type
                lastType = n;
                count = 1;
            }
        }
        
        //end column, set to be destroyed
        if(count >= 3) {
            for(NSInteger r=self.numRows-count; r<self.numRows; r++) {
                NSNumber *indexToDestroy = @([self indexFromRow:r column:column]);
                if(![indicesToDestroy containsObject:indexToDestroy]) {
                    //add to be destroyed
                    [indicesToDestroy addObject:indexToDestroy];
                    [rowsToDestroy addObject:@(r)];
                    [columnsToDestroy addObject:@(column)];
                }
            }
        }
    }
    
    //remove and notify
    for(int i=0; i<indicesToDestroy.count; i++) {
        //remove from data
        NSInteger index = [[indicesToDestroy objectAtIndex:i] integerValue];
        [self.data setObject:@0 atIndexedSubscript:index];
        
        //notify
        [[NSNotificationCenter defaultCenter] postNotificationName:GameUpdateDestroyEnemy
                                                            object:self
                                                          userInfo:@{
                                                                     @"row" : [rowsToDestroy objectAtIndex:i],
                                                                     @"column" : [columnsToDestroy objectAtIndex:i]
                                                                     }];
    }
    */
}

- (BOOL) isValid {
    return NO;
}

- (NSArray *) generateNextGameActions {
    return @[[self.factory createDropEnemiesDownGameActionWithBoard:self.gameBoard]];
}

@end
