//
//  RepositionEnemyOutlinesGameAction.m
//  BlindWizardApp
//
//  Created by N A on 8/14/15.
//  Copyright (c) 2015 Adronitis. All rights reserved.
//

#import "RepositionEnemyOutlinesGameAction.h"

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
    
}

- (BOOL) isValid {
    return YES;
}

- (NSArray *) generateNextGameActions {
    return nil;
}

@end
