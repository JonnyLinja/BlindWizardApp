//
//  DropEnemiesDownGameAction.m
//  BlindWizardApp
//
//  Created by N A on 7/4/15.
//  Copyright (c) 2015 Adronitis. All rights reserved.
//

#import "DropEnemiesDownGameAction.h"
#import "GameDependencyFactory.h"
#import "GameBoard.h"
#import "GameConstants.h"

@interface DropEnemiesDownGameAction ()
@property (nonatomic, strong) id<GameDependencyFactory> factory; //inject
@property (nonatomic, strong) GameBoard *gameBoard; //inject
@property (nonatomic, assign) CGFloat delayDuration; //inject
@end

@implementation DropEnemiesDownGameAction

- (id) initWithGameBoard:(GameBoard *)board factory:(id<GameDependencyFactory>)factory duration:(CGFloat)duration {
    self = [super init];
    if(!self) return nil;
    
    self.gameBoard = board;
    self.factory = factory;
    self.delayDuration = duration;
    
    return self;
}

- (void) execute {
    //loop through columns
    for(NSInteger column=0; column<self.gameBoard.numColumns; column++) {
        NSInteger replaceIndex = -1;
        NSInteger toRow = -1;
        
        //loop through rows of that column
        for(NSInteger row=0; row<self.gameBoard.numRows; row++) {
            //current
            NSInteger index = [self.gameBoard indexFromRow:row column:column];
            NSNumber *n = [self.gameBoard.data objectAtIndex:index];
            
            if(replaceIndex == -1) {
                //nothing to replace yet
                
                if([n integerValue] <= 0) {
                    //it's 0, need to replace it
                    replaceIndex = index;
                    toRow = row;
                }
            }else {
                //searching to replace
                
                if([n integerValue] > 0) {
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
                    row = toRow;
                    replaceIndex = -1;
                    toRow = -1;
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
            NSInteger index = [self.gameBoard indexFromRow:row column:column];
            NSInteger n = [[self.gameBoard.data objectAtIndex:index] integerValue];
            
            if(!atLeastOneEmpty && n <= 0) {
                //found at least one empty
                atLeastOneEmpty = YES;
            }else if(atLeastOneEmpty && n > 0) {
                //valid
                return YES;
            }
        }
    }
    
    //invalid
    return NO;
}

- (NSArray *) generateNextGameActions {
    return @[
             [self.factory repositionEnemyOutlinesGameActionWithBoard:self.gameBoard],
             [self.factory delayGameActionWithDuration:@(self.delayDuration)],
             [self.factory checkDangerousGameActionWithBoard:self.gameBoard],
             [self.factory destroyEnemyGroupsGameActionWithBoard:self.gameBoard]
             ];
}

@end
