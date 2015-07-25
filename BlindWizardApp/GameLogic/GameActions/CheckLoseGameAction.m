//
//  CheckLoseGameAction.m
//  BlindWizardApp
//
//  Created by N A on 7/4/15.
//  Copyright (c) 2015 Adronitis. All rights reserved.
//

#import "CheckLoseGameAction.h"
#import "GameBoard.h"

@interface CheckLoseGameAction ()
@property (nonatomic, strong) GameBoard *gameBoard; //inject
@end

@implementation CheckLoseGameAction

- (id) initWithGameBoard:(GameBoard *)board {
    self = [super init];
    if(!self) return nil;
    
    self.gameBoard = board;
    
    return self;
}

- (void) execute {
    //index
    NSInteger index = [self.gameBoard indexFromRow:self.gameBoard.numRows-1 column:0];
    
    //loop
    for(NSInteger column=0; column<self.gameBoard.numColumns; column++, index++) {
        //current
        NSInteger current = [[self.gameBoard.data objectAtIndex:index] integerValue];
        
        //lose
        if(current > 0) {
            self.gameBoard.isActive = NO;
            return;
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
