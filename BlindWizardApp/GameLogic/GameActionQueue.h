//
//  GameActionQueue.h
//  BlindWizardApp
//
//  Created by N A on 7/2/15.
//  Copyright (c) 2015 Adronitis. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GameActionQueue : NSObject
- (BOOL) hasGameAction;
- (void) pop;
- (void) pushCommandCallNextWave;
- (void) pushCommandSwipeLeftOnRow:(NSInteger)row;
- (void) pushCommandSwipeRightOnRow:(NSInteger)row;
@end
