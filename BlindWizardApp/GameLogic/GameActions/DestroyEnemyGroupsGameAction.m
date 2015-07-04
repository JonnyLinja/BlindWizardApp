//
//  DestroyEnemyGroupsGameAction.m
//  BlindWizardApp
//
//  Created by N A on 7/4/15.
//  Copyright (c) 2015 Adronitis. All rights reserved.
//

#import "DestroyEnemyGroupsGameAction.h"

@implementation DestroyEnemyGroupsGameAction

- (void) execute {
    
}

- (BOOL) isValid {
    return NO;
}

- (NSArray *) generateNextGameActions {
    return @[[self.factory createDropEnemiesDownGameActionWithBoard:self.gameBoard]];
}

@end
