//
//  CallNextWaveGameAction.m
//  BlindWizardApp
//
//  Created by N A on 7/3/15.
//  Copyright (c) 2015 Adronitis. All rights reserved.
//

#import "CallNextWaveGameAction.h"
#import "GameDependencyFactory.h"
#import "GameBoard.h"
#import "GameConstants.h"

@interface CallNextWaveGameAction ()
@property (nonatomic, strong) id<GameDependencyFactory> factory; //inject
@property (nonatomic, strong) GameBoard *gameBoard; //inject
@end

@implementation CallNextWaveGameAction

- (id) initWithGameBoard:(GameBoard *)board factory:(id<GameDependencyFactory>)factory {
    self = [super init];
    if(!self) return nil;
    
    self.gameBoard = board;
    self.factory = factory;
    
    return self;
}

- (void) execute {
    //loop through columns
    for(NSInteger column=0; column<self.gameBoard.numColumns; column++) {
        //loop through rows of that column
        for(NSInteger row=0; row<self.gameBoard.numRows; row++) {
            //current
            NSInteger index = [self.gameBoard indexFromRow:row column:column];
            NSNumber *n = [self.gameBoard.data objectAtIndex:index];
            
            if([n integerValue] < 0) {
                //found a negative
                
                //flip
                NSNumber *newNumber = @([n integerValue]*-1);
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
    
    [[NSNotificationCenter defaultCenter] postNotificationName:GameActionCallNextWaveComplete object:self];
}

- (BOOL) isValid {
    return YES;
}

- (NSArray *) generateNextGameActions {
    return @[
             [self.factory createEnemyOutlinesGameActionWithBoard:self.gameBoard],
             [self.factory checkDangerousGameActionWithBoard:self.gameBoard],
             [self.factory checkLoseGameActionWithBoard:self.gameBoard],
             [self.factory destroyEnemyGroupsGameActionWithBoard:self.gameBoard],
             ];
}

@end
