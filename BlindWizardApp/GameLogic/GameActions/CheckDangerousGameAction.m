//
//  CheckDangerousGameAction.m
//  BlindWizardApp
//
//  Created by N A on 7/10/15.
//  Copyright (c) 2015 Adronitis. All rights reserved.
//

#import "CheckDangerousGameAction.h"
#import "GameBoard.h"
#import "GameConstants.h"

@interface CheckDangerousGameAction ()
@property (nonatomic, strong) GameBoard *gameBoard; //inject
@end

@implementation CheckDangerousGameAction

- (id) initWithGameBoard:(GameBoard *)board {
    self = [super init];
    if(!self) return nil;
    
    self.gameBoard = board;
    
    return self;
}

- (void) execute {
    //loop through columns
    for(NSInteger column=0; column<self.gameBoard.numColumns; column++) {
        NSString *notificationName;
        if([self isDangerousColumn:column]) {
            notificationName = GameUpdateMarkEnemyAsDangerous;
        }else {
            notificationName = GameUpdateMarkEnemyAsHarmless;
        }
        
        //loop through rows
        for(NSInteger row=0; row<self.gameBoard.numRows; row++) {
            //index
            NSInteger index = [self.gameBoard indexFromRow:row column:column];
            
            if([[self.gameBoard.data objectAtIndex:index] integerValue] != 0) {
                //found, notify
                [[NSNotificationCenter defaultCenter] postNotificationName:notificationName
                                                                    object:self
                                                                  userInfo:@{
                                                                             @"row" : @(row),
                                                                             @"column" : @(column)
                                                                             }];
                    
            }else {
                //no more enemies
                break;
            }
        }
    }
}

- (BOOL) isDangerousColumn:(NSInteger)column {
    NSInteger topIndex = [self.gameBoard indexFromRow:self.gameBoard.numRows-1 column:column];
    NSInteger secondTopIndex = [self.gameBoard indexFromRow:self.gameBoard.numRows-2 column:column];
    return ([[self.gameBoard.data objectAtIndex:topIndex] integerValue] != 0 || [[self.gameBoard.data objectAtIndex:secondTopIndex] integerValue] != 0);
}

- (BOOL) isValid {
    return YES;
}

- (NSArray *) generateNextGameActions {
    return nil;
}

@end
