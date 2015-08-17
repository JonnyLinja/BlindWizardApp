//
//  RepositionEnemyOutlinesGameAction.m
//  BlindWizardApp
//
//  Created by N A on 8/14/15.
//  Copyright (c) 2015 Adronitis. All rights reserved.
//

#import "RepositionEnemyOutlinesGameAction.h"
#import "GameBoard.h"
#import "GameConstants.h"

@interface RepositionEnemyOutlinesGameAction ()
@property (nonatomic, strong) GameBoard *gameBoard; //inject
@end

@implementation RepositionEnemyOutlinesGameAction
@synthesize duration;

- (id) initWithGameBoard:(GameBoard *)board {
    self = [super init];
    if(!self) return nil;
    
    self.gameBoard = board;
    
    return self;
}

- (void) execute {
    //loop columns
    for(NSInteger column=0; column<self.gameBoard.numColumns; column++) {
        NSInteger currentPosition = [self currentPositionOfOutlineInColumn:column];
        NSInteger correctRow = [self correctRowOfOutlineInColumn:column];
        NSInteger correctPosition = -1;
        if(correctRow != -1) {
            correctPosition = [self.gameBoard indexFromRow:correctRow column:column];
        }
        
        //update and notify
        if(currentPosition != correctPosition) {
            //remove old position
            if(currentPosition != -1) {
                [self.gameBoard.data setObject:@0 atIndexedSubscript:currentPosition];
            }
            
            //set new position
            NSNumber *outlineValue = [self.gameBoard.nextWaveData objectAtIndex:column];
            [self.gameBoard.data setObject:outlineValue atIndexedSubscript:correctPosition];
            
            //notify
            [[NSNotificationCenter defaultCenter] postNotificationName:GameUpdateRepositionEnemyOutline
                                                                object:self
                                                              userInfo:@{
                                                                         @"column" : @(column),
                                                                         @"row" : @(correctRow),
                                                                         }];
        }
    }
}

//-1 means it wasn't found
- (NSInteger) currentPositionOfOutlineInColumn:(NSInteger)column {
    //loop through rows
    for(NSInteger row=self.gameBoard.numRows-1; row>=0; row--) {
        //index
        NSInteger index = [self.gameBoard indexFromRow:row column:column];
        
        //found
        if([[self.gameBoard.data objectAtIndex:index] integerValue] < 0) {
            return index;
        }
    }
    
    //not found
    return -1;
}

- (NSInteger) correctRowOfOutlineInColumn:(NSInteger)column {
    //loop through rows
    for(NSInteger row=self.gameBoard.numRows-1; row>=0; row--) {
        //index
        NSInteger index = [self.gameBoard indexFromRow:row column:column];
        
        //found
        if([[self.gameBoard.data objectAtIndex:index] integerValue] > 0) {
            //initial row, return -1
            if(row == self.gameBoard.numRows-1)
                return -1;
            
            //return the row above
            return row+1;
        }
    }
    
    //empty column, return first row
    return 0;
}

- (BOOL) isValid {
    return YES;
}

- (NSArray *) generateNextGameActions {
    return nil;
}

@end
