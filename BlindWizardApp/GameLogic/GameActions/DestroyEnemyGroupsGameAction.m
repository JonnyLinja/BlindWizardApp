//
//  DestroyEnemyGroupsGameAction.m
//  BlindWizardApp
//
//  Created by N A on 7/4/15.
//  Copyright (c) 2015 Adronitis. All rights reserved.
//

#import "DestroyEnemyGroupsGameAction.h"
#import "GameDependencyFactory.h"
#import "GameBoard.h"
#import "GameConstants.h"
#import "ScoreCalculator.h"

@interface DestroyEnemyGroupsGameAction ()
@property (nonatomic, strong) id<GameDependencyFactory> factory; //inject
@property (nonatomic, strong) GameBoard *gameBoard; //inject
@property (nonatomic, strong) ScoreCalculator *calculator; //inject
@end

@implementation DestroyEnemyGroupsGameAction

- (id) initWithGameBoard:(GameBoard *)board factory:(id<GameDependencyFactory>)factory scoreCalculator:(ScoreCalculator *)calculator {
    self = [super init];
    if(!self) return nil;
    
    self.gameBoard = board;
    self.factory = factory;
    self.calculator = calculator;
    
    return self;
}

- (void) execute {
    NSMutableArray *rowsToDestroy = [NSMutableArray new];
    NSMutableArray *columnsToDestroy = [NSMutableArray new];
    NSMutableArray *indicesToDestroy = [NSMutableArray new];
    
    //scan rows for 3+
    for(NSInteger row=0; row<self.gameBoard.numRows; row++) {
        //reset
        NSInteger lastType = 0;
        NSInteger count = 1;
        
        //scan through columns
        for(NSInteger column=0; column<self.gameBoard.numColumns; column++) {
            //current
            NSInteger index = [self.gameBoard indexFromRow:row column:column];
            NSInteger n = [[self.gameBoard.data objectAtIndex:index] integerValue];
            
            if(n > 0 && lastType == n) {
                //same type, increment counter
                count++;
            }else {
                //new type or <= 0
                
                //set to be destroyed
                if(count >= 3) {
                    //loop connected objects
                    for(NSInteger c=column-count; c<column; c++) {
                        NSNumber *indexToDestroy = @([self.gameBoard indexFromRow:row column:c]);
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
            for(NSInteger c=self.gameBoard.numColumns-count; c<self.gameBoard.numColumns; c++) {
                NSNumber *indexToDestroy = @([self.gameBoard indexFromRow:row column:c]);
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
    for(NSInteger column=0; column<self.gameBoard.numColumns; column++) {
        //reset
        NSInteger lastType = 0;
        NSInteger count = 1;
        
        //scan through rows
        for(NSInteger row=0; row<self.gameBoard.numRows; row++) {
            //current
            NSInteger index = [self.gameBoard indexFromRow:row column:column];
            NSInteger n = [[self.gameBoard.data objectAtIndex:index] integerValue];
            
            if(n > 0 && lastType == n) {
                //same type, increment counter
                count++;
            }else {
                //new type or <= 0
                
                //set to be destroyed
                if(count >= 3) {
                    //loop connected objects
                    for(NSInteger r=row-count; r<row; r++) {
                        NSNumber *indexToDestroy = @([self.gameBoard indexFromRow:r column:column]);
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
            for(NSInteger r=self.gameBoard.numRows-count; r<self.gameBoard.numRows; r++) {
                NSNumber *indexToDestroy = @([self.gameBoard indexFromRow:r column:column]);
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
    NSInteger score = [self.calculator calculateScorePerEnemyAfterDestroying:indicesToDestroy.count];
    for(int i=0; i<indicesToDestroy.count; i++) {
        //remove from data
        NSInteger index = [[indicesToDestroy objectAtIndex:i] integerValue];
        [self.gameBoard.data setObject:@0 atIndexedSubscript:index];
        
        //notify
        [[NSNotificationCenter defaultCenter] postNotificationName:GameUpdateDestroyEnemy
                                                            object:self
                                                          userInfo:@{
                                                                     @"row" : [rowsToDestroy objectAtIndex:i],
                                                                     @"column" : [columnsToDestroy objectAtIndex:i],
                                                                     @"score" : @(score)
                                                                     }];
    }
    
    //score
    self.gameBoard.score += [self.calculator calculateTotalScoreFromNumberOfEnemiesDestroyed:indicesToDestroy.count];
}

- (BOOL) isValid {
    //scan rows
    NSInteger index = 0;
    NSInteger lastValue;
    NSInteger count;
    
    //scan horizontal groups of 3
    for(NSInteger row=0; row<self.gameBoard.numRows; row++) {
        //reset
        lastValue = -1;
        count = 0;
        
        //loop columns
        for(NSInteger column=0; column<self.gameBoard.numColumns; column++, index++) {
            //current
            NSInteger current = [[self.gameBoard.data objectAtIndex:index] integerValue];
            
            if(current > 0 && lastValue != current) {
                //new current value
                lastValue = current;
                count = 1;
            }else if(lastValue > 0 && lastValue == current) {
                //update count
                count++;
            }else if(current <= 0) {
                //reset
                lastValue = -1;
                count = 0;
            }
            
            //valid
            if(count >= 3) {
                return YES;
            }
        }
    }
    
    //scan vertical groups of 3
    for(NSInteger column=0; column<self.gameBoard.numColumns; column++) {
        //reset
        index = column;
        lastValue = -1;
        count = 0;
        
        //loop rows
        for(NSInteger row=0; row<self.gameBoard.numRows; row++, index+=self.gameBoard.numColumns) {
            //current
            NSInteger current = [[self.gameBoard.data objectAtIndex:index] integerValue];
            
            if(current > 0 && lastValue != current) {
                //new current value
                lastValue = current;
                count = 1;
            }else if(lastValue > 0 && lastValue == current) {
                //update count
                count++;
            }else if(current <= 0) {
                //reset
                lastValue = -1;
                count = 0;
            }
            
            //valid
            if(count >= 3) {
                return YES;
            }
        }
    }
    
    //invalid
    return NO;
}

- (NSArray *) generateNextGameActions {
    return @[[self.factory dropEnemiesDownGameActionWithBoard:self.gameBoard]];
}

@end
