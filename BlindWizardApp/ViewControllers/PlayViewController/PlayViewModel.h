//
//  PlayViewModel.h
//  BlindWizardApp
//
//  Created by N A on 6/25/15.
//  Copyright (c) 2015 Adronitis. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Game;

@interface PlayViewModel : NSObject
@property (nonatomic, strong) Game *game; //inject
@property (nonatomic, assign, readonly) BOOL gameInProgress;
@property (nonatomic, strong, readonly) NSString *score;
- (void) callNextWave;
- (void) startGame;
@end