//
//  LoadInitialEnemiesGameAction.m
//  BlindWizardApp
//
//  Created by N A on 7/10/15.
//  Copyright (c) 2015 Adronitis. All rights reserved.
//

#import "LoadInitialEnemiesGameAction.h"
#import "GameDependencyFactory.h"
#import "RandomGenerator.h"
#import "GameBoard.h"
#import "GameConstants.h"

@interface LoadInitialEnemiesGameAction ()
@property (nonatomic, strong) id<GameDependencyFactory> factory; //inject
@property (nonatomic, strong) GameBoard *gameBoard; //inject
@property (nonatomic, strong) RandomGenerator *randomGenerator; //inject
@end

@implementation LoadInitialEnemiesGameAction

- (id) initWithGameBoard:(GameBoard *)board factory:(id<GameDependencyFactory>)factory randomGenerator:(RandomGenerator *)randomGenerator{
    self = [super init];
    if(!self) return nil;
    
    self.gameBoard = board;
    self.factory = factory;
    self.randomGenerator = randomGenerator;
    
    return self;
}

- (void) execute {
    //index
    NSInteger index = -1;
    
    //first row
    [self.gameBoard.data setObject:@1 atIndexedSubscript:0];
    [self.gameBoard.data setObject:@3 atIndexedSubscript:1];
    [self.gameBoard.data setObject:@2 atIndexedSubscript:2];
    
    //second row
    index = [self.gameBoard indexFromRow:1 column:0];
    [self.gameBoard.data setObject:@3 atIndexedSubscript:index++];
    [self.gameBoard.data setObject:@1 atIndexedSubscript:index++];
    [self.gameBoard.data setObject:@2 atIndexedSubscript:index];

    //third row
    index = [self.gameBoard indexFromRow:2 column:0];
    [self.gameBoard.data setObject:@1 atIndexedSubscript:index++];
    [self.gameBoard.data setObject:@3 atIndexedSubscript:index++];
    [self.gameBoard.data setObject:@1 atIndexedSubscript:index];
    
    for(NSInteger row=0; row<3; row++) {
        //notify first few
        index = [self.gameBoard indexFromRow:row column:0];
        for(NSInteger column=0; column<3; column++) {
            //notify
            [[NSNotificationCenter defaultCenter] postNotificationName:GameUpdateCreateEnemy
                                                                object:self
                                                              userInfo:@{
                                                                         @"column" : @(column),
                                                                         @"row" : @(row),
                                                                         @"type" : [self.gameBoard.data objectAtIndex:index++]
                                                                         }];
        }
        
        //generate rest
        index = [self.gameBoard indexFromRow:row column:3];
        for(NSInteger column=3; column<self.gameBoard.numColumns; column++, index++) {
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
        }
    }
}

- (BOOL) isValid {
    return YES;
}

- (NSArray *) generateNextGameActions {
    return @[
             [self.factory createEnemyOutlinesGameActionWithBoard:self.gameBoard],
             [self.factory destroyEnemyGroupsGameActionWithBoard:self.gameBoard]
             ];
}

@end
