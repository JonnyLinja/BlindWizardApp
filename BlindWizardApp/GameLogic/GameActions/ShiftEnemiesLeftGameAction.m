//
//  ShiftEnemiesLeftGameAction.m
//  BlindWizardApp
//
//  Created by N A on 7/4/15.
//  Copyright (c) 2015 Adronitis. All rights reserved.
//

#import "ShiftEnemiesLeftGameAction.h"
#import "GameDependencyFactory.h"
#import "GameBoard.h"
#import "GameConstants.h"

@interface ShiftEnemiesLeftGameAction ()
@property (nonatomic, assign) NSInteger row;
@property (nonatomic, strong) id<GameDependencyFactory> factory; //inject
@property (nonatomic, strong) GameBoard *gameBoard; //inject
@property (nonatomic, assign) CGFloat duration; //inject
@end

@implementation ShiftEnemiesLeftGameAction

- (id) initWithRow:(NSInteger)row gameBoard:(GameBoard *)board factory:(id<GameDependencyFactory>)factory duration:(CGFloat)duration {
    self = [super init];
    if(!self) return nil;
    
    self.row = row;
    self.gameBoard = board;
    self.factory = factory;
    self.duration = duration;
    
    return self;
}

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
        if([n integerValue] <= 0) {
            //do not shift negatives or 0 on top of negatives
            NSNumber *lastNumber = [self.gameBoard.data objectAtIndex:index-1];
            if([lastNumber integerValue] > 0) {
                [self.gameBoard.data setObject:@0 atIndexedSubscript:index-1];
            }
        }else {
            //shift
            [self.gameBoard.data setObject:n atIndexedSubscript:index-1];
            
            //notify
            [[NSNotificationCenter defaultCenter] postNotificationName:GameUpdateShiftEnemyLeft
                                                                object:self
                                                              userInfo:@{
                                                                         @"row" : castedRow,
                                                                         @"column" : @(column)
                                                                         }];
        }
    }
    
    //move to tail
    if([head integerValue] <= 0) {
        //do not shift negatives or 0 on top of negatives
        NSNumber *lastNumber = [self.gameBoard.data objectAtIndex:index-1];
        if([lastNumber integerValue] > 0) {
            [self.gameBoard.data setObject:@0 atIndexedSubscript:index-1];
        }
    }else {
        //shift
        [self.gameBoard.data setObject:head atIndexedSubscript:index-1];
        
        //notify
        [[NSNotificationCenter defaultCenter] postNotificationName:GameUpdateMoveEnemyToRowTail
                                                            object:self
                                                          userInfo:@{
                                                                     @"row" : castedRow,
                                                                     @"column" : @0
                                                                     }];
    }
}

- (BOOL) isValid {
    //start index
    NSInteger index = self.row*self.gameBoard.numColumns;
    
    //scan columns of row
    for(NSInteger column=0; column<self.gameBoard.numColumns; column++,index++) {
        //current
        NSNumber *n = [self.gameBoard.data objectAtIndex:index];
        
        //check valid
        if([n integerValue] > 0) {
            return YES;
        }
    }
    
    //invalid
    return NO;
}

- (NSArray *) generateNextGameActions {
    return @[
             [self.factory destroyEnemyGroupsGameActionWithBoard:self.gameBoard],
             [self.factory dropEnemiesDownGameActionWithBoard:self.gameBoard]
             ];
}

@end
