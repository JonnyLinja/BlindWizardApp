//
//  DropEnemiesDownGameAction.m
//  BlindWizardApp
//
//  Created by N A on 7/4/15.
//  Copyright (c) 2015 Adronitis. All rights reserved.
//

#import "DropEnemiesDownGameAction.h"

@implementation DropEnemiesDownGameAction

- (void) execute {
    
}

- (BOOL) isValid {
    return NO;
}

- (CGFloat) duration {
    return 0.3;
}

- (NSArray *) generateNextGameActions {
    return @[[self.factory createDestroyEnemyGroupsGameActionWithBoard:self.gameBoard]];
}

@end
