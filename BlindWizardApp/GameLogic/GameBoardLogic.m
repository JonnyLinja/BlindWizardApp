//
//  GameBoardLogic.m
//  BlindWizardApp
//
//  Created by N A on 6/30/15.
//  Copyright (c) 2015 Adronitis. All rights reserved.
//

#import "GameBoardLogic.h"
#import "RandomGenerator.h"

@implementation GameBoardLogic

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
            [[NSNotificationCenter defaultCenter] postNotificationName:[GameBoardLogic ShiftLeftNotificationName]
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
        [[NSNotificationCenter defaultCenter] postNotificationName:[GameBoardLogic MoveToRowTailNotificationName]
                                                            object:self
                                                          userInfo:@{
                                                                     @"row" : castedRow,
                                                                     @"column" : @0
                                                                     }];
    }
}

- (void) executeShiftRightOnRow:(NSInteger)row {
    NSNumber *castedRow = @(row);
    NSInteger index = ((row+1)*self.numColumns)-1;
    NSNumber *tail = [_data objectAtIndex:index];
    index--;
    
    //shift right
    for(NSInteger column=self.numColumns-2; column>=0; column--,index--) {
        //data
        NSNumber *n = [self.data objectAtIndex:index];

        //save
        [self.data setObject:n atIndexedSubscript:index+1];
        
        //notify
        if([n integerValue] != 0) {
            [[NSNotificationCenter defaultCenter] postNotificationName:[GameBoardLogic ShiftRightNotificationName]
                                                                object:self
                                                              userInfo:@{
                                                                         @"row" : castedRow,
                                                                         @"column" : @(column)
                                                                         }];
        }
    }
    
    //move to head
    [self.data setObject:tail atIndexedSubscript:index+1];
    
    //notify
    if([tail integerValue] != 0) {
        [[NSNotificationCenter defaultCenter] postNotificationName:[GameBoardLogic MoveToRowHeadNotificationName]
                                                            object:self
                                                          userInfo:@{
                                                                     @"row" : castedRow,
                                                                     @"column" : @(self.numColumns-1)
                                                                     }];
    }
}

- (void) executeDrop {
    //loop through columns
    for(NSInteger column=0; column<self.numColumns; column++) {
        NSInteger replaceIndex = -1;
        NSInteger toRow = -1;
        
        //loop through rows of that column
        for(NSInteger row=0; row<self.numRows; row++) {
            //current
            NSInteger index = (row * self.numColumns) + column;
            NSNumber *n = [self.data objectAtIndex:index];
            
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
                    [self.data setObject:n atIndexedSubscript:replaceIndex];
                    [self.data setObject:@0 atIndexedSubscript:index];
                    
                    //notify
                    [[NSNotificationCenter defaultCenter] postNotificationName:[GameBoardLogic DropNotificationName]
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

- (void) executeCreate {
    //loop through columns
    for(NSInteger column=0; column<self.numColumns; column++) {
        //loop through rows of that column
        for(NSInteger row=0; row<self.numRows; row++) {
            //current
            NSInteger index = (row * self.numColumns) + column;
            NSNumber *n = [self.data objectAtIndex:index];
            
            if([n integerValue] == 0) {
                //found a free spot
                
                //add
                NSNumber *newNumber = @([self.randomGenerator generateRandomType]);
                [self.data setObject:newNumber atIndexedSubscript:index];
                
                //notify
                [[NSNotificationCenter defaultCenter] postNotificationName:[GameBoardLogic CreateNotificationName]
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

- (void) executeDestroy {
    
}

@end
