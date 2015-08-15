//
//  CreateEnemyOutlinesGameAction.m
//  BlindWizardApp
//
//  Created by N A on 8/5/15.
//  Copyright (c) 2015 Adronitis. All rights reserved.
//

#import "CreateEnemyOutlinesGameAction.h"
#import "RandomGenerator.h"
#import "GameBoard.h"
#import "GameConstants.h"

@interface CreateEnemyOutlinesGameAction ()
@property (nonatomic, strong) GameBoard *gameBoard; //inject
@property (nonatomic, strong) RandomGenerator *randomGenerator; //inject
@end

@implementation CreateEnemyOutlinesGameAction

- (id) initWithGameBoard:(GameBoard *)board randomGenerator:(RandomGenerator *)randomGenerator {
    self = [super init];
    if(!self) return nil;
    
    self.gameBoard = board;
    self.randomGenerator = randomGenerator;
    
    return self;
}

- (void) execute {
    //array
    [self.gameBoard.nextWaveData removeAllObjects];
    
    //loop through columns
    for(NSInteger column=0; column<self.gameBoard.numColumns; column++) {
        //loop through rows of that column
        for(NSInteger row=0; row<self.gameBoard.numRows; row++) {
            //current
            NSInteger index = [self.gameBoard indexFromRow:row column:column];
            NSNumber *n = [self.gameBoard.data objectAtIndex:index];
            
            if([n integerValue] <= 0) {
                //found a free spot
                
                //add
                NSInteger newInteger = [self.randomGenerator generate];
                NSNumber *negativeNumber = @(-1*newInteger);
                NSNumber *positiveNumber = @(newInteger);
                [self.gameBoard.nextWaveData addObject:negativeNumber];
                [self.gameBoard.data setObject:negativeNumber atIndexedSubscript:index];
                
                //notify
                [[NSNotificationCenter defaultCenter] postNotificationName:GameUpdateCreateEnemyOutline
                                                                    object:self
                                                                  userInfo:@{
                                                                             @"column" : @(column),
                                                                             @"row" : @(row),
                                                                             @"type" : positiveNumber
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
    return nil;
}

@end
