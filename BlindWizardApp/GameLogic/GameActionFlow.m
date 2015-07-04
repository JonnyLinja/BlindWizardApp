//
//  GameActionFlow.m
//  BlindWizardApp
//
//  Created by N A on 7/1/15.
//  Copyright (c) 2015 Adronitis. All rights reserved.
//

#import "GameActionFlow.h"
#import "GameActionQueue.h"

@interface GameActionFlow ()
@property (nonatomic, assign) BOOL isReady;
@end

@implementation GameActionFlow

- (void) commandCallNextWave {
    [self.gameActionQueue pushCommandCallNextWave];
}

- (void) commandSwipeLeftOnRow:(NSInteger)row {
    [self.gameActionQueue pushCommandSwipeLeftOnRow:row];
}

- (void) commandSwipeRightOnRow:(NSInteger)row {
    [self.gameActionQueue pushCommandSwipeRightOnRow:row];
}

@end
