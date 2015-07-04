//
//  ShiftEnemiesLeftGameAction.m
//  BlindWizardApp
//
//  Created by N A on 7/4/15.
//  Copyright (c) 2015 Adronitis. All rights reserved.
//

#import "ShiftEnemiesLeftGameAction.h"

@implementation ShiftEnemiesLeftGameAction

- (void) execute {
    
}

- (BOOL) isValid {
    return NO;
}

- (CGFloat) duration {
    return 1;
}

- (NSArray *) generateNextGameActions {
    return @[
             [self.factory createDropEnemiesDownGameActionWithBoard:self.gameBoard],
             [self.factory createDestroyEnemyGroupsGameActionWithBoard:self.gameBoard]
             ];
}

@end
